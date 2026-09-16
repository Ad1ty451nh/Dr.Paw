//
//  UserSession.swift
//  Dr.Paw
//
//  Created by Adityasinh on 10/07/26.
//

import SwiftUI
import Combine

@MainActor
class UserSession: ObservableObject {
    @AppStorage("userNickname") var nickname: String = ""
    @AppStorage("userEmail") var email: String = ""
    @AppStorage("profileImageData") var profileImageData: Data = Data()
    @Published private(set) var isAuthenticated = false
    @Published private(set) var shouldShowOnboarding = false
    private let authService = SupabaseAuthService()

    init() {
        isAuthenticated = KeychainStore.value(account: "accessToken") != nil
    }

    func signIn(email: String, password: String) async throws {
        try saveSession(try await authService.signIn(email: email, password: password))
        shouldShowOnboarding = true
    }

    func signUp(email: String, password: String, fullName: String, nickname: String) async throws -> Bool {
        let displayName = nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? fullName.trimmingCharacters(in: .whitespacesAndNewlines)
            : nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let response = try await authService.signUp(email: email, password: password, nickname: displayName, fullName: fullName)
        guard response.accessToken != nil else { return false }
        try saveSession(response, fallbackEmail: email, fallbackNickname: displayName)
        shouldShowOnboarding = true
        return true
    }

    func resetPassword(email: String) async throws {
        try await authService.resetPassword(email: email)
    }

    func signOut() {
        KeychainStore.delete(account: "accessToken")
        KeychainStore.delete(account: "refreshToken")
        isAuthenticated = false
        shouldShowOnboarding = false
    }

    func deleteAccount() {
        nickname = ""
        email = ""
        profileImageData = Data()
        signOut()
    }

    func finishOnboarding() {
        shouldShowOnboarding = false
    }

    private func saveSession(_ response: AuthResponse, fallbackEmail: String? = nil, fallbackNickname: String? = nil) throws {
        guard let accessToken = response.accessToken else {
            throw AuthError.message("Your account was created, but you need to confirm your email before logging in.")
        }
        try KeychainStore.save(accessToken, account: "accessToken")
        if let refreshToken = response.refreshToken {
            try KeychainStore.save(refreshToken, account: "refreshToken")
        }
        email = response.user?.email ?? fallbackEmail ?? email
        nickname = fallbackNickname ?? nickname
        isAuthenticated = true
    }
}
