//
//  PetFormView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 11/09/26.
//

import PhotosUI
import SwiftUI
import CoreData

struct PetFormView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore

    let existingPet: Pet?

    @State private var name: String
    @State private var species: String
    @State private var breed: String
    @State private var isCustomBreed: Bool
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var photoData: Data?

    init(existingPet: Pet? = nil) {
        self.existingPet = existingPet
        _name = State(initialValue: existingPet?.name ?? "")
        _species = State(initialValue: existingPet?.species ?? Self.speciesOptions.first!)
        _breed = State(initialValue: existingPet?.breed ?? "")
        _isCustomBreed = State(initialValue: existingPet?.breed != nil && !(Self.breedOptions(for: existingPet?.species ?? "").contains(existingPet?.breed ?? "")))
        _photoData = State(initialValue: existingPet?.photoData)
    }

    // MARK: - Picker data

    static let speciesOptions = ["Dog", "Cat", "Bird", "Farm Animal", "Rodent", "Reptile", "Other"]

    static func breedOptions(for species: String) -> [String] {
        switch species {
        case "Dog":
            return ["Labrador", "Pug", "Golden Retriever", "German Shepherd", "Rottweiler", "Beagle", "Poodle", "Boxer", "Dachshund"]
        case "Cat":
            return ["Persian White", "British Shorthair", "Ragdoll", "Maine Coon", "Siamese", "Bengal", "Sphynx", "Scottish Fold", "Himalayan"]
        case "Bird":
            return ["Pigeon", "Parrot", "Sparrow", "Cockatiel", "Budgerigar", "Owl", "Peacock", "Crow", "Duck"]
        case "Farm Animal":
            return ["Cow", "Buffalo", "Horse", "Goat", "Sheep", "Pig", "Donkey"]
        case "Rodent":
            return ["Hamster", "Rabbit", "Guinea Pig", "Mouse", "Rat", "Chinchilla", "Gerbil", "Squirrel"]
        case "Reptile":
            return ["Turtle", "Tortoise", "Gecko", "Iguana", "Corn Snake", "Bearded Dragon", "Chameleon", "Monitor Lizard"]
        default:
            return []
        }
    }

    private static func icon(for species: String) -> String {
        switch species {
        case "Dog": return "dog.fill"
        case "Cat": return "cat.fill"
        case "Bird": return "bird.fill"
        case "Farm Animal": return "pawprint.fill"
        case "Rodent": return "hare.fill"
        case "Reptile": return "tortoise.fill"
        default: return "questionmark.circle.fill"
        }
    }

    private var breedList: [String] {
        Self.breedOptions(for: species)
    }

    private var isSaveDisabled: Bool {
        name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            photoSection
                            nameSection
                            speciesSection
                            breedSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
            .onChange(of: species) { _, _ in
                breed = ""
                isCustomBreed = Self.breedOptions(for: species).isEmpty
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.appTextSecondary)

            Spacer()

            Text(existingPet == nil ? "Add Pet" : "Edit Pet")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)

            Spacer()

            Button("Save") {
                if let existingPet {
                    petStore.updatePet(existingPet, name: name, species: species, breed: breed, photoData: photoData)
                } else {
                    petStore.addPet(name: name, species: species, breed: breed, photoData: photoData)
                }
                dismiss()
            }
            .font(.subheadline.weight(.bold))
            .foregroundStyle(isSaveDisabled ? Color.appTextSecondary.opacity(0.5) : Color.appBrand)
            .disabled(isSaveDisabled)
        }
        .frame(height: 40)
    }

    // MARK: - Photo

    private var photoSection: some View {
        VStack(spacing: 12) {
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                ZStack {
                    if let photoData, let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 92, height: 92)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.appAccent.opacity(0.16))
                            .frame(width: 92, height: 92)
                            .overlay {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundStyle(Color.appAccent)
                            }
                    }

                    Circle()
                        .stroke(Color.appBorder, lineWidth: 1)
                        .frame(width: 92, height: 92)

                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.appOnBrand, Color.appBrand)
                        .background(Circle().fill(Color.appSurface))
                        .offset(x: 32, y: 32)
                }
            }
            .buttonStyle(.plain)

            Text("Add a photo")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }

    // MARK: - Name

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("NAME")

            TextField("Pet's name", text: $name)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appTextPrimary)
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.appBorder.opacity(0.6), lineWidth: 1)
                )
        }
    }

    // MARK: - Species

    private var speciesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("SPECIES")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Self.speciesOptions, id: \.self) { option in
                        speciesChip(option)
                    }
                }
            }
        }
    }

    private func speciesChip(_ option: String) -> some View {
        let isSelected = species == option

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                species = option
            }
        } label: {
            HStack(spacing: 7) {
                Image(systemName: Self.icon(for: option))
                Text(option)
            }
            .font(.caption.weight(.bold))
            .foregroundStyle(isSelected ? Color.appOnBrand : Color.appTextPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? Color.appBrand : Color.appSurface)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.appBorder.opacity(isSelected ? 0 : 0.6), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Breed

    private var breedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("BREED")

            if !breedList.isEmpty {
                Menu {
                    ForEach(breedList, id: \.self) { option in
                        Button {
                            isCustomBreed = false
                            breed = option
                        } label: {
                            if breed == option && !isCustomBreed {
                                Label(option, systemImage: "checkmark")
                            } else {
                                Text(option)
                            }
                        }
                    }

                    Button {
                        isCustomBreed = true
                        breed = ""
                    } label: {
                        Text("Other")
                    }
                } label: {
                    HStack {
                        Text(isCustomBreed ? "Other" : (breed.isEmpty ? "Select breed" : breed))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(breed.isEmpty && !isCustomBreed ? Color.appTextSecondary : Color.appTextPrimary)

                        Spacer()

                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 50)
                    .background(Color.appSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.appBorder.opacity(0.6), lineWidth: 1)
                    )
                }
            }

            if isCustomBreed {
                TextField("Enter breed", text: $breed)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.appTextPrimary)
                    .padding(.horizontal, 16)
                    .frame(height: 50)
                    .background(Color.appSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.appBorder.opacity(0.6), lineWidth: 1)
                    )
            }
        }
    }

    // MARK: - Shared

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.bold))
            .tracking(1.2)
            .foregroundStyle(Color.appAccent)
    }
}

#Preview {
    PetFormView()
        .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
}
