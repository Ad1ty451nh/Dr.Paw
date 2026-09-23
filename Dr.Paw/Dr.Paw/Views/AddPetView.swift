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
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    header
                    
                    photoPicker
                    
                    petDetails
                    
                    saveButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - UI Components

private extension AddPetView {
    
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.appSurface)
                    .clipShape(Circle())
                    .shadow(
                        color: Color.appElevatedShadow,
                        radius: 8,
                        x: 0,
                        y: 3
                    )
            }
            
            Spacer()
            
            Text("Add Pet")
                .font(.system(
                    size: 22,
                    weight: .bold,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
    
    var photoPicker: some View {
        PhotosPicker(
            selection: $selectedPhotoItem,
            matching: .images
        ) {
            VStack(spacing: 14) {
                if let photoData,
                   let uiImage = UIImage(data: photoData) {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 125, height: 125)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(
                                    Color.appBrand,
                                    lineWidth: 4
                                )
                        }
                        .shadow(
                            color: Color.appElevatedShadow,
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.appBlush)
                            .frame(width: 125, height: 125)
                        
                        VStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(Color.appBrand)
                            
                            Text("Add Photo")
                                .font(.system(
                                    size: 14,
                                    weight: .bold,
                                    design: .rounded
                                ))
                                .foregroundStyle(Color.appBrand)
                        }
                    }
                    .overlay {
                        Circle()
                            .stroke(
                                Color.appBorder,
                                style: StrokeStyle(
                                    lineWidth: 2,
                                    dash: [7]
                                )
                            )
                    }
                }
                
                Text(photoData == nil ? "Choose a photo of your pet" : "Change Photo")
                    .font(.system(
                        size: 14,
                        weight: .medium,
                        design: .rounded
                    ))
                    .foregroundStyle(Color.appTextSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.appBorder, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    photoData = data
                }
            }
        }
    }
    
    var petDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pet Details")
                .font(.system(
                    size: 20,
                    weight: .bold,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextPrimary)
            
            VStack(spacing: 12) {
                detailField(
                    icon: "pawprint.fill",
                    placeholder: "Pet Name",
                    text: $name
                )
                
                detailField(
                    icon: "textformat",
                    placeholder: "Species (e.g. Dog, Cat)",
                    text: $species
                )
                
                detailField(
                    icon: "tag.fill",
                    placeholder: "Breed",
                    text: $breed
                )
            }
            .padding(16)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.appBorder, lineWidth: 1)
            }
        }
    }
    
    func detailField(
        icon: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appBrand)
                .frame(width: 24)
            
            TextField(placeholder, text: text)
                .font(.system(
                    size: 16,
                    weight: .medium,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextPrimary)
        }
        .padding(.horizontal, 15)
        .frame(height: 54)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    var saveButton: some View {
        Button {
            petStore.addPet(
                name: name,
                species: species,
                breed: breed,
                photoData: photoData
            )
            
            dismiss()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "checkmark")
                    .font(.system(size: 15, weight: .bold))
                
                Text("Save Pet")
                    .font(.system(
                        size: 17,
                        weight: .bold,
                        design: .rounded
                    ))
            }
            .foregroundStyle(Color.appOnBrand)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(
                name.trimmingCharacters(in: .whitespaces).isEmpty
                ? Color.appBorder
                : Color.appBrand
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(
                color: name.trimmingCharacters(in: .whitespaces).isEmpty
                ? .clear
                : Color.appElevatedShadow,
                radius: 10,
                x: 0,
                y: 5
            )
        }
        .disabled(
            name.trimmingCharacters(in: .whitespaces).isEmpty
        )
    }
}

// MARK: - Preview

#Preview {
    AddPetView()
        
}
