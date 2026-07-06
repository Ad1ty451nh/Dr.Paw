//
//  SplashScreenView.swift
//  Dr.Paw
//
//  Created by aditya on 03/07/26.
//
import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.orange
                    .ignoresSafeArea()

                VStack {
                    // Top Cat Paws
                    Image("catpaws")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(180))

                    Spacer()

                    // Logo + App Name
                    VStack(spacing: 10) {
                        Image("Drpaw")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)

                        Text("Dr. Paws")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }

                    Spacer()

                    // Bottom Cat Paws
                    Image("catpaws")
                        .resizable()
                        .scaledToFit()
                         // Flip for bottom
                }
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
