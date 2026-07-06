//
//  SplashScreen.swift
//  Dr.Paw
//
//  Created by admin on 03/07/26.
//
import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.custom
                .ignoresSafeArea()

            Image("dog")
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 750)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x:24)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SplashScreen()
}
