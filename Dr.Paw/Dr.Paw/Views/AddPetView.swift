//
//  AddPetView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 10/09/26.
//


import PhotosUI
import SwiftUI

struct AddPetView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore

    @State private var name = ""
    @State private var species = ""
    @State private var breed = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var photoData: Data?

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
                    TextField("Species (e.g. Dog, Cat)", text: $species)
                }
            }
            .navigationTitle("Add Pet")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        petStore.addPet(name: name, species: species,breed: breed,photoData: photoData)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddPetView()
}
