//
//  MedicalReminderView.swift
//  Dr.Paw
//

import SwiftUI
import CoreData

struct MedicalReminderView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore

    @State private var selectedPetID: String = ""
    @State private var nextVisit = Date()
    @State private var hasVisitDate = false

    @AppStorage("notificationsMasterEnabled")
    private var notificationsMasterEnabled = true

    @AppStorage("medicalReminderEnabled")
    private var medicalReminderEnabled = true

    private var selectedPet: Pet? {
        petStore.pets.first {
            $0.id?.uuidString == selectedPetID
        }
        ?? petStore.selectedPet
        ?? petStore.pets.first
    }

    var body: some View {
        NavigationStack {
            ZStack {
                screenBackground

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {

                        header

                        if petStore.pets.isEmpty {
                            emptyState
                        } else {
                            petSelectionCard
                            reminderCard
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 110)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                WidgetSharedStore.sync(from: petStore.pets)

                if selectedPetID.isEmpty {
                    selectedPetID =
                        petStore.selectedPet?.id?.uuidString
                        ?? petStore.pets.first?.id?.uuidString
                        ?? ""
                }

                loadVisitDate()
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
                Text("PET HEALTH")
                    .font(.caption.weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color.appAccent)

                Text("Medical Reminder")
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

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {

            Image(systemName: "cross.case.fill")
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
                Text("No pets yet")
                    .font(
                        .system(
                            size: 20,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                Text("Add a pet first to set a medical visit.")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 55)
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

    // MARK: - Pet Selection

    private var petSelectionCard: some View {
        VStack(alignment: .leading, spacing: 14) {

            sectionLabel(
                title: "SELECT PET",
                icon: "pawprint.fill"
            )

            Picker("Pet", selection: $selectedPetID) {
                ForEach(
                    petStore.pets,
                    id: \.objectID
                ) { pet in

                    Text(pet.name ?? "Unnamed")
                        .tag(pet.id?.uuidString ?? "")
                }
            }
            .pickerStyle(.navigationLink)
            .tint(Color.appTextPrimary)
            .onChange(of: selectedPetID) { _, _ in
                loadVisitDate()
            }
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

    // MARK: - Reminder Card

    private var reminderCard: some View {
        VStack(alignment: .leading, spacing: 20) {

            sectionLabel(
                title: "MEDICAL VISIT",
                icon: "cross.case.fill"
            )

            Toggle(isOn: $hasVisitDate) {

                VStack(alignment: .leading, spacing: 4) {
                    Text("Next visit scheduled")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color.appTextPrimary)

                    Text(
                        hasVisitDate
                        ? "Your next medical visit is scheduled."
                        : "Turn this on to set a visit date."
                    )
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                }
            }
            .tint(Color.appBrand)

            if hasVisitDate {

                VStack(alignment: .leading, spacing: 10) {

                    Text("VISIT DATE")
                        .font(.caption2.weight(.bold))
                        .tracking(1.1)
                        .foregroundStyle(Color.appTextSecondary)

                    DatePicker(
                        "",
                        selection: $nextVisit,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .tint(Color.appBrand)
                    .padding(8)
                    .background(Color.appBackground)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                    )
                }

                if let daysCopy = daysCopy {

                    HStack(spacing: 12) {

                        Image(systemName: "calendar.badge.clock")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.appAccent)
                            .frame(width: 42, height: 42)
                            .background(Color.appBlush)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 13,
                                    style: .continuous
                                )
                            )

                        VStack(alignment: .leading, spacing: 3) {

                            Text("UPCOMING VISIT")
                                .font(.caption2.weight(.bold))
                                .tracking(1.0)
                                .foregroundStyle(Color.appTextSecondary)

                            Text(daysCopy)
                                .font(
                                    .system(
                                        size: 17,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(Color.appTextPrimary)
                        }

                        Spacer()
                    }
                    .padding(14)
                    .background(Color.appBlush)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 18,
                            style: .continuous
                        )
                    )
                }
            }

            Button {
                saveVisit()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                    Text("Save Visit")
                }
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color.appOnBrand)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.appBrandGradient)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
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

    // MARK: - Days Copy

    private var daysCopy: String? {
        guard hasVisitDate else {
            return nil
        }

        let days = WidgetTimelineSupport.daysUntil(nextVisit)

        if days < 0 {
            return "Visit was \(-days) days ago"
        }

        if days == 0 {
            return "Visit is today"
        }

        if days == 1 {
            return "1 day left"
        }

        return "\(days) days left"
    }

    // MARK: - Load Visit

    private func loadVisitDate() {

        guard
            let id = selectedPet?.id?.uuidString,
            let stored = WidgetSharedStore.pet(id: id)?.nextVisitDate
        else {
            hasVisitDate = false
            nextVisit = Date()
            return
        }

        hasVisitDate = true
        nextVisit = stored
    }

    // MARK: - Save Visit

    private func saveVisit() {

        guard let id = selectedPet?.id?.uuidString else {
            return
        }

        WidgetSharedStore.sync(from: petStore.pets)

        WidgetSharedStore.setNextVisit(
            petID: id,
            date: hasVisitDate ? nextVisit : nil
        )

        scheduleOrCancelReminder(petID: id)
    }

    // MARK: - Notification

    private func scheduleOrCancelReminder(petID: String) {

        let identifier = "medical-\(petID)"

        // If notifications are off, or user cleared the visit date,
        // cancel any existing reminder.

        guard
            notificationsMasterEnabled,
            medicalReminderEnabled,
            hasVisitDate
        else {
            NotificationManager.shared.cancel(
                id: identifier
            )
            return
        }

        // Fire 1 day before the visit, at 9 AM.

        let dayBefore =
            Calendar.current.date(
                byAdding: .day,
                value: -1,
                to: Calendar.current.startOfDay(
                    for: nextVisit
                )
            ) ?? nextVisit

        let fireDate =
            Calendar.current.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: dayBefore
            ) ?? dayBefore

        let petName =
            selectedPet?.name ?? "Your pet"

        NotificationManager.shared.scheduleOneShot(
            id: identifier,
            title: "Dr.Paw 🐾",
            body: "\(petName)'s vet visit is tomorrow!",
            fireDate: fireDate
        )
    }
}

#Preview {
    MedicalReminderView()
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
