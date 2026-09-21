//
//  AppIntent.swift
//  DrPawWidget
//

import AppIntents
import ActivityKit
import WidgetKit

struct PetEntity: AppEntity, Hashable {
    let id: String
    let name: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Pet"
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static var defaultQuery = PetQuery()
}

struct PetQuery: EntityQuery {
    func entities(for identifiers: [PetEntity.ID]) async throws -> [PetEntity] {
        WidgetSharedStore.loadPets()
            .filter { identifiers.contains($0.id) }
            .map { PetEntity(id: $0.id, name: $0.name) }
    }

    func suggestedEntities() async throws -> [PetEntity] {
        let pets = WidgetSharedStore.loadPets()
        if pets.isEmpty {
            return [PetEntity(id: "placeholder", name: "Add a pet in Dr. Paws")]
        }
        return pets.map { PetEntity(id: $0.id, name: $0.name) }
    }

    func defaultResult() async -> PetEntity? {
        try? await suggestedEntities().first
    }
}

struct FoodWalkConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Food & Walk" }
    static var description: IntentDescription {
        "Twice-daily food and walk reminder for a pet."
    }

    @Parameter(title: "Pet")
    var pet: PetEntity?
}

struct MedicalVisitConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Medical Visit" }
    static var description: IntentDescription {
        "Days remaining until the next checkup or vaccination."
    }

    @Parameter(title: "Pet")
    var pet: PetEntity?
}

struct CompleteFoodIntent: AppIntent {
    static var title: LocalizedStringResource = "Mark food complete"
    static var openAppWhenRun = false

    @Parameter(title: "Pet ID") var petID: String

    init() {}

    init(petID: String) {
        self.petID = petID
    }

    func perform() async throws -> some IntentResult {
        WidgetSharedStore.completeFoodWalkTask(.food, petID: petID)
        return .result()
    }
}

struct CompleteWalkIntent: AppIntent {
    static var title: LocalizedStringResource = "Mark walk complete"
    static var openAppWhenRun = false

    @Parameter(title: "Pet ID") var petID: String

    init() {}

    init(petID: String) {
        self.petID = petID
    }

    func perform() async throws -> some IntentResult {
        WidgetSharedStore.completeFoodWalkTask(.walk, petID: petID)
        return .result()
    }
}

struct PausePetTimeIntent: AppIntent {
    static var title: LocalizedStringResource = "Pause pet time"
    static var openAppWhenRun = false

    @Parameter(title: "Activity ID") var activityID: String

    init() {}

    init(activityID: String) {
        self.activityID = activityID
    }

    func perform() async throws -> some IntentResult {
        guard let activity = Activity<PetTimeAttributes>.activities.first(where: { $0.id == activityID }),
              !activity.content.state.isPaused else {
            return .result()
        }

        let remaining = max(activity.content.state.endDate.timeIntervalSinceNow, 0)
        let state = PetTimeAttributes.ContentState(
            endDate: Date(),
            isPaused: true,
            pausedRemaining: remaining
        )
        await activity.update(ActivityContent(state: state, staleDate: nil))
        return .result()
    }
}

struct ResumePetTimeIntent: AppIntent {
    static var title: LocalizedStringResource = "Resume pet time"
    static var openAppWhenRun = false

    @Parameter(title: "Activity ID") var activityID: String

    init() {}

    init(activityID: String) {
        self.activityID = activityID
    }

    func perform() async throws -> some IntentResult {
        guard let activity = Activity<PetTimeAttributes>.activities.first(where: { $0.id == activityID }),
              activity.content.state.isPaused else {
            return .result()
        }

        let end = Date().addingTimeInterval(activity.content.state.pausedRemaining)
        let state = PetTimeAttributes.ContentState(endDate: end, isPaused: false, pausedRemaining: 0)
        await activity.update(ActivityContent(state: state, staleDate: end))
        return .result()
    }
}

struct StopPetTimeIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop pet time"
    static var openAppWhenRun = false

    @Parameter(title: "Activity ID") var activityID: String

    init() {}

    init(activityID: String) {
        self.activityID = activityID
    }

    func perform() async throws -> some IntentResult {
        guard let activity = Activity<PetTimeAttributes>.activities.first(where: { $0.id == activityID }) else {
            return .result()
        }
        await activity.end(nil, dismissalPolicy: .immediate)
        return .result()
    }
}
