//
//  onBoarding1.swift
//  Dr.Paw
//
//  Created by Adityasinh on 07/07/26.
//

import SwiftUI

struct onBoarding1: View {
    
    @EnvironmentObject private var session: UserSession
    
    var body: some View {
        ZStack {
            // MARK: - Background
            
            Color.appBackground
                .ignoresSafeArea()
            
            // MARK: - Top Image
            
            VStack(spacing: 0) {
                Image("BoardingImg1")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 390,
                        maxHeight: 430
                    )
                    .clipped()
                
                Spacer()
            }
            
            // MARK: - Bottom Content
            
            VStack {
                Spacer()
                
                bottomCard
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Bottom Card
    
    private var bottomCard: some View {
        VStack(spacing: 0) {
            VStack(spacing: 22) {
                
                // MARK: Title
                
                Text("Welcome to Dr.Paw")
                    .font(
                        .system(
                            size: 34,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
                    .multilineTextAlignment(.center)
                
                // MARK: Subtitle
                
                Text("Everything your pet needs in one place")
                    .font(
                        .system(
                            size: 17,
                            weight: .medium,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                
                // MARK: Page Indicator
                
                pageIndicator
                
                // MARK: Continue
                
                NavigationLink {
                    onBoarding2()
                } label: {
                    Text("Continue")
                        .font(
                            .system(
                                size: 17,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(Color.appOnAccent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color.appAccent)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 18,
                                style: .continuous
                            )
                        )
                        .shadow(
                            color: Color.appElevatedShadow,
                            radius: 10,
                            x: 0,
                            y: 5
                        )
                }
                
                // MARK: Skip
                
                Button {
                    session.finishOnboarding()
                } label: {
                    Text("Skip")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(Color.appBrand)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.clear)
                        .overlay {
                            RoundedRectangle(
                                cornerRadius: 18,
                                style: .continuous
                            )
                            .stroke(
                                Color.appBorder,
                                lineWidth: 1.5
                            )
                        }
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 34)
            .padding(.bottom, 34)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.appSurface
                .clipShape(
                    TopRoundedRectangle(radius: 40)
                )
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.appHairline)
                .frame(height: 1)
                .clipShape(Capsule())
                .padding(.horizontal, 70)
        }
    }
    
    // MARK: - Page Indicator
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            Capsule()
                .fill(Color.appBrand)
                .frame(width: 28, height: 7)
            
            Circle()
                .fill(Color.appAccent.opacity(0.35))
                .frame(width: 7, height: 7)
            
            Circle()
                .fill(Color.appAccent.opacity(0.35))
                .frame(width: 7, height: 7)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        onBoarding1()
            .environmentObject(UserSession())
    }
}
