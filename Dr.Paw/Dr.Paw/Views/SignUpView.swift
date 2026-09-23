//
//  SignUpView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 06/07/26.
//
//  UI PASS: restyled to the new neutral appBackground/appSurface/appBrand
//  palette (see ColorExtension.swift) instead of the old hardcoded hex
//  colors. Every field, the gender picker, and signUp() are unchanged.
//


import SwiftUI

struct SignUpView: View {

    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var nickname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var gender = "Male"
    @State private var isLoading = false
    @State private var message: String?

    let genders = ["Male", "Female", "Other"]

    var body: some View {

        NavigationStack {

            ZStack {

                Color.appBackground
                    .ignoresSafeArea()

                ScrollView {

                    VStack(spacing: 18) {

                        // Back Button
                        HStack {

                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundStyle(Color.appTextPrimary)
                            }

                            Spacer()
                        }
                        .padding(.horizontal)

                        // Logo
                        Image("Drpaw")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        // Title
                        VStack(alignment: .leading, spacing: 8) {

                            Text("Sign Up")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(Color.appTextPrimary)

                            Text("Create your account")
                                .font(.title3)
                                .foregroundStyle(Color.appTextSecondary)

                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                        // Name
                        HStack {

                            Image(systemName: "person")
                                .foregroundStyle(Color.appTextSecondary)

                            TextField("Full Name", text: $name)
                                .foregroundStyle(Color.appTextPrimary)

                        }
                        .padding()
                        .background(Color.appSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.appAccent.opacity(0.35), lineWidth: 2)
                        )
                        .padding(.horizontal)
                        
                        //UserName
                        HStack {

                            Image(systemName: "person")
                                .foregroundStyle(Color.appTextSecondary)

                            TextField("Your Nickname", text: $nickname)
                                .foregroundStyle(Color.appTextPrimary)

                        }
                        .padding()
                        .background(Color.appSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.appAccent.opacity(0.35), lineWidth: 2)
                        )
                        .padding(.horizontal)

                        // Email
                        HStack {

                            Image(systemName: "envelope")
                                .foregroundStyle(Color.appTextSecondary)

                            TextField("example@gmail.com", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .foregroundStyle(Color.appTextPrimary)

                        }
                        .padding()
                        .background(Color.appSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.appAccent.opacity(0.35), lineWidth: 2)
                        )
                        .padding(.horizontal)

                        // Password
                        HStack {

                            Image(systemName: "lock")
                                .foregroundStyle(Color.appTextSecondary)

                            if isPasswordVisible {
                                TextField("Password", text: $password)
                                    .foregroundStyle(Color.appTextPrimary)
                            } else {
                                SecureField("Password", text: $password)
                                    .foregroundStyle(Color.appTextPrimary)
                            }

                            Spacer()

                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundStyle(Color.appTextSecondary)
                            }

                        }
                        .padding()
                        .background(Color.appSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.appAccent.opacity(0.35), lineWidth: 2)
                        )
                        .padding(.horizontal)

                        Picker("Gender", selection: $gender) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                            Text("Other").tag("Other")
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.appSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.appAccent.opacity(0.35), lineWidth: 2)
                        )
                        .padding(.horizontal)

                        // Create Account Button
                        Button {
                            signUp()
                        } label: {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color.appBrandGradient)
                                .clipShape(Capsule())
                        }
                        .disabled(isLoading)
                        .padding(.horizontal)
                        .shadow(color: Color.appBrand.opacity(0.25), radius: 15)

                        if let message {
                            Text(message)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        HStack {

                            Text("Already have an account?")
                                .foregroundStyle(Color.appTextSecondary)

                            NavigationLink{
                                LoginView()
                            } label: {
                                Text("Log In")
                            }
                            .foregroundStyle(Color.appAccent)
                            .fontWeight(.bold)

                        }
                        .padding(.top, 10)

                    }
                    .padding(.vertical)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private func signUp() {
        message = nil
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !cleanedEmail.isEmpty,
              password.count >= 6 else {
            message = "Enter your name and email, and use a password with at least 6 characters."
            return
        }
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                let signedIn = try await session.signUp(email: cleanedEmail, password: password, fullName: name, nickname: nickname)
                if !signedIn { message = "Check your email to confirm your account, then log in." }
            } catch {
                message = error.localizedDescription
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(UserSession())
}
