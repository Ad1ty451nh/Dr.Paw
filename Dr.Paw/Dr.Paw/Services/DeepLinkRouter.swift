//
//  DeepLinkRouter.swift
//  Dr.Paw
//

import SwiftUI

@MainActor
final class DeepLinkRouter: ObservableObject {
    @Published var destination: AppDeepLink?

    func handle(_ url: URL) {
        destination = AppDeepLink.from(url)
    }
}
