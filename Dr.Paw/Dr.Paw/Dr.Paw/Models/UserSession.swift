//
//  UserSession.swift
//  Dr.Paw
//
//  Created by Adityasinh on 10/07/26.
//

import SwiftUI

@MainActor
class UserSession: ObservableObject {
    @AppStorage("userNickname") var nickname: String = ""
    // later this can be backed by Core Data instead of AppStorage —
    // same pattern, just swap the storage underneath
}
