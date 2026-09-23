//
//  LoginView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 06/07/26.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var session: UserSession
    
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var isLoading = false
    @State private var message: String?
    
    var body: some View {
        ZStack {
            background
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    header
                    
                    logo
                    
                    titleSection
                    
                    form
                    
                    footer
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - UI Components

private extension LoginView {
    
    var background: some View {
        Color.appBackground
            .ignoresSafeArea()
    }
    
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.appSurface)
                    .clipShape(Circle())
                    .shadow(
                        color: Color.appElevatedShadow,
                        radius: 8,
                        x: 0,
                        y: 3
                    )
            }
            
            Spacer()
        }
        .padding(.top, 12)
    }
    
    var logo: some View {
        ZStack {
            Circle()
                .fill(Color.appSurface)
                .frame(width: 150, height: 150)
                .shadow(
                    color: Color.appElevatedShadow,
                    radius: 16,
                    x: 0,
                    y: 8
                )
            
            Image("Drpaw")
                .resizable()
                .scaledToFit()
                .frame(width: 115, height: 115)
        }
        .padding(.top, 28)
        .padding(.bottom, 28)
    }
    
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Welcome Back")
                .font(.system(
                    size: 32,
                    weight: .bold,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextPrimary)
            
            Text("Enter your email & password")
                .font(.system(
                    size: 16,
                    weight: .medium,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 24)
    }
    
    var form: some View {
        VStack(spacing: 14) {
            emailField
            passwordField
            
            forgotPassword
            
            loginButton
            
            if let message {
                Text(message)
                    .font(.system(
                        size: 13,
                        weight: .medium,
                        design: .rounded
                    ))
                    .foregroundStyle(Color.red)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 8)
            }
        }
    }
    
    var emailField: some View {
        HStack(spacing: 12) {
            Image(systemName: "envelope")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.appBrand)
                .frame(width: 24)
            
            TextField("example@gmail.com", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.system(
                    size: 16,
                    weight: .medium,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextPrimary)
        }
        .padding(.horizontal, 18)
        .frame(height: 58)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.appBorder, lineWidth: 1)
        }
    }
    
    var passwordField: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.appBrand)
                .frame(width: 24)
            
            Group {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                } else {
                    SecureField("Password", text: $password)
                }
            }
            .font(.system(
                size: 16,
                weight: .medium,
                design: .rounded
            ))
            .foregroundStyle(Color.appTextPrimary)
            
            Button {
                isPasswordVisible.toggle()
            } label: {
                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 58)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.appBorder, lineWidth: 1)
        }
    }
    
    var forgotPassword: some View {
        HStack {
            Spacer()
            
            Button("Forgot Password") {
                resetPassword()
            }
            .font(.system(
                size: 14,
                weight: .semibold,
                design: .rounded
            ))
            .foregroundStyle(Color.appBrand)
            .disabled(isLoading)
        }
        .padding(.top, 2)
    }
    
    var loginButton: some View {
        Button {
            login()
        } label: {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .tint(Color.appOnBrand)
                }
                
                Text(isLoading ? "Logging In..." : "Log In")
                    .font(.system(
                        size: 17,
                        weight: .bold,
                        design: .rounded
                    ))
            }
            .foregroundStyle(Color.appOnBrand)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(Color.appBrand)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(
                color: Color.appElevatedShadow,
                radius: 12,
                x: 0,
                y: 6
            )
        }
        .disabled(isLoading)
        .padding(.top, 6)
    }
    
    var footer: some View {
        HStack(spacing: 5) {
            Text("Don't have an account?")
                .foregroundStyle(Color.appTextSecondary)
            
            NavigationLink {
                SignUpView()
            } label: {
                Text("Sign Up")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appBrand)
            }
        }
        .font(.system(
            size: 14,
            weight: .medium,
            design: .rounded
        ))
        .padding(.top, 28)
    }
}

// MARK: - Authentication

private extension LoginView {
    
    func login() {
        message = nil
        
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedEmail.isEmpty, !password.isEmpty else {
            message = "Enter your email and password."
            return
        }
        
        isLoading = true
        
        Task {
            defer {
                isLoading = false
            }
            
            do {
                try await session.signIn(
                    email: cleanedEmail,
                    password: password
                )
            } catch {
                message = error.localizedDescription
            }
        }
    }
    
    func resetPassword() {
        message = nil
        
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedEmail.isEmpty else {
            message = "Enter your email first, then tap Forgot Password."
            return
        }
        
        isLoading = true
        
        Task {
            defer {
                isLoading = false
            }
            
            do {
                try await session.resetPassword(email: cleanedEmail)
                message = "If an account exists for this email, a reset link has been sent."
            } catch {
                message = error.localizedDescription
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LoginView()
    }
    .environmentObject(UserSession())
}
