//
//  Dr_PawApp.swift
//  Dr.Paw
//
//  Created by admin on 22/06/26.
//

import SwiftUI
import WidgetKit
import RevenueCat
import UserNotifications

@main
struct Dr_PawApp: App {

    // MARK: - Global App Objects

    @StateObject private var session = UserSession()
    @StateObject private var deepLinkRouter = DeepLinkRouter()
    @StateObject private var subscriptionManager = SubscriptionManager()

    // IMPORTANT:
    // PetTimeActivityManager now lives at the APP level.
    //
    // This means the Live Activity manager is no longer dependent
    // on MyAnimals being visible.
    @StateObject private var petTimeActivityManager =
        PetTimeActivityManager.shared

    // MARK: - App Initialization

    init() {
        Purchases.logLevel = .debug

        Purchases.configure(
            withAPIKey: "test_JQnjmzMvOmuUQcqbbUgmmgTflML"
        )

        WidgetCenter.shared.reloadTimelines(
            ofKind: WidgetKind.foodWalk
        )

        WidgetCenter.shared.reloadTimelines(
            ofKind: WidgetKind.medicalVisit
        )

        NotificationManager.shared.requestPermission()

        // One-time cleanup:
        // Removes old random-UUID notification requests created
        // during earlier testing.
        //
        // You can remove this after the old notifications are gone.
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()

        let templates = NotificationManager.shared.loadTemplates()
        print(templates)
    }

    // MARK: - App Scene

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(session)
                .environmentObject(deepLinkRouter)
                .environmentObject(subscriptionManager)

                // GLOBAL LIVE ACTIVITY MANAGER
                .environmentObject(petTimeActivityManager)

                .environment(
                    \.managedObjectContext,
                    PersistenceController.shared
                        .container
                        .viewContext
                )

                .environmentObject(
                    PetStore(
                        context: PersistenceController.shared
                            .container
                            .viewContext
                    )
                )

                .environmentObject(
                    WeightHeightStore(
                        context: PersistenceController.shared
                            .container
                            .viewContext
                    )
                )

                .onOpenURL { url in
                    deepLinkRouter.handle(url)
                }
        }
    }
}

// MARK: - App Root

private struct AppRootView: View {

    @EnvironmentObject private var session: UserSession
    @EnvironmentObject private var subscriptionManager: SubscriptionManager

    // This is now the app-wide Live Activity manager.
    @EnvironmentObject private var petTimeActivityManager:
        PetTimeActivityManager

    @Environment(\.scenePhase)
    private var scenePhase

    @State private var splashFinished = false

    var body: some View {

        Group {

            if !splashFinished {

                LogoScreen {
                    splashFinished = true
                }

            } else if session.isAuthenticated {

                if session.shouldShowOnboarding {

                    NavigationStack {
                        onBoarding1()
                    }

                } else if subscriptionManager.hasAccess {

                    HomeScreenView()

                } else {

                    // Trial expired and user does not have Pro.
                    PaywallView(isDismissable: false)
                }

            } else {

                SplashScreen()
            }
        }

        // MARK: - Live Activity Lifecycle

        .onAppear {
            // Initial synchronization when the app root appears.
            petTimeActivityManager.refresh()
        }

        .onChange(of: scenePhase) { _, phase in

            switch phase {

            case .active:
                // App returned to foreground.
                //
                // This refresh now happens at the APP ROOT,
                // not only when MyAnimals is visible.
                petTimeActivityManager.refresh()

            case .background:
                // Nothing needs to be started here.
                //
                // ActivityKit keeps the Live Activity alive
                // independently of this SwiftUI view hierarchy.

                break

            case .inactive:
                // Temporary inactive state.
                break

            @unknown default:
                break
            }
        }
    }
}
