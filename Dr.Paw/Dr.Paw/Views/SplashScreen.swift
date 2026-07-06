//
//  SplashScreen.swift
//  Dr.Paw
//
//  Created by admin on 03/07/26.
//
import SwiftUI

struct SplashScreen: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Color(hex: "#ECE9E7")
                    .ignoresSafeArea()
                
                Image("dog")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 850)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x:24)
                    .ignoresSafeArea()
                VStack(alignment: .leading,spacing: 15){
                    Spacer()
                    
                    Text("Dr.Paw")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("""
                    Care and services for your pets.
                    Helping your pets stay happy
                    and safe
                    """)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    
                    NavigationLink(destination: LoginView()){
                        Text("Log In")
                            .frame(maxWidth: 300)
                            .frame(height: 60)
                            .background(Color(hex: "#F79E1B"))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                    }
                    
                    NavigationLink(destination: SignUpView()){
                        Text("Sign Up")
                            .frame(maxWidth: 300)
                            .frame(height: 60)
                            .background(Color(hex: "#3A264B"))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                            .padding(.bottom,30)
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
