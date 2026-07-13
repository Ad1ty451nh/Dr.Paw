//
//  AnimalLibraryView.swift
//  Dr.Paw
//
//  Month 5 of your roadmap: browse the JSON animal database
//  (safe foods, avoid foods, natural remedies) without scanning first.
//

import SwiftUI

struct AnimalLibraryView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#ECE9E7")
                    .ignoresSafeArea()

                VStack(spacing: 14) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(Color(hex: "#6D4093"))

                    Text("Animal library coming soon")
                        .font(.headline)

                    Text("Browse safe foods, foods to avoid, and natural remedies for each animal.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 110)
            }
            .navigationTitle("Library")
        }
    }
}

#Preview {
    AnimalLibraryView()
}
