//
//  LoginView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 06/07/26.
//
import SwiftUI

struct LoginView: View {

    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    var body: some View {

        ZStack {

            Color(hex: "#ECE9E7")
                .ignoresSafeArea()

            VStack {

                // Back Button
                HStack {

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundStyle(.black)
                    }

                    Spacer()
                }
                .padding(.horizontal)

                Spacer()

                // Logo
                Image("Drpaw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 170)

                Spacer()
                // Title
                VStack(alignment: .leading, spacing: 8) {

                    Text("Log In")
                        .font(.system(size: 40, weight: .bold))

                    Text("Enter your email & password")
                        .font(.title3)
                        .foregroundStyle(.gray)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                Spacer()
                // Email
                HStack {

                    Image(systemName: "envelope")
                        .foregroundStyle(.gray)

                    TextField("example@gmail.com", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color(hex: "#6D4093").opacity(0.35), lineWidth: 2)
                )
                .padding(.horizontal)
                
                Spacer()

                // Password
                HStack {

                    Image(systemName: "lock")
                        .foregroundStyle(.gray)

                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }

                    Spacer()

                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundStyle(.gray)
                    }

                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color(hex: "#6D4093").opacity(0.35), lineWidth: 2)
                )
                .padding(.horizontal)

                // Forgot Password
                HStack {

                    Spacer()

                    Button("Forgot Password") {

                    }
                    .foregroundStyle(.black)

                }
                .padding(.horizontal)

                // Login Button
                NavigationLink(destination: onBoarding1()) {

                    Text("Log In")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(hex: "#F79E1B"))
                        .clipShape(Capsule())

                }
                .padding(.horizontal)
                .shadow(color: .orange.opacity(0.25), radius: 15)

                Spacer()

                HStack {

                    Text("Don't have an account?")

                    NavigationLink{
                        SignUpView()
                    } label: {
                        Text("Sign Up")
                    }
                    .foregroundStyle(Color(hex: "#6D4093"))
                    .fontWeight(.bold)

                }
                .padding(.bottom)

            }
            .padding(.top)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .environmentObject(UserSession())
}
