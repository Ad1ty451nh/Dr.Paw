//
//  View+LiquidGlass.swift
//  Dr.Paw
//
//  Created by Adityasinh on 04/08/26.
//

import SwiftUI

// MARK: - Liquid Glass helper
/// Wraps iOS 26's real Liquid Glass material where available,
/// and falls back to a frosted-material look on earlier OS versions
/// so the build still compiles/looks reasonable on older SDKs.
extension View {
    @ViewBuilder
    func liquidGlass<S: InsettableShape>(in shape: S, tint: Color? = nil) -> some View {
        if #available(iOS 26.0, *) {
            if let tint {
                self.glassEffect(.regular.tint(tint).interactive(), in: shape)
            } else {
                self.glassEffect(.regular.interactive(), in: shape)
            }
        } else {
            self
                .background(.ultraThinMaterial, in: shape)
                .overlay(shape.strokeBorder(.white.opacity(0.25), lineWidth: 0.5))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        }
    }
}
