//
//  onBoarding1.swift
//  Dr.Paw
//
//  Created by Adityasinh on 07/07/26.
//

import SwiftUI

struct onBoarding1: View {

    var body: some View {

        ZStack {

            Color(hex: "#ECE9E7")
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // Top Image
                Image("BoardingImg1")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 420)
                    .clipped()

                Spacer()
            }
            
            VStack {

                Spacer()

                // Bottom Card
                TopRoundedRectangle(radius: 45)
                    .fill(Color(hex: "#3A264B"))
                    .frame(height: 420)
                    .overlay {
                        VStack(spacing: 25) {

                            Text("Welcome to Dr.Paw")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)

                            Text("""
                Everything your pet needs in one place — care,
                health, products and community.
                """)
                                .font(.title3)
                                .foregroundStyle(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            // Page Indicator
                            HStack(spacing: 10) {

                                Capsule()
                                    .fill(Color(hex: "#F79E1B"))
                                    .frame(width: 30, height: 8)

                                Circle()
                                    .fill(.white.opacity(0.7))
                                    .frame(width: 8)

                                Circle()
                                    .fill(.white.opacity(0.7))
                                    .frame(width: 8)
                            }

                            // Continue Button
                            Button {

                            } label: {

                                Text("Continue")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .background(Color(hex: "#F79E1B"))
                                    .clipShape(Capsule())

                            }

                            // Skip Button
                            Button {

                            } label: {

                                Text("Skip")
                                    .font(.headline)
                                    .foregroundStyle(Color(hex: "#F79E1B"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color(hex: "#F79E1B"), lineWidth: 3)
                                    )

                            }

                            Spacer()

                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 45)
                    }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    onBoarding1()
}
