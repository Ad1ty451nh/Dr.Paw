//
//  AboutView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//
import SwiftUI

struct About: View {

    @Environment(\.dismiss) var dismiss
    @Namespace private var glassNamespace

    var body: some View {

        ZStack {

            // Background gradient so the glass has something to refract against
            LinearGradient(
                colors: [Color(hex: "#F9E7C8"), Color(hex: "#ECE9E7")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 24) {

                    // Nav bar
                    HStack {

                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.black)
                                .frame(width: 44, height: 44)
                                .liquidGlass(in: Circle())
                        }

                        Spacer()

                        Text("About")
                            .font(.system(size: 22, weight: .bold))

                        Spacer()

                        // Spacer button to balance the back arrow, keeps title centered
                        Color.clear.frame(width: 44, height: 44)

                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // App icon + name card
                    VStack(spacing: 14) {

                        ZStack {
                            Image("Drpaw")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 170, height: 170)
                        }

                        VStack(spacing: 4) {

                            Text("Dr. Paws")
                                .font(.system(size: 24, weight: .bold))

                            Text("Offline pet health companion powered by on-device ML")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)

                        }

                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .liquidGlass(in: RoundedRectangle(cornerRadius: 32, style: .continuous))

                    // Content sections
                    VStack(spacing: 16) {

                        // Description
                        AboutSection(title: "What is Dr. Paws?") {
                            Text("Dr. Paws helps you identify animals instantly using your camera, then shows safe foods, foods to avoid, and simple home remedies — all working fully offline. It also lets you track your pet's growth over time.")
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.8))
                        }

                        // Version
                        AboutSection(title: "Version") {
                            Text("v1.0.0")
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.8))
                        }

                        // Developer credit
                        AboutSection(title: "Developed By") {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Adityasinh")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                        }

                        // Tech stack
                        AboutSection(title: "Built With") {
                            Text("SwiftUI, CoreML & Vision")
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.8))
                        }

                        // Disclaimer
                        AboutSection(title: "Disclaimer") {
                            Text("Dr. Paws provides general guidance only and is not a substitute for professional veterinary care. Always consult a vet for medical concerns.")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                                .italic()
                        }

                    }

                }
                .padding(.horizontal)
                .padding(.bottom, 40)

            }

        }
        .navigationBarBackButtonHidden(true)

    }
}

// MARK: - Reusable glass section wrapper

struct AboutSection<Content: View>: View {

    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
                .textCase(.uppercase)
                .tracking(0.5)

            content()

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .liquidGlass(in: RoundedRectangle(cornerRadius: 20, style: .continuous))

    }
}

#Preview {
    NavigationStack {
        About()
    }
}
