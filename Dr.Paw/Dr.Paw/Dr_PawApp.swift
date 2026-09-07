//
//  Dr_PawApp.swift
//  Dr.Paw
//
//  Created by admin on 22/06/26.
//
import SwiftUI
import WidgetKit

@main
struct Dr_PawApp: App {
    
    init() {
        // Ask WidgetKit for fresh entries whenever the app launches. This also
        // clears a previously cached entry after the user changes the animal
        // in Edit Widget.
        WidgetCenter.shared.reloadTimelines(ofKind: "DrPawWidget")

        NotificationManager.shared.requestPermission()
        
        let templates = NotificationManager.shared.loadTemplates()
        print(templates)
        
        NotificationManager.shared.scheduleNotification(
            type: "treat",
            petName: "Bruno",
            after: 10
        )
    }
    
    @StateObject private var session = UserSession()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(session)
        }
    }
}

private struct AppRootView: View {
    @EnvironmentObject private var session: UserSession

    var body: some View {
        if session.isAuthenticated {
            if session.shouldShowOnboarding {
                NavigationStack {
                    onBoarding1()
                }
            } else {
                HomeScreenView()
            }
        } else {
            LogoScreen()
        }
    }
}
