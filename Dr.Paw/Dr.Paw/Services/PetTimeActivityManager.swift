//
//  PetTimeActivityManager.swift
//  Dr.Paw
//
//  Central manager for Dr.Paw Live Activities.
//

import ActivityKit
import Foundation

@MainActor
final class PetTimeActivityManager: ObservableObject {

    // MARK: - Shared Instance

    static let shared = PetTimeActivityManager()

    // MARK: - Configuration

    static let duration: TimeInterval = 30 * 60
    static let maximumConcurrentActivities = 3

    // MARK: - Published State

    /// UI-facing cache.
    ///
    /// ActivityKit remains the source of truth.
    /// This dictionary only mirrors currently active
    /// Live Activities so SwiftUI can react to them.
    @Published private(set) var timers: [String: PetTimer] = [:]

    // MARK: - Internal State

    /// Prevents multiple rapid taps from creating
    /// multiple Activities for the same pet.
    private var pendingStarts: Set<String> = []

    /// Keeps one lifecycle observer alive for each Activity.
    private var observationTasks: [String: Task<Void, Never>] = [:]

    // MARK: - Init

    private init() {
        refresh()
    }

    deinit {
        observationTasks.values.forEach { $0.cancel() }
    }

    // MARK: - Public Queries

    func timer(for petID: String) -> PetTimer? {
        timers[petID]
    }

    func canStartTimer(for petID: String) -> Bool {
        // A start is already being processed.
        if pendingStarts.contains(petID) {
            return false
        }

        let activeActivities = currentActiveActivities()

        // This pet already has a Live Activity.
        if activeActivities.contains(where: {
            $0.attributes.petID == petID
        }) {
            return false
        }

        // Respect the global Activity limit.
        return activeActivities.count < Self.maximumConcurrentActivities
    }

    // MARK: - Start

    func start(
        petID: String,
        petName: String,
        breed: String
    ) {

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are disabled.")
            return
        }

        // Prevent rapid double taps.
        guard !pendingStarts.contains(petID) else {
            print("Start ignored: \(petID) already has a pending start.")
            return
        }

        // ActivityKit is the source of truth.
        let existingActivities = currentActiveActivities().filter {
            $0.attributes.petID == petID
        }

        // Never create a second Activity for the same pet.
        if !existingActivities.isEmpty {
            print(
                "Start ignored: \(petID) already has an active Live Activity."
            )
            refresh()
            return
        }

        // Respect the global Activity limit.
        guard currentActiveActivities().count <
                Self.maximumConcurrentActivities else {

            print("Start ignored: maximum concurrent Live Activities reached.")
            refresh()
            return
        }

        pendingStarts.insert(petID)

        let startDate = Date()
        let endDate = startDate.addingTimeInterval(Self.duration)

        let attributes = PetTimeAttributes(
            petID: petID,
            petName: petName,
            breed: breed.isEmpty ? "Pet time" : breed,
            startDate: startDate
        )

        let state = PetTimeAttributes.ContentState(
            endDate: endDate,
            isPaused: false,
            pausedRemaining: 0
        )

        Task { @MainActor [weak self] in

            guard let self else {
                return
            }

            defer {
                self.pendingStarts.remove(petID)
            }

            // ---------------------------------------------------------
            // STEP 1
            // Re-check ActivityKit immediately before creation.
            // ---------------------------------------------------------

            let existing = self.currentActiveActivities().filter {
                $0.attributes.petID == petID
            }

            if !existing.isEmpty {
                print(
                    "Start cancelled: Activity already exists for \(petID)."
                )
                self.refresh()
                return
            }

            // ---------------------------------------------------------
            // STEP 2
            // Check for stale/duplicate Activities.
            //
            // Normally this should already be empty because the checks
            // above use ActivityKit directly.
            // ---------------------------------------------------------

            let activitiesForPet = Activity<PetTimeAttributes>.activities
                .filter {
                    $0.attributes.petID == petID
                }

            let activeActivitiesForPet = activitiesForPet.filter {
                $0.activityState == .active
            }

            if !activeActivitiesForPet.isEmpty {
                print(
                    "Start cancelled: \(petID) already has an Activity."
                )
                self.refresh()
                return
            }

            // ---------------------------------------------------------
            // STEP 3
            // Final global-limit check.
            // ---------------------------------------------------------

            guard self.currentActiveActivities().count <
                    Self.maximumConcurrentActivities else {

                print("Start cancelled: Activity limit reached.")
                self.refresh()
                return
            }

            // ---------------------------------------------------------
            // STEP 4
            // Create the actual Live Activity.
            // ---------------------------------------------------------

            do {

                let content = ActivityContent(
                    state: state,
                    staleDate: endDate
                )

                let activity = try Activity<PetTimeAttributes>.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )

                print(
                    """
                    Live Activity started.
                    Pet: \(petName)
                    ID: \(activity.id)
                    End: \(endDate)
                    """
                )

                // Immediately synchronize our UI cache.
                self.refresh()

                // Observe this exact Activity.
                self.observe(activity)

            } catch {

                print(
                    """
                    Failed to start Live Activity.
                    Pet: \(petName)
                    Error: \(error)
                    """
                )

                self.refresh()
            }
        }
    }

    // MARK: - Pause

    func pause(petID: String) {

        guard let activity = activity(for: petID) else {
            print(
                "Pause ignored: no active Activity found for \(petID)."
            )
            refresh()
            return
        }

        guard !activity.content.state.isPaused else {
            return
        }

        let remaining = max(
            activity.content.state.endDate.timeIntervalSinceNow,
            0
        )

        guard remaining > 0 else {
            end(activity)
            return
        }

        let pausedState = PetTimeAttributes.ContentState(
            endDate: Date(),
            isPaused: true,
            pausedRemaining: remaining
        )

        Task { @MainActor [weak self] in

            guard let self else {
                return
            }

            await activity.update(
                ActivityContent(
                    state: pausedState,
                    staleDate: nil
                )
            )

            print(
                "Live Activity paused: \(activity.id), remaining: \(remaining)"
            )

            self.refresh()
        }
    }

    // MARK: - Resume

    func resume(petID: String) {

        guard let activity = activity(for: petID) else {
            print(
                "Resume ignored: no active Activity found for \(petID)."
            )
            refresh()
            return
        }

        guard activity.content.state.isPaused else {
            return
        }

        let remaining = max(
            activity.content.state.pausedRemaining,
            0
        )

        guard remaining > 0 else {
            end(activity)
            return
        }

        let endDate = Date().addingTimeInterval(remaining)

        let resumedState = PetTimeAttributes.ContentState(
            endDate: endDate,
            isPaused: false,
            pausedRemaining: 0
        )

        Task { @MainActor [weak self] in

            guard let self else {
                return
            }

            await activity.update(
                ActivityContent(
                    state: resumedState,
                    staleDate: endDate
                )
            )

            print(
                "Live Activity resumed: \(activity.id), new end: \(endDate)"
            )

            self.refresh()
        }
    }

    // MARK: - Stop

    func stop(petID: String) {

        guard let activity = activity(for: petID) else {
            print(
                "Stop ignored: no active Activity found for \(petID)."
            )
            refresh()
            return
        }

        end(activity)
    }

    // MARK: - End Specific Activity

    private func end(
        _ activity: Activity<PetTimeAttributes>
    ) {

        Task { @MainActor [weak self] in

            guard let self else {
                return
            }

            print(
                "Ending Live Activity: \(activity.id)"
            )

            await activity.end(
                nil,
                dismissalPolicy: .immediate
            )

            self.cancelObservation(
                for: activity.id
            )

            self.refresh()
        }
    }

    // MARK: - End All

    /// Debug/recovery escape hatch.
    ///
    /// Ends every Dr.Paw Live Activity currently known to ActivityKit.
    func endAllActivities() {

        Task { @MainActor [weak self] in

            guard let self else {
                return
            }

            let activities = Array(
                Activity<PetTimeAttributes>.activities
            )

            print(
                "Ending \(activities.count) Dr.Paw Live Activity(s)."
            )

            for activity in activities {

                await activity.end(
                    nil,
                    dismissalPolicy: .immediate
                )

                self.cancelObservation(
                    for: activity.id
                )
            }

            self.timers.removeAll()
            self.pendingStarts.removeAll()

            self.refresh()
        }
    }

    // MARK: - Refresh

    /// Synchronizes the UI cache with ActivityKit.
    ///
    /// IMPORTANT:
    /// ActivityKit is always the source of truth.
    ///
    /// This method does NOT end an Activity simply because
    /// its timer reached zero.
    ///
    /// ActivityKit itself manages the Activity lifecycle.
    func refresh() {

        let activities = currentActiveActivities()

        // -------------------------------------------------------------
        // Build the UI cache only from currently ACTIVE Activities.
        // -------------------------------------------------------------

        var newTimers: [String: PetTimer] = [:]

        for activity in activities {

            let petID = activity.attributes.petID
            let state = activity.content.state

            // ---------------------------------------------------------
            // Ignore Activities whose timer has naturally reached zero.
            //
            // We deliberately DO NOT call activity.end() here.
            // This prevents refresh()/foreground lifecycle events
            // from being the thing that kills the Live Activity.
            // ---------------------------------------------------------

            if !state.isPaused &&
                state.endDate <= Date() {

                continue
            }

            if state.isPaused &&
                state.pausedRemaining <= 0 {

                continue
            }

            let timer = PetTimer(
                petID: petID,
                activityID: activity.id,
                endDate: state.endDate,
                isPaused: state.isPaused
            )

            // ---------------------------------------------------------
            // Duplicate protection.
            //
            // If ActivityKit somehow reports more than one Activity
            // for the same pet, NEVER use Dictionary(uniqueKeysWithValues:)
            // because that would crash the app.
            // ---------------------------------------------------------

            if let existing = newTimers[petID] {

                let existingDate = activitySortDate(
                    activityWithID: existing.activityID
                )

                let newDate = activity.attributes.startDate

                if let existingDate,
                   existingDate >= newDate {

                    print(
                        """
                        Duplicate Activity detected for \(petID).
                        Keeping existing Activity:
                        \(existing.activityID ?? "nil")
                        Ignoring new Activity:
                        \(activity.id)
                        """
                    )

                    continue
                }

                print(
                    """
                    Duplicate Activity detected for \(petID).
                    Replacing existing Activity:
                    \(existing.activityID ?? "nil")
                    With newer Activity:
                    \(activity.id)
                    """
                )
            }

            newTimers[petID] = timer

            // Observe the Activity lifecycle.
            observe(activity)
        }

        timers = newTimers
    }

    // MARK: - Activity Lookup

    private func activity(
        for petID: String
    ) -> Activity<PetTimeAttributes>? {

        let matchingActivities = currentActiveActivities()
            .filter {
                $0.attributes.petID == petID
            }

        // If duplicates somehow exist, use the newest Activity.
        return matchingActivities.max {
            $0.attributes.startDate < $1.attributes.startDate
        }
    }

    // MARK: - ActivityKit Source of Truth

    private func currentActiveActivities()
        -> [Activity<PetTimeAttributes>] {

        Activity<PetTimeAttributes>.activities.filter {
            $0.activityState == .active
        }
    }

    // MARK: - Activity Sorting

    private func activitySortDate(
        activityWithID activityID: String?
    ) -> Date? {

        guard let activityID else {
            return nil
        }

        return Activity<PetTimeAttributes>.activities
            .first(where: { $0.id == activityID })?
            .attributes
            .startDate
    }

    // MARK: - Activity Observation

    private func observe(
        _ activity: Activity<PetTimeAttributes>
    ) {

        let activityID = activity.id

        // Don't create duplicate observers.
        guard observationTasks[activityID] == nil else {
            return
        }

        observationTasks[activityID] = Task {
            @MainActor [weak self] in

            guard let self else {
                return
            }

            for await state in activity.activityStateUpdates {

                print(
                    "Activity \(activityID) state changed: \(state)"
                )

                switch state {

                case .active:

                    self.refresh()

                case .stale:

                    print(
                        "Activity \(activityID) became stale."
                    )

                    self.refresh()

                case .ended:

                    print(
                        "Activity \(activityID) ended."
                    )

                    self.cancelObservation(
                        for: activityID
                    )

                    self.refresh()

                case .dismissed:

                    print(
                        "Activity \(activityID) dismissed."
                    )

                    self.cancelObservation(
                        for: activityID
                    )

                    self.refresh()

                @unknown default:

                    self.refresh()
                }
            }

            self.cancelObservation(
                for: activityID
            )
        }
    }

    // MARK: - Observation Cleanup

    private func cancelObservation(
        for activityID: String
    ) {

        observationTasks[activityID]?.cancel()
        observationTasks[activityID] = nil
    }
}

// MARK: - Pet Timer

struct PetTimer: Identifiable, Equatable {

    let petID: String
    let activityID: String?
    let endDate: Date
    let isPaused: Bool

    var id: String {
        petID
    }
}
