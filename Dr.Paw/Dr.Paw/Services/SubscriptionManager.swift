//
//  SubscriptionManager.swift
//  Dr.Paw
//
//  Created by Adityasinh on 19/09/26.
//

import Foundation
import RevenueCat

@MainActor
class SubscriptionManager: ObservableObject {
    static let entitlementID = "dr_paw_pro"
    static let trialLengthDays = 15

    @Published var isPro: Bool = false
    @Published var offerings: Offerings?
    @Published var isLoading: Bool = false
    @Published var trialDaysRemaining: Int = Self.trialLengthDays

    // The single source of truth for "should this person see the app right now?"
    var hasAccess: Bool {
        isPro || trialDaysRemaining > 0
    }

    init() {
        Task { await fetchOfferings() }
        Task { await checkSubscriptionStatus() }
    }

    func fetchOfferings() async {
        do {
            self.offerings = try await Purchases.shared.offerings()
        } catch {
            print("Error fetching offerings: \(error)")
        }
    }

    func checkSubscriptionStatus() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            applyStatus(from: customerInfo)
        } catch {
            print("Error checking subscription: \(error)")
        }
    }

    func purchase(package: Package) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await Purchases.shared.purchase(package: package)
            applyStatus(from: result.customerInfo)
            return isPro
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
    }

    func restorePurchases() async -> Bool {
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            applyStatus(from: customerInfo)
            return isPro
        } catch {
            print("Restore failed: \(error)")
            return false
        }
    }

    // Single place that updates both isPro and the trial countdown,
    // so the two can never drift out of sync from each other.
    private func applyStatus(from customerInfo: CustomerInfo) {
        self.isPro = customerInfo.entitlements[Self.entitlementID]?.isActive == true

        let daysSinceFirstSeen = Calendar.current.dateComponents(
            [.day],
            from: customerInfo.firstSeen,
            to: Date()
        ).day ?? 0

        self.trialDaysRemaining = max(0, Self.trialLengthDays - daysSinceFirstSeen)
    }
}
