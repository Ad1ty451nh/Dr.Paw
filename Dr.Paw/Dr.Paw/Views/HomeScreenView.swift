//
//  HomeScreenView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 09/07/26.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var locationManager = LocationManager()
    @StateObject private var clinicViewModel = NearbyVetClinicViewModel()
    
    private var greetingName: String {
            session.nickname.isEmpty ? "Pet Parent" : session.nickname
        }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#ECE9E7")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        headerView
                        locationStatusView
                        clinicListView
                    }
                    .padding(.horizontal)
                    .padding(.top, 18)
                    .padding(.bottom, 28)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                locationManager.requestLocationAccess()
            }
            .onReceive(locationManager.$currentLocation.compactMap { $0 }) { newLocation in
                Task {
                    await clinicViewModel.fetchClinics(near: newLocation)
                }
            }
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    
                    // Have to fetch UserName
                    Text("Hello,\(greetingName)")
                        .font(.title2.weight(.bold))

                    Text("Find animal doctors near you")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image("Drpaw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58, height: 58)
                    .clipShape(Circle())
            }

            Button {
                locationManager.refreshLocation()
            } label: {
                Label("Refresh nearby clinics", systemImage: "location.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(hex: "#F79E1B"))
                    .clipShape(Capsule())
            }
            .shadow(color: .orange.opacity(0.22), radius: 12, x: 0, y: 8)
        }
    }

    @ViewBuilder
    private var locationStatusView: some View {
        if let error = locationManager.locationError ?? clinicViewModel.errorMessage {
            Text(error)
                .font(.subheadline)
                .foregroundStyle(Color(hex: "#3A264B"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        } else if clinicViewModel.isLoading {
            HStack(spacing: 12) {
                ProgressView()
                    .tint(Color(hex: "#6D4093"))

                Text("Finding nearby vet clinics...")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    @ViewBuilder
    private var clinicListView: some View {
        if clinicViewModel.clinics.isEmpty && clinicViewModel.isLoading == false {
            VStack(spacing: 14) {
                Image(systemName: "map")
                    .font(.system(size: 42))
                    .foregroundStyle(Color(hex: "#6D4093"))

                Text("Nearby clinics will appear here")
                    .font(.headline)

                Text("Allow location access so Dr. Paws can fetch animal doctors around you.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(28)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        } else {
            VStack(alignment: .leading, spacing: 14) {
                Text("Nearby Animal Doctors")
                    .font(.title3.weight(.bold))

                ForEach(clinicViewModel.clinics) { clinic in
                    VetClinicCardView(clinic: clinic)
                }
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
