//
//  SignUpView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 06/07/26.
//


import SwiftUI

struct SignUpView: View {

    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var gender = "Male"

    let genders = ["Male", "Female", "Other"]

    var body: some View {

        NavigationStack {

            ZStack {

                Color(hex: "#ECE9E7")
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
                                    .foregroundStyle(.black)
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

                            Text("Create your account")
                                .font(.title3)
                                .foregroundStyle(.gray)

                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                        // Name
                        HStack {

                            Image(systemName: "person")
                                .foregroundStyle(.gray)

                            TextField("Full Name", text: $name)

                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color(hex: "#6D4093").opacity(0.35), lineWidth: 2)
                        )
                        .padding(.horizontal)

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

                        Picker("Gender", selection: $gender) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                            Text("Other").tag("Other")
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color(hex: "#6D4093").opacity(0.35), lineWidth: 2)
                        )
                        .padding(.horizontal)

                        // Create Account Button
                        NavigationLink(destination: onBoarding1()) {

                            Text("Create Account")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color(hex: "#F79E1B"))
                                .clipShape(Capsule())

                        }
                        .padding(.horizontal)
                        .shadow(color: .orange.opacity(0.25), radius: 15)

                        HStack {

                            Text("Already have an account?")

                            Button("Log In") {
                                dismiss()
                            }
                            .foregroundStyle(Color(hex: "#6D4093"))
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
}

#Preview {
    SignUpView()
}
