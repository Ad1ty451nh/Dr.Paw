//
//  FoodWalkTrackerView.swift
//  Dr.Paw
//

import SwiftUI
import CoreData

struct FoodWalkTrackerView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore

    @State private var progress = FoodWalkProgress()

    @AppStorage("notificationsMasterEnabled")
    private var notificationsMasterEnabled = true

    @AppStorage("foodWalkReminderEnabled")
    private var foodWalkReminderEnabled = true

    private var slot: FoodWalkSlot {
        .current()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                screenBackground

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {

                        header

                        if let pet = petStore.selectedPet ?? petStore.pets.first {
                            petCard(pet: pet)

                            trackingCard(pet: pet)
                        } else {
                            emptyState
                        }

                        resetInfoCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 110)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                WidgetSharedStore.sync(from: petStore.pets)
                refreshProgress()

                if let petID = activePetID,
                   let pet = petStore.selectedPet ?? petStore.pets.first {

                    scheduleOrCancelFoodWalkReminders(
                        petID: petID,
                        petName: pet.name ?? "your pet"
                    )
                }
            }
        }
    }

    // MARK: - Background

    private var screenBackground: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.appBrand.opacity(0.10))
                .frame(width: 260, height: 260)
                .blur(radius: 45)
                .offset(x: 170, y: -330)

            Circle()
                .fill(Color.appAccent.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 45)
                .offset(x: -160, y: 420)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 14) {

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.appSurface)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.appBorder, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 3) {

                Text("DAILY CARE")
                    .font(.caption.weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color.appAccent)

                Text("Food & Walk")
                    .font(
                        .system(
                            size: 28,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()
        }
    }

    // MARK: - Pet Card

    private func petCard(pet: Pet) -> some View {
        HStack(spacing: 14) {

            Image(systemName: "pawprint.fill")
                .font(.title3.weight(.bold))
                .foregroundStyle(Color.appOnBrand)
                .frame(width: 52, height: 52)
                .background(Color.appBrand)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 17,
                        style: .continuous
                    )
                )

            VStack(alignment: .leading, spacing: 4) {

                Text("TRACKING FOR")
                    .font(.caption2.weight(.bold))
                    .tracking(1.1)
                    .foregroundStyle(Color.appTextSecondary)

                Text(pet.name ?? "Your pet")
                    .font(
                        .system(
                            size: 20,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {

                Text(slot.title.uppercased())
                    .font(.caption2.weight(.bold))
                    .tracking(0.8)
                    .foregroundStyle(Color.appAccent)

                Image(systemName: slot.icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.appAccent)
            }
        }
        .padding(17)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.35),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            y: 5
        )
    }

    // MARK: - Tracking Card

    private func trackingCard(pet: Pet) -> some View {
        VStack(alignment: .leading, spacing: 18) {

            sectionLabel(
                title: slot.title.uppercased(),
                icon: slot.icon
            )

            Text(slot.detail)
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)

            taskStatus(
                for: .food,
                petID: pet.id?.uuidString ?? ""
            )

            taskStatus(
                for: .walk,
                petID: pet.id?.uuidString ?? ""
            )
        }
        .padding(18)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.35),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            y: 5
        )
    }

    // MARK: - Task Status

    private func taskStatus(
        for task: FoodWalkTask,
        petID: String
    ) -> some View {

        let completed = progress.isComplete(task)

        return HStack(spacing: 13) {

            Image(
                systemName:
                    completed
                    ? "checkmark.circle.fill"
                    : task.icon
            )
            .font(.title2.weight(.bold))
            .foregroundStyle(
                completed
                ? Color.appAccent
                : Color.appBrand
            )
            .frame(width: 44, height: 44)
            .background(
                completed
                ? Color.appBlush
                : Color.appBackground
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
            )

            VStack(alignment: .leading, spacing: 4) {

                Text(task.title)
                    .font(
                        .system(
                            size: 16,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                Text(
                    completed
                    ? "Completed this \(slot.rawValue)"
                    : "Not completed yet"
                )
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)
            }

            Spacer()

            if !completed {

                Button {
                    WidgetSharedStore.completeFoodWalkTask(
                        task,
                        petID: petID,
                        slot: slot
                    )

                    refreshProgress()
                } label: {

                    HStack(spacing: 6) {
                        Image(systemName: "checkmark")
                        Text("Done")
                    }
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.appOnBrand)
                    .padding(.horizontal, 14)
                    .frame(height: 38)
                    .background(Color.appBrand)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)

            } else {

                Image(systemName: "checkmark")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.appAccent)
                    .frame(width: 34, height: 34)
                    .background(Color.appBlush)
                    .clipShape(Circle())
            }
        }
        .padding(13)
        .background(Color.appBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .stroke(
                completed
                ? Color.appAccent.opacity(0.28)
                : Color.appBorder.opacity(0.22),
                lineWidth: 1
            )
        }
    }

    // MARK: - Notifications

    private func scheduleOrCancelFoodWalkReminders(
        petID: String,
        petName: String
    ) {
        guard
            notificationsMasterEnabled,
            foodWalkReminderEnabled
        else {
            NotificationManager.shared.cancelFixedDailyRoutine(petID: petID)
            return
        }

        NotificationManager.shared.scheduleFixedDailyRoutine(petID: petID, petName: petName)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 15) {

            Image(systemName: "pawprint.fill")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 70, height: 70)
                .background(Color.appBlush)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 22,
                        style: .continuous
                    )
                )

            VStack(spacing: 6) {

                Text("No pet selected")
                    .font(
                        .system(
                            size: 20,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                Text("Add a pet to start tracking food and walks.")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .padding(.horizontal, 20)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.35),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            y: 5
        )
    }

    // MARK: - Reset Information

    private var resetInfoCard: some View {
        HStack(alignment: .top, spacing: 13) {

            Image(systemName: "arrow.clockwise")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 40, height: 40)
                .background(Color.appBlush)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 13,
                        style: .continuous
                    )
                )

            VStack(alignment: .leading, spacing: 5) {

                Text("TWICE DAILY")
                    .font(.caption.weight(.bold))
                    .tracking(1.1)
                    .foregroundStyle(Color.appAccent)

                Text(
                    "This resets at 12 PM and midnight, so Food and Walk can be tracked twice a day."
                )
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(15)
        .background(Color.appSurface.opacity(0.75))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 21,
                style: .continuous
            )
        )
    }

    // MARK: - Section Label

    private func sectionLabel(
        title: String,
        icon: String
    ) -> some View {

        HStack(spacing: 8) {

            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.appAccent)

            Text(title)
                .font(.caption.weight(.bold))
                .tracking(1.3)
                .foregroundStyle(Color.appTextPrimary)
        }
    }

    // MARK: - Active Pet

    private var activePetID: String? {
        (petStore.selectedPet ?? petStore.pets.first)?
            .id?
            .uuidString
    }

    // MARK: - Refresh Progress

    private func refreshProgress() {

        guard let petID = activePetID else {
            progress = FoodWalkProgress()
            return
        }

        progress = WidgetSharedStore.foodWalkProgress(
            petID: petID,
            slot: slot
        )
    }
}

#Preview {
    FoodWalkTrackerView()
        .environmentObject(
            PetStore(
                context:
                    PersistenceController
                        .shared
                        .container
                        .viewContext
            )
        )
}
