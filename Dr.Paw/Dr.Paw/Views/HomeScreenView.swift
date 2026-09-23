//
//  HomeScreenView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 09/07/26.
//  Updated: now owns the tab bar directly (Liquid Glass style, iOS 26+)
//  plus the raised center camera button and the scan flow.
//
//  UI PASS: restyled to the new neutral appBackground/appSurface/appBrand
//  palette (see ColorExtension.swift) instead of the old hardcoded hex
//  colors. Nothing functional changed — same TabView, same sheet/
//  fullScreenCover wiring, same location + clinic pipeline.
//

import SwiftUI
import UIKit
 
enum AppTab {
    case home, growth, library, profile
}
 
struct HomeScreenView: View {
    @EnvironmentObject var session: UserSession
    @EnvironmentObject var deepLinkRouter: DeepLinkRouter
    @StateObject private var locationManager = LocationManager()
    @StateObject private var clinicViewModel = NearbyVetClinicViewModel()
 
    @State private var selectedTab: AppTab = .home
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var showScanResult = false
    @Namespace private var glassNamespace

    // Controls how many clinics are rendered at once — "Load More" adds 5 more each tap
    @State private var visibleClinicCount = 5

    // ACTIVE NAVBAR COLOR: change this value to update the selected tab icon,
    // label, and its highlighted pill background.
    // Swapped from the old hardcoded orange to the brand accent so it now
    // tracks light/dark mode automatically.
    private let activeTabColor = Color.appAccent
 
    private var greetingName: String {
        session.nickname.isEmpty ? "Pet Parent" : session.nickname
    }
 
    var body: some View {
        
        TabView {
            homeContent
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            MyAnimals()
                .tabItem {
                    Image(systemName: "pawprint")
                    Text("My Animals")
                }

            CameraCaptureView { image in
                guard let image else { return }
                capturedImage = image
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showScanResult = true
                }
            }
            .tabItem {
                Image(systemName: "camera")
                Text("Camera")
            }

            AnimalLibraryView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Library")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            }
        .tint(activeTabColor)
        .ignoresSafeArea(edges: .bottom)
        .sheet(item: $deepLinkRouter.destination) { destination in
            switch destination {
            case .foodWalk:
                FoodWalkTrackerView()
            case .medical:
                MedicalReminderView()
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraCaptureView { image in
                showCamera = false
                guard let image else { return }
                capturedImage = image
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showScanResult = true
                }
            }
        }
        .fullScreenCover(isPresented: $showScanResult) {
            if let capturedImage {
                ScanResultView(image: capturedImage)
            }
        }
    }
    
 
    // MARK: - Home Tab Content (your original screen)
 
    private var homeContent: some View {
        NavigationStack {
            ZStack {
                homeBackground
 
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        heroHeader
                        petSpaceView
                        refreshButton
                        locationStatusView
                        clinicListView
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 110) // clear the floating tab bar
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

    // MARK: - Background
    // Same soft-blurred-circle treatment used on AnimalLibraryView, so every
    // top-level tab now shares one visual identity instead of each screen
    // inventing its own background.

    private var homeBackground: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.appBrand.opacity(0.16))
                .frame(width: 260, height: 260)
                .blur(radius: 35)
                .offset(x: -140, y: -300)

            Circle()
                .fill(Color.appAccent.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 35)
                .offset(x: 150, y: 380)
        }
    }

    // MARK: - Hero header
    // Replaces the old plain "Hello, Name" row with a gradient hero card,
    // matching the hero used in AnimalLibraryView / PaywallView so the app
    // reads as one design system rather than three different ones.

    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [
                    Color.appBrand,
                    Color.appAccent,
                    Color.appBrand.opacity(0.75)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: "pawprint.fill")
                .font(.system(size: 120, weight: .bold))
                .foregroundStyle(.white.opacity(0.13))
                .rotationEffect(.degrees(-18))
                .offset(x: 130, y: -10)
                .shadow(radius: 7)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("WELCOME BACK")
                        .font(.caption.weight(.bold))
                        .tracking(1.4)
                        .foregroundStyle(.white.opacity(0.75))
                    Spacer()
                    Text("Hello, \(greetingName)")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Text("Find animal doctors near you")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                    Spacer()
                }

                Spacer()
                VStack{
                    NavigationLink(destination: ProfileScreenView()) {
                        homeProfileAvatar
                    }
                    Spacer()
                }
            }
            .padding(20)
        }
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.appBrand.opacity(0.28), radius: 16, y: 9)
    }

    private var homeProfileAvatar: some View {
        Group {
            if let image = UIImage(data: session.profileImageData), !session.profileImageData.isEmpty {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(.white.opacity(0.18))
            }
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .shadow(color: Color(.systemBackground).opacity(0.5), radius: 8)
        .overlay(
            Circle()
                .stroke(.white.opacity(0.85), lineWidth: 2)
        )
    }

    // MARK: - Pet Space (4-card feature grid)

    private var petSpaceView: some View {
        VStack(alignment: .leading, spacing: 14) {

            Label("PET SPACE", systemImage: "square.grid.2x2.fill")
                .font(.caption.weight(.bold))
                .tracking(1.2)
                .foregroundStyle(Color.appAccent)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {

                PetSpaceCard(icon: "scalemass.fill", title: "Weight & Height", tint: .blue) {
                    WeightHeightTrackerView()
                }

                PetSpaceCard(icon: "cross.case.fill", title: "Medical Reminder", tint: .orange) {
                    MedicalReminderView()
                }

                PetSpaceCard(icon: "figure.walk", title: "Food & Walk", tint: .green) {
                    FoodWalkTrackerView()
                }

                PetSpaceCard(icon: "pawprint.fill", title: "Pets List", tint: .purple) {
                    PetsListView()
                }

            }

        }
    }

    private var refreshButton: some View {
        Button {
            locationManager.refreshLocation()
        } label: {
            Label("Refresh nearby clinics", systemImage: "location.circle.fill")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.appBrandGradient)
                .clipShape(Capsule())
        }
        .shadow(color: Color.appBrand.opacity(0.22), radius: 12, x: 0, y: 8)
    }
 
    @ViewBuilder
    private var locationStatusView: some View {
        if let error = locationManager.locationError ?? clinicViewModel.errorMessage {
            Text(error)
                .font(.subheadline)
                .foregroundStyle(Color.appTextPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        } else if clinicViewModel.isLoading {
            HStack(spacing: 12) {
                ProgressView()
                    .tint(Color.appAccent)
 
                Text("Finding nearby vet clinics...")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }
 
    @ViewBuilder
    private var clinicListView: some View {
        if clinicViewModel.clinics.isEmpty && clinicViewModel.isLoading == false {
            VStack(spacing: 14) {
                Image(systemName: "map")
                    .font(.system(size: 42))
                    .foregroundStyle(Color.appAccent)
 
                Text("Nearby clinics will appear here")
                    .font(.headline)
                    .foregroundStyle(Color.appTextPrimary)
 
                Text("Allow location access so Dr. Paws can fetch animal doctors around you.")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(28)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        } else {
            VStack(alignment: .leading, spacing: 14) {
                Label("NEARBY ANIMAL DOCTORS", systemImage: "cross.case.fill")
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.appAccent)
 
                ForEach(clinicViewModel.clinics.prefix(visibleClinicCount)) { clinic in
                    VetClinicCardView(clinic: clinic)
                }

                if visibleClinicCount < clinicViewModel.clinics.count {
                    Button {
                        visibleClinicCount += 5
                    } label: {
                        Text("Load More")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.appBrand)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.appSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
            }
        }
    }
}

// MARK: - Pet Space feature card
// Restyled to match AnimalCardView's card language: appSurface fill, a
// hairline border, and a colored icon badge instead of a flat tint badge.

struct PetSpaceCard<Destination: View>: View {

    let icon: String
    let title: String
    let tint: Color
    @ViewBuilder let destination: () -> Destination

    var body: some View {

        NavigationLink(destination: destination()) {

            VStack(alignment: .leading, spacing: 12) {

                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(tint.opacity(0.15))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(tint)
                }

                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 130, alignment: .topLeading)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(tint.opacity(0.16), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)

        }
        .buttonStyle(.plain)

    }
}
#Preview {
    HomeScreenView()
        .environmentObject(UserSession())
        .environmentObject(DeepLinkRouter())
        .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
        .environmentObject(WeightHeightStore(context: PersistenceController.shared.container.viewContext))
        .environmentObject(SubscriptionManager())
}
