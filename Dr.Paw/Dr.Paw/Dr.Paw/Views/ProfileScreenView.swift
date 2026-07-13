//
//  ProfileScreenView.swift
//  Dr.Paw
//
//  Saved animal profiles, scan history, and app settings.
//

import SwiftUI

struct ProfileScreenView: View {
    @EnvironmentObject var session: UserSession

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#ECE9E7")
                    .ignoresSafeArea()

                VStack(spacing: 14) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color(hex: "#6D4093"))

                    Text(session.nickname.isEmpty ? "Pet Parent" : session.nickname)
                        .font(.headline)

                    Text("Your saved animal profiles and scan history will show up here.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 110)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileScreenView()
        .environmentObject(UserSession())
}
