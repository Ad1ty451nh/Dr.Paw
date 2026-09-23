//
//  ProfileView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//

import SwiftUI
import PhotosUI

struct ProfileScreenView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var session: UserSession
    @EnvironmentObject private var petStore: PetStore
    
    @State private var selectedPhoto: PhotosPickerItem?
    
    // MARK: - Theme
    
    private let screenBackground = Color.appBackground
    private let cardBackground = Color.appSurface
    private let titleColor = Color.appTextPrimary
    private let subtitleColor = Color.appTextSecondary
    private let accentColor = Color.appAccent
    private let highlightColor = Color.appBrand
    private let avatarPlaceholder = Color.appAccent.opacity(0.15)
    private let iconTint = Color.appAccent
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    identity
                    statsCard
                    collectionSection
                    petsSection
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 28)
            }
            .background(screenBackground.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .onChange(of: selectedPhoto) { _, newPhoto in
                guard let newPhoto else { return }
                
                Task {
                    if let data = try? await newPhoto.loadTransferable(type: Data.self) {
                        session.profileImageData = data
                    }
                }
            }
        }
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(titleColor)
                    .frame(width: 44, height: 44)
                    .background(cardBackground)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.appBorder, lineWidth: 1)
                    }
            }
            
            Spacer()
            
            Text("Profile")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(titleColor)
                .padding(.top, 4)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    // MARK: - Identity
    
    private var identity: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 108, height: 108)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(highlightColor, lineWidth: 3)
                    }
                    .shadow(
                        color: accentColor.opacity(0.18),
                        radius: 12,
                        y: 6
                    )
                
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Image(systemName: "pencil")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(accentColor)
                        .padding(8)
                        .background(cardBackground)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.appBorder, lineWidth: 1)
                        }
                        .shadow(
                            color: Color.appElevatedShadow,
                            radius: 4,
                            y: 2
                        )
                }
            }
            
            VStack(spacing: 4) {
                Text(
                    session.nickname.isEmpty
                    ? "Pet Parent"
                    : session.nickname
                )
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(titleColor)
                
                Text(
                    session.email.isEmpty
                    ? "Your pet care companion"
                    : session.email
                )
                .font(.subheadline)
                .foregroundStyle(subtitleColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }
    
    // MARK: - Stats
    
    private var statsCard: some View {
        HStack(spacing: 0) {
            statCell(
                icon: "pawprint.fill",
                value: "\(petStore.pets.count)",
                label: "Pets"
            )
            
            Divider()
                .frame(height: 44)
            
            statCell(
                icon: "bell.fill",
                value: "—",
                label: "Reminders"
            )
            
            Divider()
                .frame(height: 44)
            
            statCell(
                icon: "camera.viewfinder",
                value: "—",
                label: "Scans"
            )
        }
        .padding(.vertical, 16)
        .background(cardBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
            .stroke(Color.appBorder, lineWidth: 1)
        }
    }
    
    private func statCell(
        icon: String,
        value: String,
        label: String
    ) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(iconTint)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(highlightColor)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(subtitleColor)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Collection
    
    private var collectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel(
                "YOUR CARE",
                systemImage: "folder.fill"
            )
            
            VStack(spacing: 0) {
                ProfileCollectionRow(
                    icon: "camera.viewfinder",
                    title: "Scan History",
                    count: nil,
                    showDivider: true,
                    accentColor: iconTint,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    cardBackground: cardBackground
                ) {
                    ScanHistory()
                }
            }
            .background(cardBackground)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 22,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 22,
                    style: .continuous
                )
                .stroke(Color.appBorder, lineWidth: 1)
            }
        }
    }
    
    // MARK: - Pets
    
    private var petsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel(
                "YOUR PETS",
                systemImage: "heart.fill"
            )
            
            if petStore.pets.isEmpty {
                Text("Add a pet from Pets List to see them here.")
                    .font(.subheadline)
                    .foregroundStyle(subtitleColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18)
                    .background(cardBackground)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 22,
                            style: .continuous
                        )
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 22,
                            style: .continuous
                        )
                        .stroke(Color.appBorder, lineWidth: 1)
                    }
            } else {
                VStack(spacing: 12) {
                    ForEach(
                        petStore.pets,
                        id: \.objectID
                    ) { pet in
                        NavigationLink {
                            PetDetailsView(pet: pet)
                        } label: {
                            petCard(pet)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private func petCard(_ pet: Pet) -> some View {
        HStack(spacing: 14) {
            if let photoData = pet.photoData,
               let uiImage = UIImage(data: photoData) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                    )
            } else {
                ZStack {
                    RoundedRectangle(
                        cornerRadius: 12,
                        style: .continuous
                    )
                    .fill(avatarPlaceholder)
                    .frame(width: 52, height: 52)
                    
                    Image(systemName: "pawprint.fill")
                        .foregroundStyle(accentColor)
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(pet.name ?? "Unnamed")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(titleColor)
                
                Text(
                    [pet.species, pet.breed]
                        .compactMap { $0 }
                        .filter { !$0.isEmpty }
                        .joined(separator: " · ")
                )
                .font(.caption)
                .foregroundStyle(subtitleColor)
            }
            
            Spacer()
            
            if pet.isSelected {
                Image(systemName: "heart.fill")
                    .foregroundStyle(highlightColor)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(accentColor.opacity(0.7))
        }
        .padding(12)
        .background(cardBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .stroke(Color.appBorder, lineWidth: 1)
        }
    }
    
    // MARK: - Section Label
    
    private func sectionLabel(
        _ text: String,
        systemImage: String
    ) -> some View {
        Label(text, systemImage: systemImage)
            .font(.system(size: 12, weight: .semibold))
            .tracking(0.6)
            .foregroundStyle(accentColor)
            .padding(.leading, 4)
    }
    
    // MARK: - Profile Image
    
    private var profileImage: Image {
        if let image = UIImage(
            data: session.profileImageData
        ),
           !session.profileImageData.isEmpty {
            return Image(uiImage: image)
        }
        
        return Image(systemName: "person.crop.circle.fill")
    }
    
    // MARK: - About
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel(
                "ABOUT",
                systemImage: "info.circle.fill"
            )
            
            VStack(spacing: 0) {
                ProfileSettingsRow(
                    icon: "info.circle.fill",
                    title: "About Dr. Paws",
                    showDivider: false,
                    accentColor: iconTint,
                    titleColor: titleColor
                ) {
                    About()
                }
            }
            .background(cardBackground)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 22,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 22,
                    style: .continuous
                )
                .stroke(Color.appBorder, lineWidth: 1)
            }
        }
    }
}

// MARK: - Collection Row

private struct ProfileCollectionRow<Destination: View>: View {
    
    let icon: String
    let title: String
    let count: Int?
    var showDivider: Bool
    
    let accentColor: Color
    let titleColor: Color
    let subtitleColor: Color
    let cardBackground: Color
    
    @ViewBuilder let destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination()) {
            ProfileCollectionRowLabel(
                icon: icon,
                title: title,
                count: count,
                showDivider: showDivider,
                accentColor: accentColor,
                titleColor: titleColor,
                subtitleColor: subtitleColor
            )
        }
        .buttonStyle(.plain)
    }
}

private struct ProfileCollectionRowLabel: View {
    
    let icon: String
    let title: String
    let count: Int?
    var showDivider: Bool
    
    let accentColor: Color
    let titleColor: Color
    let subtitleColor: Color
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(accentColor)
                    .frame(width: 28)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(titleColor)
                
                Spacer()
                
                if let count {
                    Text("\(count)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(subtitleColor)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(accentColor.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            if showDivider {
                Divider()
                    .padding(.leading, 58)
            }
        }
    }
}

// MARK: - About / Settings Row

private struct ProfileSettingsRow<Destination: View>: View {
    
    let icon: String
    let title: String
    var showDivider: Bool
    
    let accentColor: Color
    let titleColor: Color
    
    @ViewBuilder let destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination()) {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(accentColor)
                        .frame(width: 28)
                    
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(titleColor)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(accentColor.opacity(0.7))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                
                if showDivider {
                    Divider()
                        .padding(.leading, 58)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Helper: Rounded Corners

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        
        return Path(path.cgPath)
    }
}

// MARK: - Helper: Native Share Sheet

struct ActivityShareSheet: UIViewControllerRepresentable {
    
    let items: [Any]
    
    func makeUIViewController(
        context: Context
    ) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
    }
    
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}

#Preview {
    NavigationStack {
        ProfileScreenView()
            .environmentObject(UserSession())
            .environmentObject(
                PetStore(
                    context: PersistenceController.shared.container.viewContext
                )
            )
    }
}
