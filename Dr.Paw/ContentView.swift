//
//  ContentView.swift
//  Dr.Paw
//
//  Created by aditya on 22/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color.white
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.green)
                .frame(height: 150)
                .padding(.horizontal)
                .padding(.top)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
