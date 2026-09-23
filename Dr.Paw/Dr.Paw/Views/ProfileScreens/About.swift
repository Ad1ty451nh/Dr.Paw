//
//  AboutView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//

import SwiftUI

struct About: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            screenBackground

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    header

                    appHero

                    aboutContent
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 110)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Background

    private var screenBackground: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.appAccent.opacity(0.13))
                .frame(width: 280, height: 280)
                .blur(radius: 50)
                .offset(x: 170, y: -350)

            Circle()
                .fill(Color.appBrand.opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: -170, y: 420)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 14) {

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.appSurface)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                Color.appBorder,
                                lineWidth: 1
                            )
                    }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 3) {

                Text("ABOUT THE APP")
                    .font(.caption.weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color.appAccent)

                Text("About")
                    .font(
                        .system(
                            size: 28,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()

            Image(systemName: "pawprint.fill")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 44, height: 44)
                .background(Color.appBlush)
                .clipShape(Circle())
        }
    }

    // MARK: - App Hero

    private var appHero: some View {
        VStack(spacing: 18) {

            ZStack {
                Circle()
                    .fill(Color.appBlush)
                    .frame(width: 150, height: 150)

                Circle()
                    .stroke(
                        Color.appAccent.opacity(0.20),
                        lineWidth: 1
                    )
                    .frame(width: 150, height: 150)

                Image("Drpaw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
            }

            VStack(spacing: 7) {

                Text("Dr. Paws")
                    .font(
                        .system(
                            size: 25,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                Text(
                    "Offline pet health companion powered by on-device ML"
                )
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
                .padding(.horizontal, 25)
            }

            HStack(spacing: 7) {

                Image(systemName: "wifi.slash")
                    .font(.caption.weight(.bold))

                Text("Works offline")
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(Color.appBrand)
            .padding(.horizontal, 13)
            .padding(.vertical, 8)
            .background(Color.appBrand.opacity(0.10))
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .padding(.horizontal, 20)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.45),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 12,
            y: 6
        )
    }

    // MARK: - Content

    private var aboutContent: some View {
        VStack(spacing: 14) {

            AboutSection(
                title: "What is Dr. Paws?",
                icon: "pawprint.fill"
            ) {
                Text(
                    "Dr. Paws helps you identify animals instantly using your camera, then shows safe foods, foods to avoid, and simple home remedies — all working fully offline. It also lets you track your pet's growth over time."
                )
                .font(.system(size: 15))
                .foregroundStyle(Color.appTextSecondary)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
            }

            HStack(spacing: 14) {

                AboutInfoCard(
                    title: "VERSION",
                    value: "v1.0.0",
                    icon: "number"
                )

                AboutInfoCard(
                    title: "DEVELOPER",
                    value: "Adityasinh",
                    icon: "person.fill"
                )
            }

            AboutSection(
                title: "Built With",
                icon: "hammer.fill"
            ) {
                HStack(spacing: 10) {

                    technologyBadge(
                        icon: "swift",
                        title: "SwiftUI"
                    )

                    technologyBadge(
                        icon: "brain.head.profile",
                        title: "CoreML"
                    )

                    technologyBadge(
                        icon: "viewfinder",
                        title: "Vision"
                    )
                }
            }

            AboutSection(
                title: "Disclaimer",
                icon: "exclamationmark.triangle.fill"
            ) {
                Text(
                    "Dr. Paws provides general guidance only and is not a substitute for professional veterinary care. Always consult a vet for medical concerns."
                )
                .font(.system(size: 14))
                .foregroundStyle(Color.appTextSecondary)
                .italic()
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
            }
        }
    }

    // MARK: - Technology Badge

    private func technologyBadge(
        icon: String,
        title: String
    ) -> some View {

        HStack(spacing: 7) {

            Image(systemName: icon)
                .font(.caption.weight(.bold))

            Text(title)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(Color.appBrand)
        .padding(.horizontal, 11)
        .padding(.vertical, 9)
        .background(Color.appBrand.opacity(0.09))
        .clipShape(Capsule())
    }
}

// MARK: - About Section

struct AboutSection<Content: View>: View {

    let title: String
    let icon: String

    @ViewBuilder
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {

            HStack(spacing: 8) {

                Image(systemName: icon)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.appAccent)

                Text(title.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(1.1)
                    .foregroundStyle(Color.appTextPrimary)
            }

            content()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(17)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.35),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 8,
            y: 4
        )
    }
}

// MARK: - About Info Card

private struct AboutInfoCard: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 38, height: 38)
                .background(Color.appBlush)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 11,
                        style: .continuous
                    )
                )

            VStack(alignment: .leading, spacing: 3) {

                Text(title)
                    .font(.caption.weight(.bold))
                    .tracking(0.8)
                    .foregroundStyle(Color.appTextSecondary)

                Text(value)
                    .font(
                        .system(
                            size: 15,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(16)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.35),
                lineWidth: 1
            )
        }
    }
}

#Preview {
    NavigationStack {
        About()
    }
}
