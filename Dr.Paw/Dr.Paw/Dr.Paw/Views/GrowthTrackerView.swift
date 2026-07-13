//
//  GrowthTrackerView.swift
//  Dr.Paw
//
//  Month 7 of your roadmap: monthly photo timeline, date stamps,
//  swipeable comparison view, local reminder notifications.
//

import SwiftUI

struct GrowthTrackerView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#ECE9E7")
                    .ignoresSafeArea()

                VStack(spacing: 14) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 42))
                        .foregroundStyle(Color(hex: "#6D4093"))

                    Text("No growth photos yet")
                        .font(.headline)

                    Text("Photos you scan get added here automatically so you can track changes over time.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 110) // clear the floating tab bar
            }
            .navigationTitle("Growth Tracker")
        }
    }
}

#Preview {
    GrowthTrackerView()
}
