//
//  SettingsView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 16/09/26.
//

import AVFoundation
import CoreLocation
import CoreData
import Combine
import SwiftUI
import UserNotifications

struct SettingsView: View {

    @EnvironmentObject var session: UserSession
    @EnvironmentObject var petStore: PetStore
    @EnvironmentObject var weightHeightStore: WeightHeightStore

    @AppStorage("defaultWeightUnit") private var defaultWeightUnitRaw: String = WeightUnit.kg.rawValue
    @AppStorage("defaultHeightUnit") private var defaultHeightUnitRaw: String = HeightUnit.cm.rawValue

    @AppStorage("notificationsMasterEnabled") private var notificationsMasterEnabled = true
    @AppStorage("medicalReminderEnabled") private var medicalReminderEnabled = true
    @AppStorage("foodWalkReminderEnabled") private var foodWalkReminderEnabled = true

    @State private var showSignOutConfirm = false
    @State private var showDeleteAllDataConfirm = false
    @State private var showDeleteAccountConfirm = false
    @State private var showClearScanHistoryConfirm = false
    @State private var showResetAlert = false
    @State private var resetAlertMessage = ""
    @State private var showExportSheet = false
    @State private var exportText = ""
    @State private var cameraStatus = "—"
    @State private var locationStatus = "—"
    @State private var notificationStatus = "—"

    private let screenBackground = Color(hex: "#ECE9E7")
    private let cardBackground = Color.white
    private let titleColor = Color(hex: "#3A264B")
    private let subtitleColor = Color.gray
    private let accentColor = Color(hex: "#6D4093")
    private let highlightColor = Color(hex: "#F79E1B")

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    accountSection
                    notificationsSection
                    unitsSection
                    dataManagementSection
                    permissionsSection
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 28)
            }
            .background(screenBackground.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                refreshPermissionStatuses()
            }
            .confirmationDialog("Sign out of Dr. Paws?", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
                Button("Sign Out", role: .destructive) { session.signOut() }
                Button("Cancel", role: .cancel) {}
            }
            .confirmationDialog("Delete all data?", isPresented: $showDeleteAllDataConfirm, titleVisibility: .visible) {
                Button("Delete Everything", role: .destructive) { petStore.deleteAllData() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This permanently removes all pets and their weight/height history. This cannot be undone.")
            }
            .confirmationDialog("Delete your account?", isPresented: $showDeleteAccountConfirm, titleVisibility: .visible) {
                Button("Delete Account", role: .destructive) {
                    petStore.deleteAllData()
                    session.deleteAccount()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This signs you out, clears saved login tokens, and deletes local pet data on this device.")
            }
            .confirmationDialog("Clear scan history?", isPresented: $showClearScanHistoryConfirm, titleVisibility: .visible) {
                Button("Clear", role: .destructive) {
                    UserDefaults.standard.removeObject(forKey: "scanHistory")
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Saved animal scans on this device will be removed.")
            }
            .alert("Password reset", isPresented: $showResetAlert) {
                Button("Okay", role: .cancel) {}
            } message: {
                Text(resetAlertMessage)
            }
            .sheet(isPresented: $showExportSheet) {
                SettingsShareSheet(items: [exportText])
            }
        }
    }

    private var header: some View {
        Text("Settings")
            .font(.system(size: 34, weight: .bold))
            .foregroundStyle(titleColor)
            .padding(.top, 8)
    }

    // MARK: - Account

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("ACCOUNT", systemImage: "person.crop.circle.fill")

            VStack(spacing: 0) {
                Button {
                    sendPasswordReset()
                } label: {
                    settingsRowLabel(icon: "key.fill", title: "Reset Password", showDivider: true)
                }
                .buttonStyle(.plain)

                Button {
                    showSignOutConfirm = true
                } label: {
                    settingsRowLabel(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", showDivider: true, tintOverride: .red)
                }
                .buttonStyle(.plain)

                Button {
                    showDeleteAccountConfirm = true
                } label: {
                    settingsRowLabel(icon: "person.crop.circle.badge.minus", title: "Delete Account", showDivider: false, tintOverride: .red)
                }
                .buttonStyle(.plain)
            }
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    // MARK: - Notifications

    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("NOTIFICATIONS", systemImage: "bell.fill")

            VStack(spacing: 0) {
                toggleRow(title: "Allow Notifications", isOn: $notificationsMasterEnabled, showDivider: true)
                    .onChange(of: notificationsMasterEnabled) { _, enabled in
                        if enabled {
                            requestNotificationPermission()
                        } else {
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                    }

                toggleRow(title: "Medical Visit Reminders", isOn: $medicalReminderEnabled, showDivider: true)
                    .disabled(!notificationsMasterEnabled)
                    .opacity(notificationsMasterEnabled ? 1 : 0.4)

                toggleRow(title: "Food & Walk Reminders", isOn: $foodWalkReminderEnabled, showDivider: false)
                    .disabled(!notificationsMasterEnabled)
                    .opacity(notificationsMasterEnabled ? 1 : 0.4)
            }
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    // MARK: - Units

    private var unitsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("UNITS & DEFAULTS", systemImage: "ruler.fill")

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Default Weight Unit")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(titleColor)

                    Picker("Weight Unit", selection: $defaultWeightUnitRaw) {
                        ForEach(WeightUnit.allCases) { unit in
                            Text(unit.rawValue.uppercased()).tag(unit.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Default Height Unit")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(titleColor)

                    Picker("Height Unit", selection: $defaultHeightUnitRaw) {
                        ForEach(HeightUnit.allCases) { unit in
                            Text(unit.rawValue).tag(unit.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding(16)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    // MARK: - Data

    private var dataManagementSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("DATA MANAGEMENT", systemImage: "externaldrive.fill")

            VStack(spacing: 0) {
                settingsRow(icon: "internaldrive.fill", title: "Manage Storage", showDivider: true) {
                    Storage()
                }

                Button {
                    showClearScanHistoryConfirm = true
                } label: {
                    settingsRowLabel(icon: "camera.viewfinder", title: "Clear Scan History", showDivider: true)
                }
                .buttonStyle(.plain)

                Button {
                    exportText = weightHeightStore.exportGrowthCSV(pets: petStore.pets)
                    showExportSheet = true
                } label: {
                    settingsRowLabel(icon: "square.and.arrow.up", title: "Export Growth Data", showDivider: true)
                }
                .buttonStyle(.plain)

                Button {
                    showDeleteAllDataConfirm = true
                } label: {
                    settingsRowLabel(icon: "trash.fill", title: "Delete All Data", showDivider: false, tintOverride: .red)
                }
                .buttonStyle(.plain)
            }
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    // MARK: - Permissions

    private var permissionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("PERMISSIONS", systemImage: "lock.shield.fill")

            VStack(spacing: 0) {
                permissionRow(title: "Camera", status: cameraStatus, showDivider: true)
                permissionRow(title: "Location", status: locationStatus, showDivider: true)
                permissionRow(title: "Notifications", status: notificationStatus, showDivider: false)
            }
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("ABOUT", systemImage: "info.circle.fill")

            VStack(spacing: 0) {
                settingsRow(icon: "info.circle.fill", title: "About Dr. Paws", showDivider: false) {
                    About()
                }
            }
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    private func permissionRow(title: String, status: String, showDivider: Bool) -> some View {
        Button {
            openSystemSettings()
        } label: {
            VStack(spacing: 0) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(titleColor)

                    Spacer()

                    Text(status)
                        .font(.subheadline)
                        .foregroundStyle(subtitleColor)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(accentColor.opacity(0.7))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

                if showDivider {
                    Divider().padding(.leading, 16)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func sendPasswordReset() {
        let email = session.email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else {
            resetAlertMessage = "No email is saved on this account yet."
            showResetAlert = true
            return
        }

        Task {
            do {
                try await session.resetPassword(email: email)
                resetAlertMessage = "If an account exists for \(email), a reset link is on its way."
            } catch {
                resetAlertMessage = error.localizedDescription
            }
            showResetAlert = true
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                notificationsMasterEnabled = granted
                if !granted {
                    openSystemSettings()
                }
                refreshPermissionStatuses()
            }
        }
    }

    private func refreshPermissionStatuses() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: cameraStatus = "Allowed"
        case .denied, .restricted: cameraStatus = "Off"
        case .notDetermined: cameraStatus = "Ask"
        @unknown default: cameraStatus = "—"
        }

        switch CLLocationManager().authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: locationStatus = "Allowed"
        case .denied, .restricted: locationStatus = "Off"
        case .notDetermined: locationStatus = "Ask"
        @unknown default: locationStatus = "—"
        }

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral: notificationStatus = "Allowed"
                case .denied: notificationStatus = "Off"
                case .notDetermined: notificationStatus = "Ask"
                @unknown default: notificationStatus = "—"
                }
            }
        }
    }

    private func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func sectionLabel(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.system(size: 12, weight: .semibold))
            .tracking(0.6)
            .foregroundStyle(accentColor)
            .padding(.leading, 4)
    }

    private func settingsRow<Destination: View>(
        icon: String,
        title: String,
        showDivider: Bool,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {
        NavigationLink(destination: destination()) {
            settingsRowLabel(icon: icon, title: title, showDivider: showDivider)
        }
        .buttonStyle(.plain)
    }

    private func settingsRowLabel(
        icon: String,
        title: String,
        showDivider: Bool,
        tintOverride: Color? = nil
    ) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(tintOverride ?? accentColor)
                    .frame(width: 28)

                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(tintOverride ?? titleColor)

                Spacer()

                if tintOverride == nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(accentColor.opacity(0.7))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            if showDivider {
                Divider().padding(.leading, 58)
            }
        }
    }

    private func toggleRow(title: String, isOn: Binding<Bool>, showDivider: Bool) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(titleColor)

                Spacer()

                Toggle("", isOn: isOn)
                    .labelsHidden()
                    .tint(highlightColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            if showDivider {
                Divider().padding(.leading, 16)
            }
        }
    }
}

private struct SettingsShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
        .environmentObject(UserSession())
        .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
        .environmentObject(WeightHeightStore(context: PersistenceController.shared.container.viewContext))
}
