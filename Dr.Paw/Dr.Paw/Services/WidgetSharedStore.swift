//
//  WidgetSharedStore.swift
//  Dr.Paw
//
//  Shared pet snapshots for widgets (App Group UserDefaults).
//

import ActivityKit
import Foundation
import UIKit
import WidgetKit

struct SharedPetSnapshot: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var breed: String?
    var species: String?
    var photoData: Data?
    var nextVisitDate: Date?
}

enum WidgetKind {
    static let foodWalk = "FoodWalkWidget"
    static let medicalVisit = "MedicalVisitWidget"
}

enum AppDeepLink: String, Identifiable {
    case foodWalk
    case medical

    var id: String { rawValue }

    var url: URL {
        URL(string: "drpaw://\(rawValue)")!
    }

    static func from(_ url: URL) -> AppDeepLink? {
        switch url.host {
        case "foodWalk": return .foodWalk
        case "medical": return .medical
        default: return nil
        }
    }
}

enum WidgetSharedStore {
    static let appGroupID = "group.com.Adityasinh.Dr-Paw"
    private static let petsKey = "sharedPetSnapshots"
    private static let foodWalkProgressKey = "foodWalkProgress"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupID) ?? .standard
    }

    static func loadPets() -> [SharedPetSnapshot] {
        guard let data = defaults.data(forKey: petsKey) else { return [] }
        return (try? JSONDecoder().decode([SharedPetSnapshot].self, from: data)) ?? []
    }

    static func pet(id: String?) -> SharedPetSnapshot? {
        let pets = loadPets()
        if let id, let match = pets.first(where: { $0.id == id }) {
            return match
        }
        return pets.first
    }

    static func sync(from pets: [Pet]) {
        let previousDates = Dictionary(
            uniqueKeysWithValues: loadPets().compactMap { snapshot in
                snapshot.nextVisitDate.map { (snapshot.id, $0) }
            }
        )

        let snapshots: [SharedPetSnapshot] = pets.compactMap { pet in
            guard let id = pet.id?.uuidString else { return nil }
            return SharedPetSnapshot(
                id: id,
                name: pet.name ?? "Unnamed",
                breed: pet.breed,
                species: pet.species,
                photoData: thumbnail(from: pet.photoData),
                nextVisitDate: previousDates[id]
            )
        }

        save(snapshots)
        reloadWidgets()
    }

    static func setNextVisit(petID: String, date: Date?) {
        var pets = loadPets()
        if let index = pets.firstIndex(where: { $0.id == petID }) {
            pets[index].nextVisitDate = date
            save(pets)
            reloadWidgets()
        }
    }

    /// Returns the two actions completed for a pet during the current 12-hour period.
    static func foodWalkProgress(
        petID: String,
        slot: FoodWalkSlot = .current(),
        at date: Date = .now
    ) -> FoodWalkProgress {
        let records = loadFoodWalkProgress()
        return records[foodWalkProgressID(petID: petID, slot: slot, date: date)] ?? FoodWalkProgress()
    }

    static func completeFoodWalkTask(
        _ task: FoodWalkTask,
        petID: String,
        slot: FoodWalkSlot = .current(),
        at date: Date = .now
    ) {
        var records = loadFoodWalkProgress()
        let recordID = foodWalkProgressID(petID: petID, slot: slot, date: date)
        var progress = records[recordID] ?? FoodWalkProgress()
        progress.markComplete(task)
        records[recordID] = progress

        // Keep a small, useful history while preventing this shared store from growing forever.
        let oldestDate = Calendar.current.date(byAdding: .day, value: -31, to: date) ?? date
        records = records.filter { $0.value.updatedAt >= oldestDate }
        saveFoodWalkProgress(records)
        reloadWidgets()
    }

    private static func save(_ snapshots: [SharedPetSnapshot]) {
        if let data = try? JSONEncoder().encode(snapshots) {
            defaults.set(data, forKey: petsKey)
        }
    }

    private static func loadFoodWalkProgress() -> [String: FoodWalkProgress] {
        guard let data = defaults.data(forKey: foodWalkProgressKey) else { return [:] }
        return (try? JSONDecoder().decode([String: FoodWalkProgress].self, from: data)) ?? [:]
    }

    private static func saveFoodWalkProgress(_ records: [String: FoodWalkProgress]) {
        guard let data = try? JSONEncoder().encode(records) else { return }
        defaults.set(data, forKey: foodWalkProgressKey)
    }

    private static func foodWalkProgressID(petID: String, slot: FoodWalkSlot, date: Date) -> String {
        let day = Calendar.current.startOfDay(for: date)
        return "\(petID)|\(slot.rawValue)|\(ISO8601DateFormatter().string(from: day))"
    }

    static func reloadWidgets() {
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.foodWalk)
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.medicalVisit)
    }

    private static func thumbnail(from data: Data?) -> Data? {
        guard let data, let image = UIImage(data: data) else { return nil }
        let maxSide: CGFloat = 160
        let scale = min(maxSide / max(image.size.width, 1), maxSide / max(image.size.height, 1), 1)
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: size)
        let rendered = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return rendered.jpegData(compressionQuality: 0.72)
    }
}

struct PetTimeAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var endDate: Date
        var isPaused: Bool
        var pausedRemaining: TimeInterval
    }

    var petID: String
    var petName: String
    var breed: String
    var startDate: Date
}

enum FoodWalkTask: String, Codable, CaseIterable {
    case food
    case walk

    var title: String {
        switch self {
        case .food: return "Food"
        case .walk: return "Walk"
        }
    }

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .walk: return "figure.walk"
        }
    }
}

struct FoodWalkProgress: Codable, Hashable {
    var foodCompleted = false
    var walkCompleted = false
    var updatedAt = Date()

    mutating func markComplete(_ task: FoodWalkTask) {
        switch task {
        case .food: foodCompleted = true
        case .walk: walkCompleted = true
        }
        updatedAt = .now
    }

    func isComplete(_ task: FoodWalkTask) -> Bool {
        switch task {
        case .food: return foodCompleted
        case .walk: return walkCompleted
        }
    }
}

enum FoodWalkSlot: String, Codable {
    case morning
    case evening

    static func current(at date: Date = Date()) -> FoodWalkSlot {
        Calendar.current.component(.hour, from: date) < 12 ? .morning : .evening
    }

    var title: String {
        switch self {
        case .morning: return "Morning food & walk"
        case .evening: return "Evening food & walk"
        }
    }

    var reminderTitle: String {
        switch self {
        case .morning: return "Morning Reminders"
        case .evening: return "Evening Reminders"
        }
    }

    var detail: String {
        switch self {
        case .morning: return "Before 12 PM"
        case .evening: return "After 12 PM"
        }
    }

    var icon: String {
        switch self {
        case .morning: return "sun.max.fill"
        case .evening: return "moon.stars.fill"
        }
    }
}

enum WidgetTimelineSupport {
    static func nextNoonOrMidnight(after date: Date) -> Date {
        let calendar = Calendar.current
        let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
        if date < noon {
            return noon
        }
        return calendar.nextDate(
            after: date,
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        ) ?? date.addingTimeInterval(60 * 60 * 12)
    }

    static func nextMidnight(after date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.nextDate(
            after: date,
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        ) ?? date.addingTimeInterval(60 * 60 * 24)
    }

    static func daysUntil(_ date: Date, from now: Date = Date()) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: now)
        let visit = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: start, to: visit).day ?? 0
    }
}
