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
    @State private var selectedPhoto: PhotosPickerItem?

    @State private var showShareSheet = false

    var body: some View {

        NavigationStack {

        ScrollView {

            VStack(spacing: 0) {

                // Top header block
                VStack(spacing: 16) {

                        // Nav bar
                        HStack {

                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                            }

                            Spacer()

                            Text("Profile")
                                .font(.system(size: 24, weight: .bold))

                            Spacer()

                            Button {
                                showShareSheet = true
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                    .foregroundStyle(.black)
                            }

                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Profile photo
                        ZStack(alignment: .bottomTrailing) {

                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color(hex: "#F79E1B"), lineWidth: 3)
                                )

                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Image(systemName: "pencil")
                                    .font(.footnote)
                                    .foregroundStyle(Color(hex: "#6D4093"))
                                    .padding(10)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            }

                        }

                        // Name + email
                        VStack(spacing: 4) {

                            Text(session.nickname.isEmpty ? "Pet Parent" : session.nickname)
                                .font(.system(size: 22, weight: .bold))

                            Text(session.email.isEmpty ? "" : session.email)
                                .font(.subheadline)
                                .foregroundStyle(.gray)

                        }
                        .padding(.bottom, 24)

                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#F9E7C8"))
                .clipShape(
                    RoundedCorner(radius: 32, corners: [.bottomLeft, .bottomRight])
                )

                // Sections list
                VStack(spacing: 0) {

                    // NOTE: swap MyAnimalsView / ScanHistoryView / RemindersView / StorageView / AboutView
                    // below for your actual file/struct names if they differ
                    ProfileRow(icon: "pawprint.fill", title: "My Animals") {
                        MyAnimals()
                    }

                    ProfileRow(icon: "camera.viewfinder", title: "Scan History") {
                        ScanHistory()
                    }

                    ProfileRow(icon: "bell.fill", title: "Reminders") {
                        Remainders()
                    }

                    ProfileRow(icon: "internaldrive.fill", title: "Storage") {
                        Storage()
                    }

                    ProfileRow(icon: "info.circle.fill", title: "About", showDivider: false) {
                        About()
                    }

                }
                .padding(.top, 24)
                .padding(.bottom, 110)

            }

        }
        .background(Color.white)
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showShareSheet) {
            // TODO: swap in a real branded share card per-animal later
            ActivityShareSheet(items: ["Check out Dr. Paws! 🐾"])
        }
        .onChange(of: selectedPhoto) { newPhoto in
            guard let newPhoto else { return }
            Task {
                if let data = try? await newPhoto.loadTransferable(type: Data.self) {
                    session.profileImageData = data
                }
            }
        }

        }

    }

    private var profileImage: Image {
        if let image = UIImage(data: session.profileImageData), !session.profileImageData.isEmpty {
            return Image(uiImage: image)
        }
        return Image(systemName: "person.crop.circle.fill")
    }
}

// MARK: - Reusable row component

struct ProfileRow<Destination: View>: View {

    let icon: String
    let title: String
    var showDivider: Bool = true
    @ViewBuilder let destination: () -> Destination

    var body: some View {

        NavigationLink(destination: destination()) {

            VStack(spacing: 0) {

                HStack(spacing: 16) {

                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#6D4093").opacity(0.85))
                            .frame(width: 48, height: 48)

                        Image(systemName: icon)
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                    }

                    Text(title)
                        .font(.system(size: 18))
                        .foregroundStyle(.black)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color(hex: "#6D4093"))
                        .font(.system(size: 16, weight: .semibold))

                }
                .padding(.horizontal)
                .padding(.vertical, 14)

                if showDivider {
                    Divider()
                        .padding(.leading, 80)
                }

            }

        }
        .buttonStyle(.plain)

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
    }
}
