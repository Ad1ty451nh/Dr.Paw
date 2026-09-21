//
//  Dr_PawApp.swift
//  Dr.Paw
//
//  Created by admin on 22/06/26.
//
//import SwiftUI
//import WidgetKit
//import RevenueCat
//
//@main
//struct Dr_PawApp: App {
//    
//    init() {
//        Purchases.logLevel = .debug
//        Purchases.configure(withAPIKey: "test_JQnjmzMvOmuUQcqbbUgmmgTflML")
//        
//        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.foodWalk)
//        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.medicalVisit)
//
//        NotificationManager.shared.requestPermission()
//        
//        let templates = NotificationManager.shared.loadTemplates()
//        print(templates)
//        
//        NotificationManager.shared.scheduleNotification(
//            type: "treat",
//            petName: "Bruno",
//            after: 10
//        )
//    }
//    
//    @StateObject private var session = UserSession()
//    @StateObject private var deepLinkRouter = DeepLinkRouter()
//    @StateObject private var subscriptionManager = SubscriptionManager()
//
//    var body: some Scene {
//        WindowGroup {
//            AppRootView()
//                .environmentObject(session)
//                .environmentObject(deepLinkRouter)
//                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//                .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
//                .environmentObject(WeightHeightStore(context: PersistenceController.shared.container.viewContext))
//                .environmentObject(subscriptionManager)
//                .onOpenURL { url in
//                    deepLinkRouter.handle(url)
//                }
//        }
//    }
//}
//
//private struct AppRootView: View {
//    @EnvironmentObject private var session: UserSession
//    @State private var splashFinished = false
//
//    var body: some View {
//        if !splashFinished {
//            LogoScreen {
//                splashFinished = true
//            }
//        } else if session.isAuthenticated {
//            if session.shouldShowOnboarding {
//                NavigationStack {
//                    onBoarding1()
//                }
//            } else {
//                HomeScreenView()
//            }
//        } else {
//            SplashScreen() // your login/signup entry screen
//        }
//    }
//}


//
//  Dr_PawApp.swift
//  Dr.Paw
//
//  Created by admin on 22/06/26.
//
import SwiftUI
import WidgetKit
import RevenueCat

@main
struct Dr_PawApp: App {
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "test_JQnjmzMvOmuUQcqbbUgmmgTflML")
        
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.foodWalk)
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.medicalVisit)

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
    @StateObject private var deepLinkRouter = DeepLinkRouter()
    @StateObject private var subscriptionManager = SubscriptionManager()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(session)
                .environmentObject(deepLinkRouter)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
                .environmentObject(WeightHeightStore(context: PersistenceController.shared.container.viewContext))
                .environmentObject(subscriptionManager)
                .onOpenURL { url in
                    deepLinkRouter.handle(url)
                }
        }
    }
}

private struct AppRootView: View {
    @EnvironmentObject private var session: UserSession
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
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
            } else if subscriptionManager.hasAccess {
                HomeScreenView()
            } else {
                // Trial expired and not Pro — hard paywall, no way around it.
                PaywallView(isDismissable: false)
            }
        } else {
            SplashScreen() // your login/signup entry screen
        }
    }
}
