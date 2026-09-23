//
//  LogoScreen.swift
//  Dr.Paw
//
//  Created by aditya on 03/07/26.
//

import SwiftUI

struct LogoScreen: View {
    
    let onFinished: () -> Void
    
    var body: some View {
        ZStack {
            background
            
            VStack(spacing: 0) {
                topPaws
                
                Spacer()
                
                logoContent
                
                Spacer()
                
                bottomPaws
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    onFinished()
                }
            }
        }
    }
}

// MARK: - UI Components

private extension LogoScreen {
    
    var background: some View {
        Color.appBackground
            .ignoresSafeArea()
    }
    
    var topPaws: some View {
        Image("catpaws")
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(180))
            .opacity(0.9)
            .frame(maxWidth: .infinity)
    }
    
    var bottomPaws: some View {
        Image("catpaws")
            .resizable()
            .scaledToFit()
            .opacity(0.9)
            .frame(maxWidth: .infinity)
    }
    
    var logoContent: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.appSurface)
                    .frame(width: 190, height: 190)
                    .shadow(
                        color: Color.appElevatedShadow,
                        radius: 20,
                        x: 0,
                        y: 10
                    )
                
                Image("Drpaw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 145, height: 145)
            }
            
            VStack(spacing: 4) {
                Text("Dr. Paws")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("Your offline pet health companion")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LogoScreen(onFinished: {})
        .environmentObject(UserSession())
}
