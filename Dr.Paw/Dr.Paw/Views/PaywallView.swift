//
//  PaywallView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 21/09/26.
//
import SwiftUI
import RevenueCat

struct PaywallView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) var dismiss

    @State private var selectedPackage: Package?
    @State private var isPurchasing = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            paywallBackground

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    heroHeader
                        .padding(.top,40)
                    benefitsCard
                    packagesSection
                    ctaButton

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    footer
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .overlay(alignment: .topTrailing) {
            topControls
                .padding(.horizontal, 24)
                .padding(.top, 14)
        }
        .onAppear {
            if selectedPackage == nil {
                selectedPackage = subscriptionManager.offerings?.current?.availablePackages
                    .first { $0.packageType == .annual }
                ?? subscriptionManager.offerings?.current?.availablePackages.first
            }
        }
    }

    // MARK: - Background

    private var paywallBackground: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.appBrand.opacity(0.16))
                .frame(width: 260, height: 260)
                .blur(radius: 35)
                .offset(x: 145, y: -320)

            Circle()
                .fill(Color.appAccent.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 35)
                .offset(x: -150, y: 420)
        }
    }

    // MARK: - Top controls (X / Restore)

    private var topControls: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.appTextSecondary)
                    .frame(width: 34, height: 34)
                    .background(Color.appSurface)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
            }

            Spacer()

            Button {
                Task {
                    let restored = await subscriptionManager.restorePurchases()
                    if restored { dismiss() }
                }
            } label: {
                Text("Restore")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.primary)
            }
        }
    }

    // MARK: - Hero header (mirrors AnimalLibraryView's heroHeader)

    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    Color.appBrand,
                    Color.appAccent,
                    Color.appBrand.opacity(0.75)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: "pawprint.fill")
                .font(.system(size: 125, weight: .bold))
                .foregroundStyle(.white.opacity(0.13))
                .rotationEffect(.degrees(-18))
                .offset(x: 130, y: -10)

            VStack(alignment: .leading, spacing: 10) {
                Text("DR PAW PRO")
                    .font(.caption.weight(.bold))
                    .tracking(1.4)
                    .foregroundStyle(.white.opacity(0.75))

                Text("Unlock Full\nPet Care")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Unlimited scans, the full care library, and complete growth history.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(maxWidth: 240, alignment: .leading)
            }
            .padding(22)
            .padding(.top, 20)
        }
        .frame(height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.appBrand.opacity(0.28), radius: 16, y: 9)
    }

    // MARK: - Benefits

    private var benefitsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("WHAT YOU GET", systemImage: "sparkles")
                .font(.caption.weight(.bold))
                .tracking(1.3)
                .foregroundStyle(Color.appAccent)

            BenefitRow(icon: "pawprint.fill", title: "Unlimited breed scans", color: .orange)
            BenefitRow(icon: "cross.case.fill", title: "Full symptom & vet library", color: .blue)
            BenefitRow(icon: "chart.line.uptrend.xyaxis", title: "Complete growth history", color: .green)
        }
        .padding(18)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 9, y: 4)
    }

    // MARK: - Packages

    private var packagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CHOOSE A PLAN")
                .font(.caption.weight(.bold))
                .tracking(1.2)
                .foregroundStyle(Color.appAccent)

            if let packages = subscriptionManager.offerings?.current?.availablePackages {
                VStack(spacing: 12) {
                    ForEach(packages) { package in
                        PackageCard(
                            package: package,
                            isSelected: selectedPackage?.identifier == package.identifier
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                selectedPackage = package
                            }
                        }
                    }
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            }
        }
    }

    // MARK: - CTA

    private var ctaButton: some View {
        Button {
            guard let package = selectedPackage else { return }
            isPurchasing = true
            errorMessage = nil
            Task {
                let success = await subscriptionManager.purchase(package: package)
                isPurchasing = false
                if success {
                    dismiss()
                } else {
                    errorMessage = "Purchase couldn't be completed. Please try again."
                }
            }
        } label: {
            Group {
                if isPurchasing {
                    ProgressView().tint(.white)
                } else {
                    Text("Continue")
                        .font(.headline.weight(.bold))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: selectedPackage == nil
                        ? [Color.gray.opacity(0.5), Color.gray.opacity(0.5)]
                        : [Color.appBrand, Color.appAccent],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.appBrand.opacity(0.25), radius: 12, y: 6)
        }
        .disabled(selectedPackage == nil || isPurchasing)
    }

    // MARK: - Footer

    private var footer: some View {
        VStack(spacing: 10) {
            Text("Cancel anytime")
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)

            HStack(spacing: 16) {
                Link("Terms", destination: URL(string: "https://your-terms-url.com")!)
                Link("Privacy", destination: URL(string: "https://your-privacy-url.com")!)
            }
            .font(.caption2.weight(.semibold))
            .foregroundStyle(Color.appTextSecondary.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }
}

// MARK: - Benefit Row (mirrors CareRow)

private struct BenefitRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.appTextPrimary)

            Spacer()
        }
    }
}

// MARK: - Package Card (mirrors AnimalCardView)

private struct PackageCard: View {
    let package: Package
    let isSelected: Bool

    private var title: String {
        switch package.packageType {
        case .monthly: return "Monthly"
        case .annual: return "Annual"
        case .lifetime: return "Lifetime"
        default: return package.storeProduct.localizedTitle
        }
    }

    private var isBestValue: Bool {
        package.packageType == .annual
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 7) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appTextPrimary)

                    if isBestValue {
                        Text("BEST VALUE")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.appAccent)
                            .clipShape(Capsule())
                    }
                }

                Text(package.storeProduct.localizedPriceString)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(isSelected ? Color.appBrand : Color.appTextSecondary.opacity(0.4))
        }
        .padding(16)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(isSelected ? Color.appBrand : Color.clear, lineWidth: 2)
        }
        .shadow(
            color: isSelected ? Color.appBrand.opacity(0.15) : .black.opacity(0.04),
            radius: 8,
            y: 4
        )
    }
}

#Preview {
    PaywallView()
        .environmentObject(SubscriptionManager())
}
