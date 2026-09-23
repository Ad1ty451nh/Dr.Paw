//
//  PetsListView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 08/09/26.
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
                background

                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    if petStore.pets.isEmpty {
                        Spacer()
                        emptyState
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 14) {
                                ForEach(petStore.pets) { pet in
                                    PetRowCard(pet: pet, isSelected: pet.isSelected) {
                                        petStore.select(pet)
                                    } onEdit: {
                                        petBeingEdited = pet
                                    } onDelete: {
                                        petStore.delete(pet)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 40)
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

    // MARK: - Background

    private var background: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.appAccent.opacity(0.18))
                .frame(width: 240, height: 240)
                .blur(radius: 35)
                .offset(x: 140, y: -300)

            Circle()
                .fill(Color.appBrand.opacity(0.12))
                .frame(width: 220, height: 220)
                .blur(radius: 35)
                .offset(x: -140, y: 380)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.appSurface)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
            }

            Spacer()

            Text("Pets List")
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)

            Spacer()

            Button {
                showAddPetSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appOnBrand)
                    .frame(width: 40, height: 40)
                    .background(Color.appBrand)
                    .clipShape(Circle())
                    .shadow(color: Color.appBrand.opacity(0.3), radius: 8, y: 4)
            }
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 42))
                .foregroundStyle(Color.appAccent)

            Text("No pets added yet")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)

            Text("Tap + to add your first pet.")
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
        }
        .padding(.vertical, 38)
        .padding(.horizontal, 30)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 40)
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
                            .overlay(
                                Circle().stroke(Color.appBorder, lineWidth: 1)
                            )
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color.appAccent.opacity(0.16))
                                .frame(width: 52, height: 52)

                            Image(systemName: "pawprint.fill")
                                .foregroundStyle(Color.appAccent)
                        }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(pet.name ?? "Unnamed")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color.appTextPrimary)

                        Text([pet.species, pet.breed].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " · "))
                            .font(.subheadline)
                            .foregroundStyle(Color.appTextSecondary)
                    }

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.appAccent)
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
                    .foregroundStyle(Color.appTextSecondary)
                    .frame(width: 30, height: 30)
            }

        }
        .padding(14)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(isSelected ? Color.appAccent : Color.appBorder.opacity(0.5), lineWidth: isSelected ? 2 : 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

#Preview {
    PetsListView()
        .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
}
