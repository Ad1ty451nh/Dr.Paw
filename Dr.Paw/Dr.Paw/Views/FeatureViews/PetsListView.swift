//
//  PetsListView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 08/09/26.
//
//
//  PetsListView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 10/09/26.
//
import SwiftUI
import CoreData


struct PetsListView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore

    @State private var showAddPetSheet = false
    @State private var petBeingEdited: Pet?

    var body: some View {
        NavigationStack {
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

                        Text("Pets List")
                            .font(.system(size: 22, weight: .bold))

                        Spacer()

                        Button {
                            showAddPetSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.black)
                                .frame(width: 44, height: 44)
                                .liquidGlass(in: Circle())
                        }
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

                            Text("Tap + to add your first pet.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }

                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 14) {
                                ForEach(petStore.pets) { pet in
                                    PetRowCard(pet: pet, isSelected: pet.isSelected) {
                                        petStore.select(pet)
                                    }onEdit: {
                                        petBeingEdited = pet
                                    }
                                    onDelete: {
                                        petStore.delete(pet)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                }

            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showAddPetSheet) {
                PetFormView()
            }
            .sheet(item: $petBeingEdited) { pet in
                PetFormView(existingPet: pet)
            }
        }
    }
}

// MARK: - Pet row card

private struct PetRowCard: View {

    let pet: Pet
    let isSelected: Bool
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {

        HStack(spacing: 14) {

            Button(action: onSelect) {
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

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color(hex: "#F79E1B"))
                            .font(.title3)
                    }

                }
            }
            .buttonStyle(.plain)

            Menu {
                Button {
                    onEdit()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }

                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.gray)
                    .frame(width: 30, height: 30)
            }

        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isSelected ? Color(hex: "#F79E1B") : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    PetsListView()
        .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
}
