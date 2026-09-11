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
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
                .environmentObject(WeightHeightStore(context: PersistenceController.shared.container.viewContext))
        }
    }
}

private struct AppRootView: View {
    @EnvironmentObject private var session: UserSession
    @State private var splashFinished = false

    var body: some View {
        if !splashFinished {
            LogoScreen {
                splashFinished = true
            }
        } else if session.isAuthenticated {
            if session.shouldShowOnboarding {
                NavigationStack {
                    onBoarding1()
                }
            } else {
                HomeScreenView()
            }
        } else {
            SplashScreen() // your login/signup entry screen
        }
    }
}
