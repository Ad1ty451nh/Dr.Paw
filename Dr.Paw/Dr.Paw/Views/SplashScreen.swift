//
//  SplashScreen.swift
//  Dr.Paw
//
//  Created by admin on 03/07/26.
//

import SwiftUI

struct SplashScreen: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                
                dogImage
                
                content
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - UI Components

private extension SplashScreen {
    
    var background: some View {
        Color.appBackground
            .ignoresSafeArea()
    }
    
    var dogImage: some View {
        Image("dog")
            .resizable()
            .scaledToFit()
            .frame(width: 500, height: 850)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottomTrailing
            )
            .offset(x: 24)
            .ignoresSafeArea()
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Dr. Paw")
                    .font(.system(
                        size: 42,
                        weight: .bold,
                        design: .rounded
                    ))
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("Care and services for your pets.\nHelping your pets stay happy\nand safe.")
                    .font(.system(
                        size: 18,
                        weight: .medium,
                        design: .rounded
                    ))
                    .foregroundStyle(Color.appTextSecondary)
                    .lineSpacing(4)
            }
            
            Spacer()
            Spacer()
            Spacer()
            
            buttons
            
            Spacer()
                .frame(height: 30)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var buttons: some View {
        VStack(spacing: 14) {
            NavigationLink(destination: LoginView()) {
                Text("Log In")
                    .font(.system(
                        size: 17,
                        weight: .bold,
                        design: .rounded
                    ))
                    .foregroundStyle(Color.appOnBrand)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Color.appBrand)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                    .shadow(
                        color: Color.appElevatedShadow,
                        radius: 10,
                        x: 0,
                        y: 5
                    )
            }
            
            NavigationLink(destination: SignUpView()) {
                Text("Sign Up")
                    .font(.system(
                        size: 17,
                        weight: .bold,
                        design: .rounded
                    ))
                    .foregroundStyle(Color.appBrand)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Color.appSurface)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                Color.appBrand,
                                lineWidth: 1.5
                            )
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
            }
        }
        .frame(maxWidth: 320)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview {
    SplashScreen()
        .environmentObject(UserSession())
}
