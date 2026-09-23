//
//  MyAnimals.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//

import SwiftUI

struct MyAnimals: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var petStore: PetStore

    @StateObject private var timerManager = PetTimeActivityManager.shared

    var body: some View {
        ZStack {
            screenBackground

            VStack(spacing: 0) {
                header

                if petStore.pets.isEmpty {
                    emptyState
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            activePetsHeader

                            ForEach(
                                petStore.pets,
                                id: \.objectID
                            ) { pet in

                                VStack(alignment: .leading, spacing: 10) {

                                    NavigationLink {
                                        PetDetailsView(pet: pet)
                                    } label: {
                                        animalRow(pet)
                                    }
                                    .buttonStyle(.plain)

                                    if let petID = pet.id?.uuidString {
                                        timerControls(
                                            for: pet,
                                            petID: petID
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 110)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            timerManager.refresh()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                timerManager.refresh()
            }
        }
    }

    // MARK: - Background

    private var screenBackground: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.appAccent.opacity(0.14))
                .frame(width: 270, height: 270)
                .blur(radius: 45)
                .offset(x: 170, y: -350)

            Circle()
                .fill(Color.appBrand.opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: -170, y: 400)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 14) {

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.appSurface)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                Color.appBorder,
                                lineWidth: 1
                            )
                    }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 3) {

                Text("YOUR COMPANIONS")
                    .font(.caption.weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color.appAccent)

                Text("My Animals")
                    .font(
                        .system(
                            size: 28,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()

            Image(systemName: "pawprint.fill")
                .font(.title3.weight(.bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 44, height: 44)
                .background(Color.appBlush)
                .clipShape(Circle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }

    // MARK: - Active Pets Header

    private var activePetsHeader: some View {
        HStack {

            VStack(alignment: .leading, spacing: 4) {
                Text("MY PETS")
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.appAccent)

                Text(
                    "\(petStore.pets.count) "
                    + (petStore.pets.count == 1 ? "companion" : "companions")
                )
                .font(
                    .system(
                        size: 17,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()

            Image(systemName: "heart.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 34, height: 34)
                .background(Color.appBlush)
                .clipShape(Circle())
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 18) {

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.appBlush)
                    .frame(width: 100, height: 100)

                Image(systemName: "pawprint.fill")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(Color.appAccent)
            }

            VStack(spacing: 7) {

                Text("No pets added yet")
                    .font(
                        .system(
                            size: 22,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                Text(
                    "Add a pet from Pets List, then come back to see them here."
                )
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
                .padding(.horizontal, 28)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }

    // MARK: - Animal Row

    private func animalRow(_ pet: Pet) -> some View {
        HStack(spacing: 14) {

            petImage(pet)

            VStack(alignment: .leading, spacing: 5) {

                Text(pet.name ?? "Unnamed")
                    .font(
                        .system(
                            size: 19,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                let details = [
                    pet.species,
                    pet.breed
                ]
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .joined(separator: " · ")

                if !details.isEmpty {
                    Text(details)
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(1)
                }

                HStack(spacing: 5) {
                    Image(systemName: "chevron.right")
                    Text("View profile")
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.appAccent)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color.appTextSecondary)
                .frame(width: 34, height: 34)
                .background(Color.appBackground)
                .clipShape(Circle())
        }
        .padding(15)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.45),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            y: 5
        )
    }

    // MARK: - Pet Image

    @ViewBuilder
    private func petImage(_ pet: Pet) -> some View {

        if let photoData = pet.photoData,
           let uiImage = UIImage(data: photoData) {

            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 68, height: 68)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )

        } else {

            ZStack {
                LinearGradient(
                    colors: [
                        Color.appBrand,
                        Color.appAccent
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Image(systemName: "pawprint.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.appOnBrand)
            }
            .frame(width: 68, height: 68)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )
        }
    }

    // MARK: - Timer Controls

    private func timerControls(
        for pet: Pet,
        petID: String
    ) -> some View {

        let timer = timerManager.timer(for: petID)
        let canStart = timerManager.canStartTimer(for: petID)

        return HStack(spacing: 8) {

            timerButton(
                title: "Start",
                icon: "play.fill",
                isProminent: true
            ) {
                timerManager.start(
                    petID: petID,
                    petName: pet.name ?? "Unnamed",
                    breed: pet.breed ?? pet.species ?? ""
                )
            }
            .disabled(!canStart)

            timerButton(
                title: timer?.isPaused == true
                    ? "Resume"
                    : "Pause",
                icon: timer?.isPaused == true
                    ? "play.fill"
                    : "pause.fill",
                isProminent: false
            ) {
                if timer?.isPaused == true {
                    timerManager.resume(petID: petID)
                } else {
                    timerManager.pause(petID: petID)
                }
            }
            .disabled(timer == nil)

            timerButton(
                title: "Stop",
                icon: "stop.fill",
                isProminent: false
            ) {
                timerManager.stop(petID: petID)
            }
            .disabled(timer == nil)

            Spacer(minLength: 0)

            if timerManager.timers.count >=
                PetTimeActivityManager.maximumConcurrentActivities,
               timer == nil {

                Text("3 active")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Timer Button

    private func timerButton(
        title: String,
        icon: String,
        isProminent: Bool,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.caption.weight(.bold))
            .foregroundStyle(
                isProminent
                ? Color.appOnBrand
                : Color.appTextPrimary
            )
            .padding(.horizontal, 12)
            .frame(height: 36)
            .background(
                isProminent
                ? Color.appBrand
                : Color.appSurface
            )
            .clipShape(Capsule())
            .overlay {
                if !isProminent {
                    Capsule()
                        .stroke(
                            Color.appBorder,
                            lineWidth: 1
                        )
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        MyAnimals()
            .environmentObject(
                PetStore(
                    context:
                        PersistenceController
                            .shared
                            .container
                            .viewContext
                )
            )
    }
}
