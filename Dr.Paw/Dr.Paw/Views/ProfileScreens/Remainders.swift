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
    @AppStorage("notificationsMasterEnabled") private var notificationsEnabled = true
    @State private var showPermissionAlert = false

    var body: some View {
        NavigationStack {

            ZStack {

                // Background gradient so the glass has something to refract against
                LinearGradient(
                    colors: [Color(hex: "#F9E7C8"), Color(hex: "#ECE9E7")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {

                    VStack(spacing: 24) {

                        // Nav bar
                        HStack {

                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.black)
                                    .frame(width: 44, height: 44)
                                    .liquidGlass(in: Circle())
                            }

                            Spacer()

                            Text("Reminders")
                                .font(.system(size: 22, weight: .bold))

                            Spacer()

                            // Spacer button to balance the back arrow, keeps title centered
                            Color.clear.frame(width: 44, height: 44)

                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Bell icon card
                        VStack(spacing: 14) {

                            ZStack {
                                Image(systemName: notificationsEnabled ? "bell.fill" : "bell.slash.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 42, height: 42)
                                    .foregroundStyle(Color(hex: "#6D4093"))
                                    .frame(width: 96, height: 96)
                                    .liquidGlass(in: RoundedRectangle(cornerRadius: 28, style: .continuous), tint: Color(hex: "#6D4093").opacity(0.18))
                            }

                            VStack(spacing: 4) {

                                Text(notificationsEnabled ? "Reminders are on" : "Reminders are off")
                                    .font(.system(size: 20, weight: .bold))

                                Text("Get notified about growth check-ins, feeding schedules, and vet visits.")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)

                            }

                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .liquidGlass(in: RoundedRectangle(cornerRadius: 32, style: .continuous))

                        // Toggle section
                        ReminderSection(title: "Notifications") {

                            HStack {

                                Text("Allow Reminders")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.black.opacity(0.8))

                                Spacer()

                                Toggle("", isOn: $notificationsEnabled)
                                    .labelsHidden()
                                    .tint(Color(hex: "#F79E1B"))
                                    .onChange(of: notificationsEnabled) { _, newValue in
                                        if newValue {
                                            requestPermissionAndEnable()
                                        } else {
                                            disableNotifications()
                                        }
                                    }
                            }

                        }

                       

                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)

                }

            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                checkCurrentPermissionStatus()
            }
            .alert("Notifications Disabled", isPresented: $showPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {
                    notificationsEnabled = false
                }
            } message: {
                Text("Please enable notifications for Dr. Paws in Settings to receive reminders.")
            }

        }
    }

    // MARK: - Notification handling

    private func requestPermissionAndEnable() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
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
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        notificationsEnabled = false
    }

    private func checkCurrentPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus != .authorized {
                    notificationsEnabled = false
                }
            }
        }
    }

    // TODO: replace with real scheduling logic (growth check-ins, feeding times, vet visits)
    // once the data layer / growth tracker feature exists — this is just a placeholder
    // so Start actually produces a visible notification during testing.
    private func scheduleSampleReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Dr. Paws"
        content.body = "Time for a growth check-in!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "drpaws.sample.reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - Reusable glass section wrapper

struct ReminderSection<Content: View>: View {

    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
                .textCase(.uppercase)
                .tracking(0.5)

            content()

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .liquidGlass(in: RoundedRectangle(cornerRadius: 20, style: .continuous))

    }
}

#Preview {
    Remainders()
}
