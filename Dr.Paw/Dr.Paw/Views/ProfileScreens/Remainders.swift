//
//  Remainders.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//

import SwiftUI
import UserNotifications

struct Remainders: View {

    @Environment(\.dismiss) var dismiss

    @AppStorage("notificationsMasterEnabled")
    private var notificationsEnabled = true

    @State private var showPermissionAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                screenBackground

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {

                        header

                        notificationHero

                        notificationSettings

                        infoCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 110)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                checkCurrentPermissionStatus()
            }
            .alert(
                "Notifications Disabled",
                isPresented: $showPermissionAlert
            ) {
                Button("Open Settings") {
                    if let url = URL(
                        string: UIApplication.openSettingsURLString
                    ) {
                        UIApplication.shared.open(url)
                    }
                }

                Button("Cancel", role: .cancel) {
                    notificationsEnabled = false
                }
            } message: {
                Text(
                    "Please enable notifications for Dr. Paws in Settings to receive reminders."
                )
            }
        }
    }

    // MARK: - Background

    private var screenBackground: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.appAccent.opacity(0.14))
                .frame(width: 280, height: 280)
                .blur(radius: 45)
                .offset(x: 170, y: -350)

            Circle()
                .fill(Color.appBrand.opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 45)
                .offset(x: -170, y: 400)
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
                            .stroke(
                                Color.appBorder,
                                lineWidth: 1
                            )
                    }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 3) {

                Text("STAY ON TRACK")
                    .font(.caption.weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color.appAccent)

                Text("Reminders")
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

            Image(
                systemName:
                    notificationsEnabled
                    ? "bell.fill"
                    : "bell.slash.fill"
            )
            .font(.title3.weight(.bold))
            .foregroundStyle(Color.appAccent)
            .frame(width: 44, height: 44)
            .background(Color.appBlush)
            .clipShape(Circle())
        }
    }

    // MARK: - Notification Hero

    private var notificationHero: some View {
        VStack(spacing: 18) {

            ZStack {
                Circle()
                    .fill(Color.appBlush)
                    .frame(width: 104, height: 104)

                Circle()
                    .stroke(
                        Color.appAccent.opacity(0.25),
                        lineWidth: 1
                    )
                    .frame(width: 104, height: 104)

                Image(
                    systemName:
                        notificationsEnabled
                        ? "bell.fill"
                        : "bell.slash.fill"
                )
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(Color.appAccent)
            }

            VStack(spacing: 7) {

                Text(
                    notificationsEnabled
                    ? "Reminders are on"
                    : "Reminders are off"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(Color.appTextPrimary)

                Text(
                    "Get notified about growth check-ins, feeding schedules, and vet visits."
                )
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
                .padding(.horizontal, 20)
            }

            HStack(spacing: 7) {

                Circle()
                    .fill(
                        notificationsEnabled
                        ? Color.appAccent
                        : Color.appTextSecondary
                    )
                    .frame(width: 8, height: 8)

                Text(
                    notificationsEnabled
                    ? "Notifications enabled"
                    : "Notifications disabled"
                )
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.appTextSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
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
                Color.appBorder.opacity(0.45),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 12,
            y: 6
        )
    }

    // MARK: - Notification Settings

    private var notificationSettings: some View {
        VStack(alignment: .leading, spacing: 13) {

            sectionTitle(
                title: "NOTIFICATION SETTINGS",
                icon: "bell.badge.fill"
            )

            HStack(spacing: 14) {

                Image(
                    systemName:
                        notificationsEnabled
                        ? "bell.fill"
                        : "bell.slash.fill"
                )
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 44, height: 44)
                .background(Color.appBlush)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14,
                        style: .continuous
                    )
                )

                VStack(alignment: .leading, spacing: 4) {

                    Text("Allow Reminders")
                        .font(
                            .system(
                                size: 16,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(Color.appTextPrimary)

                    Text(
                        notificationsEnabled
                        ? "Dr.Paw can send you reminders"
                        : "Reminders are currently disabled"
                    )
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                }

                Spacer()

                Toggle(
                    "",
                    isOn: $notificationsEnabled
                )
                .labelsHidden()
                .tint(Color.appAccent)
                .onChange(
                    of: notificationsEnabled
                ) { _, newValue in

                    if newValue {
                        requestPermissionAndEnable()
                    } else {
                        disableNotifications()
                    }
                }
            }
            .padding(16)
            .background(Color.appSurface)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 22,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 22,
                    style: .continuous
                )
                .stroke(
                    Color.appBorder.opacity(0.35),
                    lineWidth: 1
                )
            }
        }
    }

    // MARK: - Information Card

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 15) {

            sectionTitle(
                title: "WHAT YOU'LL RECEIVE",
                icon: "checklist"
            )

            reminderRow(
                icon: "chart.line.uptrend.xyaxis",
                title: "Growth check-ins",
                detail: "Stay consistent with your pet's growth tracking."
            )

            reminderRow(
                icon: "fork.knife",
                title: "Feeding schedules",
                detail: "Get reminders when it's time for food."
            )

            reminderRow(
                icon: "cross.case.fill",
                title: "Vet visits",
                detail: "Never miss an upcoming medical appointment."
            )
        }
        .padding(17)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.35),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 9,
            y: 4
        )
    }

    // MARK: - Section Title

    private func sectionTitle(
        title: String,
        icon: String
    ) -> some View {

        HStack(spacing: 8) {

            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.appAccent)

            Text(title)
                .font(.caption.weight(.bold))
                .tracking(1.2)
                .foregroundStyle(Color.appTextPrimary)
        }
    }

    // MARK: - Reminder Row

    private func reminderRow(
        icon: String,
        title: String,
        detail: String
    ) -> some View {

        HStack(alignment: .top, spacing: 13) {

            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color.appOnBrand)
                .frame(width: 42, height: 42)
                .background(Color.appBrand)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 13,
                        style: .continuous
                    )
                )

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(
                        .system(
                            size: 15,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                Text(detail)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }

            Spacer()
        }
        .padding(.vertical, 3)
    }

    // MARK: - Notification Handling

    private func requestPermissionAndEnable() {

        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [
                    .alert,
                    .sound,
                    .badge
                ]
            ) { granted, _ in

                DispatchQueue.main.async {

                    if granted {
                        notificationsEnabled = true
                        scheduleSampleReminder()
                    } else {
                        showPermissionAlert = true
                    }
                }
            }
    }

    private func disableNotifications() {

        UNUserNotificationCenter
            .current()
            .removeAllPendingNotificationRequests()

        notificationsEnabled = false
    }

    private func checkCurrentPermissionStatus() {

        UNUserNotificationCenter
            .current()
            .getNotificationSettings { settings in

                DispatchQueue.main.async {

                    if settings.authorizationStatus != .authorized {
                        notificationsEnabled = false
                    }
                }
            }
    }

    // MARK: - Sample Reminder

    private func scheduleSampleReminder() {

        let content = UNMutableNotificationContent()

        content.title = "Dr. Paws"
        content.body = "Time for a growth check-in!"
        content.sound = .default

        let trigger =
            UNTimeIntervalNotificationTrigger(
                timeInterval: 5,
                repeats: false
            )

        let request =
            UNNotificationRequest(
                identifier: "drpaws.sample.reminder",
                content: content,
                trigger: trigger
            )

        UNUserNotificationCenter
            .current()
            .add(request)
    }
}

// MARK: - Reusable Reminder Section

struct ReminderSection<Content: View>: View {

    let title: String

    @ViewBuilder
    let content: () -> Content

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text(title)
                .font(.caption.weight(.bold))
                .tracking(1.2)
                .foregroundStyle(Color.appAccent)

            content()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(16)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.35),
                lineWidth: 1
            )
        }
    }
}

#Preview {
    Remainders()
}
