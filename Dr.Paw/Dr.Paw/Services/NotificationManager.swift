//
//  NotificationManager.swift
//  Dr.Paw
//
//  Created by Adityasinh on 24/08/26.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Permission
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            
            if let error = error {
                print("❌ Notification permission error:", error)
                return
            }
            
            print("🔔 Notification permission granted:", granted)
        }
    }
    
    // MARK: - Load Notification Templates
    
    func loadTemplates() -> [NotificationTemplate] {
        
        guard let url = Bundle.main.url(
            forResource: "NotificationTemplates",
            withExtension: "json"
        ) else {
            print("❌ NotificationTemplates.json not found")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let templates = try JSONDecoder().decode(
                [NotificationTemplate].self,
                from: data
            )
            
            print("✅ Loaded \(templates.count) notification types")
            
            return templates
            
        } catch {
            print("❌ Failed to load notification templates:", error)
            return []
        }
    }
    
    func scheduleNotification(
        type: String,
        petName: String,
        after seconds: TimeInterval
    ) {
        
        let templates = loadTemplates()
        
        // Find the requested notification type
        guard let template = templates.first(where: {
            $0.type == type
        }) else {
            print("❌ Notification type not found: \(type)")
            return
        }
        
        // Pick a random message
        guard let messageTemplate = template.messages.randomElement() else {
            print("❌ No messages available for type: \(type)")
            return
        }
        
        // Replace {name} with the actual pet's name
        let message = messageTemplate.replacingOccurrences(
            of: "{name}",
            with: petName
        )
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Dr.Paw 🐾"
        content.body = message
        content.sound = .default
        
        // Temporary trigger for testing
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: seconds,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "\(type)-\(petName)-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                print("❌ Failed to schedule notification:", error)
            } else {
                print("✅ Notification scheduled:")
                print("   Type: \(type)")
                print("   Pet: \(petName)")
                print("   Message: \(message)")
            }
        }
    }
    // MARK: - Safe scheduling (stable IDs, permission-checked, toggle-aware)

    /// Call this once at the top of any scheduling function so we never
    /// fire a request the user hasn't authorized.
    func getAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    /// One-shot notification tied to a specific future date (e.g. vet visit reminder).
    /// `id` MUST be stable per-pet (e.g. "medical-\(petID)") so calling this again
    /// replaces the old one instead of stacking duplicates.
    func scheduleOneShot(id: String, title: String, body: String, fireDate: Date) {
        getAuthorizationStatus { granted in
            guard granted, fireDate > Date() else { return }

            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error { print("❌ scheduleOneShot failed:", error) }
            }
        }
    }

    /// Daily repeating notification at a fixed hour/minute (e.g. morning/evening food & walk).
    /// `id` MUST be stable (e.g. "foodwalk-\(petID)-morning").
    func scheduleDailyRepeating(id: String, title: String, body: String, hour: Int, minute: Int) {
        getAuthorizationStatus { granted in
            guard granted else { return }

            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            var comps = DateComponents()
            comps.hour = hour
            comps.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error { print("❌ scheduleDailyRepeating failed:", error) }
            }
        }
    }

    /// Cancel one specific reminder by its stable ID.
    func cancel(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    /// Cancel every pending reminder whose ID starts with `prefix` — use this
    /// when a pet is deleted (e.g. prefix: "medical-\(petID)" or just "\(petID)"
    /// if your IDs embed petID consistently).
    func cancelAll(withPrefix prefix: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let matchingIDs = requests.map { $0.identifier }.filter { $0.hasPrefix(prefix) }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: matchingIDs)
        }
    }
}
