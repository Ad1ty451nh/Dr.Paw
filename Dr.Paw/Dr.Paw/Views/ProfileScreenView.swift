//
//  ProfileView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//
import SwiftUI
import PhotosUI

struct ProfileScreenView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var session: UserSession
    @EnvironmentObject private var petStore: PetStore

    @State private var selectedPhoto: PhotosPickerItem?

    // MARK: - Theme (change these to recolor the whole Profile screen)

    // SCREEN BACKGROUND: page fill behind the scroll content
    private let screenBackground = Color(hex: "#ECE9E7")
    // CARD BACKGROUND: stats, collection, pet rows, and more sections
    private let cardBackground = Color.white
    // TITLE TEXT: "Profile", pet parent name, row titles
    private let titleColor = Color(hex: "#3A264B")
    // SUBTITLE TEXT: email, section captions, counts
    private let subtitleColor = Color.gray
    // ACCENT: icons, chevrons, section labels
    private let accentColor = Color(hex: "#6D4093")
    // HIGHLIGHT: avatar ring, selected-pet heart, stat numbers
    private let highlightColor = Color(hex: "#F79E1B")
    // AVATAR PLACEHOLDER: circle behind the default person icon
    private let avatarPlaceholder = Color(hex: "#6D4093").opacity(0.15)
    // ICON TINT ON CARDS: small leading glyphs in collection / more rows
    private let iconTint = Color(hex: "#6D4093")

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    identity
                    statsCard
                    collectionSection
                    petsSection
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
        HStack{
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
            Text("Profile")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(titleColor)
                .padding(.top, 4)

            Spacer()

            Color.clear.frame(width: 44, height: 44)
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
                    .overlay(
                        Circle()
                            // AVATAR RING: outline around the profile photo
                            .stroke(highlightColor, lineWidth: 3)
                    )
                    .shadow(color: accentColor.opacity(0.18), radius: 12, y: 6)

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Image(systemName: "pencil")
                        .font(.footnote.weight(.semibold))
                        // EDIT BADGE ICON
                        .foregroundStyle(accentColor)
                        .padding(8)
                        // EDIT BADGE BACKGROUND
                        .background(cardBackground)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
            }

            VStack(spacing: 4) {
                Text(session.nickname.isEmpty ? "Pet Parent" : session.nickname)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(titleColor)

                Text(session.email.isEmpty ? "Your pet care companion" : session.email)
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
            statCell(icon: "pawprint.fill", value: "\(petStore.pets.count)", label: "Pets")
            Divider().frame(height: 44)
            statCell(icon: "bell.fill", value: "—", label: "Reminders")
            Divider().frame(height: 44)
            statCell(icon: "camera.viewfinder", value: "—", label: "Scans")
        }
        .padding(.vertical, 16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func statCell(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                // STAT ICON
                .foregroundStyle(iconTint)

            Text(value)
                .font(.system(size: 20, weight: .bold))
                // STAT NUMBER
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
            sectionLabel("YOUR CARE", systemImage: "folder.fill")

            VStack(spacing: 0) {
                ProfileCollectionRow(
                    icon: "pawprint.fill",
                    title: "My Animals",
                    count: petStore.pets.count,
                    showDivider: true,
                    accentColor: iconTint,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    cardBackground: cardBackground
                ) {
                    MyAnimals()
                }

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

                ProfileCollectionRow(
                    icon: "bell.fill",
                    title: "Reminders",
                    count: nil,
                    showDivider: false,
                    accentColor: iconTint,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    cardBackground: cardBackground
                ) {
                    Remainders()
                }
            }
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    // MARK: - Pets (favorites-style cards)

    private var petsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel("YOUR PETS", systemImage: "heart.fill")

            if petStore.pets.isEmpty {
                Text("Add a pet from Pets List to see them here.")
                    .font(.subheadline)
                    .foregroundStyle(subtitleColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18)
                    .background(cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            } else {
                VStack(spacing: 12) {
                    ForEach(petStore.pets, id: \.objectID) { pet in
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
            if let photoData = pet.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(avatarPlaceholder)
                        .frame(width: 52, height: 52)

                    Image(systemName: "pawprint.fill")
                        // PET PLACEHOLDER ICON
                        .foregroundStyle(accentColor)
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(pet.name ?? "Unnamed")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(titleColor)

                Text([pet.species, pet.breed].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " · "))
                    .font(.caption)
                    .foregroundStyle(subtitleColor)
            }

            Spacer()

            if pet.isSelected {
                Image(systemName: "heart.fill")
                    // SELECTED PET HEART
                    .foregroundStyle(highlightColor)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                // PET CARD CHEVRON
                .foregroundStyle(accentColor.opacity(0.7))
        }
        .padding(12)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func sectionLabel(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.system(size: 12, weight: .semibold))
            .tracking(0.6)
            // SECTION HEADER: "YOUR CARE" / "YOUR PETS" / "MORE"
            .foregroundStyle(accentColor)
            .padding(.leading, 4)
    }

    private var profileImage: Image {
        if let image = UIImage(data: session.profileImageData), !session.profileImageData.isEmpty {
            return Image(uiImage: image)
        }
        return Image(systemName: "person.crop.circle.fill")
    }
}

// MARK: - Collection row (NavigationLink)

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

// MARK: - Helper: rounded corners on specific sides only

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Helper: native share sheet wrapper

struct ActivityShareSheet: UIViewControllerRepresentable {

    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}

}

#Preview {
    NavigationStack {
        ProfileScreenView()
            .environmentObject(UserSession())
            .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
    }
}
