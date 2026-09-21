//
//  PetTimeActivityManager.swift
//  Dr.Paw
//

import ActivityKit
import Foundation

@MainActor
final class PetTimeActivityManager: ObservableObject {
    static let shared = PetTimeActivityManager()

    static let duration: TimeInterval = 30 * 60
    static let maximumConcurrentActivities = 3

    @Published private(set) var timers: [String: PetTimer] = [:]

    private init() {
        refresh()
    }

    func timer(for petID: String) -> PetTimer? {
        timers[petID]
    }

    func canStartTimer(for petID: String) -> Bool {
        timers[petID] == nil && timers.count < Self.maximumConcurrentActivities
    }

    func start(petID: String, petName: String, breed: String) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled, canStartTimer(for: petID) else { return }

        let start = Date()
        let end = start.addingTimeInterval(Self.duration)
        let attributes = PetTimeAttributes(
            petID: petID,
            petName: petName,
            breed: breed.isEmpty ? "Pet time" : breed,
            startDate: start
        )
        let state = PetTimeAttributes.ContentState(
            endDate: end,
            isPaused: false,
            pausedRemaining: 0
        )

        // Reserve the slot before requesting the system activity, preventing double taps from
        // creating duplicate activities for the same pet.
        timers[petID] = PetTimer(petID: petID, activityID: nil, endDate: end, isPaused: false)

        Task {
            do {
                let content = ActivityContent(state: state, staleDate: end)
                let activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
                timers[petID] = PetTimer(petID: petID, activityID: activity.id, endDate: end, isPaused: false)
            } catch {
                timers[petID] = nil
                print("Failed to start live activity: \(error)")
            }
        }
    }

    func pause(petID: String) {
        guard let activity = activity(for: petID), !activity.content.state.isPaused else { return }

        Task {
            let remaining = max(activity.content.state.endDate.timeIntervalSinceNow, 0)
            let pausedState = PetTimeAttributes.ContentState(
                endDate: Date(),
                isPaused: true,
                pausedRemaining: remaining
            )
            await activity.update(ActivityContent(state: pausedState, staleDate: nil))
            timers[petID] = PetTimer(petID: petID, activityID: activity.id, endDate: pausedState.endDate, isPaused: true)
        }
    }

    func resume(petID: String) {
        guard let activity = activity(for: petID), activity.content.state.isPaused else { return }

        Task {
            let end = Date().addingTimeInterval(activity.content.state.pausedRemaining)
            let resumedState = PetTimeAttributes.ContentState(
                endDate: end,
                isPaused: false,
                pausedRemaining: 0
            )
            await activity.update(ActivityContent(state: resumedState, staleDate: end))
            timers[petID] = PetTimer(petID: petID, activityID: activity.id, endDate: end, isPaused: false)
        }
    }

    func stop(petID: String) {
        guard let activity = activity(for: petID) else { return }

        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            timers[petID] = nil
        }
    }

    func refresh() {
        let now = Date()
        let activities = Activity<PetTimeAttributes>.activities.filter {
            $0.activityState == .active && ($0.content.state.isPaused || $0.content.state.endDate > now)
        }
        timers = Dictionary(
            uniqueKeysWithValues: activities.map { activity in
                let state = activity.content.state
                return (
                    activity.attributes.petID,
                    PetTimer(
                        petID: activity.attributes.petID,
                        activityID: activity.id,
                        endDate: state.endDate,
                        isPaused: state.isPaused
                    )
                )
            }
        )
    }

    private func activity(for petID: String) -> Activity<PetTimeAttributes>? {
        Activity<PetTimeAttributes>.activities.first {
            $0.attributes.petID == petID &&
            $0.activityState == .active &&
            ($0.content.state.isPaused || $0.content.state.endDate > Date())
        }
    }
}

struct PetTimer: Identifiable, Equatable {
    let petID: String
    let activityID: String?
    let endDate: Date
    let isPaused: Bool

    var id: String { petID }
}
