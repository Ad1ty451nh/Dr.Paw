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
}
