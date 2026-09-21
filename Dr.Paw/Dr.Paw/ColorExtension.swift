//
//  ColorExtension.swift
//  Dr.Paw
//
//  Created by Adityasinh on 06/07/26.
//


import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64

        switch hex.count {
        case 6:
            (r, g, b) = (
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )

        default:
            (r, g, b) = (255, 255, 255)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }

    private static func appDynamic(light: String, dark: String) -> Color {
        Color(UIColor { traitCollection in
            UIColor(hex: traitCollection.userInterfaceStyle == .dark ? dark : light)
        })
    }

    // Reds removed — down to a three-tone neutral palette: #BBA38E (taupe),
    // #E6D7BE (cream), #070705 (near-black). Near-black carries the brand role,
    // taupe carries the accent role, cream stays the warm neutral background.
    static let appBackground = appDynamic(light: "#E6D7BE", dark: "#070705")
    static let appSurface = appDynamic(light: "#F6EFE0", dark: "#1A1512")
    static let appTextPrimary = appDynamic(light: "#070705", dark: "#E6D7BE")
    static let appTextSecondary = appDynamic(light: "#070705", dark: "#E6D7BE").opacity(0.66)
    static let appBrand = appDynamic(light: "#070705", dark: "#E6D7BE")
    static let appAccent = appDynamic(light: "#BBA38E", dark: "#BBA38E")
    static let appOnBrand = appDynamic(light: "#E6D7BE", dark: "#070705")
    static let appOnAccent = appDynamic(light: "#070705", dark: "#070705")
    static let appBorder = appDynamic(light: "#BBA38E", dark: "#BBA38E").opacity(0.4)
    static let appElevatedShadow = appDynamic(light: "#070705", dark: "#000000").opacity(0.12)

    /// Warm taupe wash for banners, empty states and section fills.
    static let appBlush = appDynamic(light: "#BBA38E", dark: "#2A211A").opacity(0.35)

    /// Thin taupe hairline used under headings and to trace card edges.
    static let appHairline = appDynamic(light: "#BBA38E", dark: "#BBA38E").opacity(0.55)

    /// Monochrome gradient (taupe → near-black / cream in dark mode) used across
    /// headers, buttons and the tab bar highlight.
    static let appBrandGradient = LinearGradient(
        colors: [Color.appAccent, Color.appBrand],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

private extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64

        switch hex.count {
        case 6:
            (r, g, b) = (
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )
        default:
            (r, g, b) = (255, 255, 255)
        }

        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: 1
        )
    }
}
