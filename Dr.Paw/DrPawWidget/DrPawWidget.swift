//
//  DrPawWidget.swift
//  DrPawWidget
//

import SwiftUI
import UIKit
import WidgetKit
import AppIntents

// MARK: - Shared chrome

struct PetWidgetChrome<Content: View>: View {
    @Environment(\.widgetFamily) private var family

    let pet: SharedPetSnapshot
    @ViewBuilder let content: () -> Content

    private var showsPhoto: Bool {
        family == .systemLarge
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if showsPhoto {
                petPhoto
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(pet.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(hex: "#3A264B"))
                    .lineLimit(1)

                if let breed = pet.breed, !breed.isEmpty {
                    Text(breed)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(family == .systemSmall ? 12 : 16)
    }

    @ViewBuilder
    private var petPhoto: some View {
        if let data = pet.photoData, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(hex: "#6D4093").opacity(0.15))
                    .frame(width: 72, height: 72)
                Image(systemName: "pawprint.fill")
                    .font(.title)
                    .foregroundStyle(Color(hex: "#6D4093"))
            }
        }
    }
}

// MARK: - Food & Walk

struct FoodWalkEntry: TimelineEntry {
    let date: Date
    let pet: SharedPetSnapshot
    let slot: FoodWalkSlot
    let progress: FoodWalkProgress
}

struct FoodWalkProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> FoodWalkEntry {
        FoodWalkEntry(date: Date(), pet: placeholderPet, slot: .current(), progress: FoodWalkProgress())
    }

    func snapshot(for configuration: FoodWalkConfigurationIntent, in context: Context) async -> FoodWalkEntry {
        entry(for: configuration, at: Date())
    }

    func timeline(for configuration: FoodWalkConfigurationIntent, in context: Context) async -> Timeline<FoodWalkEntry> {
        let now = Date()
        let current = entry(for: configuration, at: now)
        return Timeline(entries: [current], policy: .after(WidgetTimelineSupport.nextNoonOrMidnight(after: now)))
    }

    private func entry(for configuration: FoodWalkConfigurationIntent, at date: Date) -> FoodWalkEntry {
        let pet = WidgetSharedStore.pet(id: configuration.pet?.id) ?? placeholderPet
        let slot = FoodWalkSlot.current(at: date)
        return FoodWalkEntry(
            date: date,
            pet: pet,
            slot: slot,
            progress: WidgetSharedStore.foodWalkProgress(petID: pet.id, slot: slot, at: date)
        )
    }
}

struct FoodWalkWidgetView: View {
    @Environment(\.widgetFamily) private var family

    var entry: FoodWalkEntry

    var body: some View {
        Group {
            if family == .systemSmall {
                reminderDetails(alignment: .center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                HStack(spacing: 24) {
                    petPhoto
                    reminderDetails(alignment: .leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(family == .systemSmall ? 14 : 18)
        .containerBackground(Color(hex: "#F9E7C8"), for: .widget)
        .widgetURL(AppDeepLink.foodWalk.url)
    }

    private func reminderDetails(alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 9) {
            Text(entry.pet.name)
                .font(.headline.weight(.bold))
                .foregroundStyle(Color(hex: "#3A264B"))
                .lineLimit(1)

            VStack(alignment: alignment, spacing: 8) {
                if !entry.progress.foodCompleted {
                    Button(intent: CompleteFoodIntent(petID: entry.pet.id)) {
                        taskControl(title: "Food", icon: "fork.knife", tint: Color(hex: "#D97706"))
                    }
                    .buttonStyle(.plain)
                }

                if !entry.progress.walkCompleted {
                    Button(intent: CompleteWalkIntent(petID: entry.pet.id)) {
                        taskControl(title: "Walk", icon: "figure.walk", tint: Color(hex: "#6D4093"))
                    }
                    .buttonStyle(.plain)
                }

                if entry.progress.foodCompleted && entry.progress.walkCompleted {
                    Label("All set", systemImage: "checkmark.circle.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color(hex: "#4F7B45"))
                }
            }
        }
    }

    private var petPhoto: some View {
        Group {
            if let data = entry.pet.photoData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "pawprint.fill")
                    .font(.title)
                    .foregroundStyle(Color(hex: "#6D4093"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: "#E9DEF0"))
            }
        }
        .frame(width: 104, height: 104)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color(hex: "#6D4093").opacity(0.45), lineWidth: 1.5)
        }
    }

    private func taskControl(title: String, icon: String, tint: Color) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(tint.opacity(0.14))
                .overlay {
                    Image(systemName: icon)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(tint)
                }
                .overlay {
                    Circle().stroke(tint.opacity(0.58), lineWidth: 1.5)
                }
                .frame(width: 31, height: 31)

            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color(hex: "#3A264B"))
        }
        .contentShape(Rectangle())
    }
}

struct FoodWalkWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: WidgetKind.foodWalk,
            intent: FoodWalkConfigurationIntent.self,
            provider: FoodWalkProvider()
        ) { entry in
            FoodWalkWidgetView(entry: entry)
        }
        .configurationDisplayName("Food & Walk")
        .description("Reminds you twice a day — before noon and after noon — to feed and walk your pet.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Medical visit

struct MedicalVisitEntry: TimelineEntry {
    let date: Date
    let pet: SharedPetSnapshot
    let daysLeft: Int?
}

struct MedicalVisitProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MedicalVisitEntry {
        MedicalVisitEntry(date: Date(), pet: placeholderPet, daysLeft: 12)
    }

    func snapshot(for configuration: MedicalVisitConfigurationIntent, in context: Context) async -> MedicalVisitEntry {
        entry(for: configuration, at: Date())
    }

    func timeline(for configuration: MedicalVisitConfigurationIntent, in context: Context) async -> Timeline<MedicalVisitEntry> {
        let now = Date()
        return Timeline(
            entries: [entry(for: configuration, at: now)],
            policy: .after(WidgetTimelineSupport.nextMidnight(after: now))
        )
    }

    private func entry(for configuration: MedicalVisitConfigurationIntent, at date: Date) -> MedicalVisitEntry {
        let pet = WidgetSharedStore.pet(id: configuration.pet?.id) ?? placeholderPet
        let days = pet.nextVisitDate.map { WidgetTimelineSupport.daysUntil($0, from: date) }
        return MedicalVisitEntry(date: date, pet: pet, daysLeft: days)
    }
}

struct MedicalVisitWidgetView: View {
    var entry: MedicalVisitEntry

    var body: some View {
        PetWidgetChrome(pet: entry.pet) {
            Text("Next visit")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color(hex: "#6D4093"))

            Text(daysCopy)
                .font(.title3.weight(.bold))
                .foregroundStyle(Color(hex: "#3A264B"))
                .lineLimit(2)
        }
        .containerBackground(Color(hex: "#ECE9E7"), for: .widget)
        .widgetURL(AppDeepLink.medical.url)
    }

    private var daysCopy: String {
        guard let days = entry.daysLeft else {
            return "Set next visit"
        }
        if days < 0 {
            return "Visit was \(-days)d ago"
        }
        if days == 0 {
            return "Visit today"
        }
        if days == 1 {
            return "1 day left"
        }
        return "\(days) days left"
    }
}

struct MedicalVisitWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: WidgetKind.medicalVisit,
            intent: MedicalVisitConfigurationIntent.self,
            provider: MedicalVisitProvider()
        ) { entry in
            MedicalVisitWidgetView(entry: entry)
        }
        .configurationDisplayName("Medical Visit")
        .description("Shows how many days are left until the next checkup or vaccination.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

private var placeholderPet: SharedPetSnapshot {
    SharedPetSnapshot(id: "placeholder", name: "Your pet", breed: "Add a pet", species: nil, photoData: nil, nextVisitDate: nil)
}

#Preview(as: .systemLarge) {
    FoodWalkWidget()
} timeline: {
    FoodWalkEntry(date: .now, pet: placeholderPet, slot: .morning, progress: FoodWalkProgress())
}
