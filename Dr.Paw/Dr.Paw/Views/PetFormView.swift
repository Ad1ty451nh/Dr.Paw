//
//  PetFormView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 11/09/26.
//

import PhotosUI
import SwiftUI

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

    static let speciesOptions = ["Dog", "Cat", "Bird", "Rabbit", "Other"]

    static func breedOptions(for species: String) -> [String] {
        switch species {
        case "Dog":
            return ["Labrador Retriever", "Golden Retriever", "German Shepherd", "Poodle", "Bulldog", "Beagle", "Rottweiler", "Dachshund", "Boxer", "Shih Tzu"]
        case "Cat":
            return ["Persian", "Siamese", "Maine Coon", "British Shorthair", "Sphynx", "Bengal", "Ragdoll", "Scottish Fold"]
        default:
            return []
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        HStack {
                            if let photoData, let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#6D4093").opacity(0.15))
                                        .frame(width: 60, height: 60)

                                    Image(systemName: "camera.fill")
                                        .foregroundStyle(Color(hex: "#6D4093"))
                                }
                            }

                            Text("Add photo")
                                .foregroundStyle(Color(hex: "#6D4093"))
                        }
                    }
                    .onChange(of: selectedPhotoItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                photoData = data
                            }
                        }
                    }
                }

                Section("Pet details") {
                    TextField("Name", text: $name)

                    Picker("Species", selection: $species) {
                        ForEach(Self.speciesOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .onChange(of: species) { _, _ in
                        breed = ""
                        isCustomBreed = Self.breedOptions(for: species).isEmpty
                    }
                }

                Section("Breed") {
                    let breedList = Self.breedOptions(for: species)

                    if !breedList.isEmpty {
                        Picker("Breed", selection: Binding(
                            get: { isCustomBreed ? "Other" : breed },
                            set: { newValue in
                                if newValue == "Other" {
                                    isCustomBreed = true
                                    breed = ""
                                } else {
                                    isCustomBreed = false
                                    breed = newValue
                                }
                            }
                        )) {
                            ForEach(breedList, id: \.self) { option in
                                Text(option)
                            }
                            Text("Other").tag("Other")
                        }
                        .pickerStyle(.navigationLink)
                    }

                    if isCustomBreed {
                        TextField("Enter breed", text: $breed)
                    }
                }
            }
            .navigationTitle(existingPet == nil ? "Add Pet" : "Edit Pet")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let existingPet {
                            petStore.updatePet(existingPet, name: name, species: species, breed: breed, photoData: photoData)
                        } else {
                            petStore.addPet(name: name, species: species, breed: breed, photoData: photoData)
                            // breed gets set on the freshly added pet via a follow-up update,
                            // since addPet doesn't take breed — see note below
                        }
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    PetFormView()
}
