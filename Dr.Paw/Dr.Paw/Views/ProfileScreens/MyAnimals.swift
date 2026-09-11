//
//  MyAnimals.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//

import SwiftUI

struct MyAnimals: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#F9E7C8"), Color(hex: "#ECE9E7")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(width: 44, height: 44)
                            .liquidGlass(in: Circle())
                    }

                    Spacer()

                    Text("My Animals")
                        .font(.system(size: 22, weight: .bold))

                    Spacer()

                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                if petStore.pets.isEmpty {
                    Spacer()
                    VStack(spacing: 14) {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 42))
                            .foregroundStyle(Color(hex: "#6D4093"))

                        Text("No pets added yet")
                            .font(.headline)

                        Text("Add a pet from Pets List, then come back to see them here.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(petStore.pets, id: \.objectID) { pet in
                                NavigationLink {
                                    PetDetailsView(pet: pet)
                                } label: {
                                    animalRow(pet)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func animalRow(_ pet: Pet) -> some View {
        HStack(spacing: 14) {
            if let photoData = pet.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#6D4093").opacity(0.15))
                        .frame(width: 52, height: 52)

                    Image(systemName: "pawprint.fill")
                        .foregroundStyle(Color(hex: "#6D4093"))
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(pet.name ?? "Unnamed")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)

                Text([pet.species, pet.breed].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    NavigationStack {
        MyAnimals()
            .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
    }
}
