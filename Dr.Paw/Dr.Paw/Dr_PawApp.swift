//
//  Dr_PawApp.swift
//  Dr.Paw
//
//  Created by admin on 22/06/26.
//
import SwiftUI

@main
struct Dr_PawApp: App {
    @StateObject private var session = UserSession()

    var body: some Scene {
        WindowGroup {
            LogoScreen()
                .environmentObject(session)
        }
    }
}
