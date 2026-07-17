//
//  ProfileScreenView.swift
//  Dr.Paw
//
//  Saved animal profiles, scan history, and app settings.
//

//
//  ProfileView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//
import SwiftUI

struct ProfileScreenView: View {

    @Environment(\.dismiss) var dismiss

    // Replace with real user data once Supabase auth is wired in
    @State private var userName: String = "Kavya Nair"
    @State private var userEmail: String = "kavya.nair98@gmail.com"
    @State private var profileImage: Image = Image(systemName: "person.crop.circle.fill")

    @State private var showShareSheet = false

    var body: some View {

        ScrollView {

            VStack(spacing: 0) {

                // Top header block
                ZStack {

                    Color(hex: "#F9E7C8")

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

                            Button {
                                // TODO: hook up photo picker
                            } label: {
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

                            Text(userName)
                                .font(.system(size: 22, weight: .bold))

                            Text(userEmail)
                                .font(.subheadline)
                                .foregroundStyle(.gray)

                        }
                        .padding(.bottom, 24)

                    }

                }
                .clipShape(
                    RoundedCorner(radius: 32, corners: [.bottomLeft, .bottomRight])
                )

                // Sections list
                VStack(spacing: 0) {

                    ProfileRow(
                        icon: "pawprint.fill",
                        title: "My Animals",
                        destination: AnyView(Text("My Animals"))
                    )

                    ProfileRow(
                        icon: "camera.viewfinder",
                        title: "Scan History",
                        destination: AnyView(Text("Scan History"))
                    )

                    ProfileRow(
                        icon: "bell.fill",
                        title: "Reminders",
                        destination: AnyView(Text("Reminders"))
                    )

                    ProfileRow(
                        icon: "internaldrive.fill",
                        title: "Storage",
                        destination: AnyView(Text("Storage"))
                    )

                    ProfileRow(
                        icon: "info.circle.fill",
                        title: "About",
                        destination: AnyView(Text("About")),
                        showDivider: false
                    )

                }
                .padding(.top, 24)

            }

        }
        .background(Color.white)
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showShareSheet) {
            // TODO: swap in a real branded share card per-animal later
            ActivityShareSheet(items: ["Check out Dr. Paws! 🐾"])
        }

    }
}

// MARK: - Reusable row component

struct ProfileRow: View {

    let icon: String
    let title: String
    let destination: AnyView
    var showDivider: Bool = true

    var body: some View {

        NavigationLink(destination: destination) {

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

//#Preview {
//    ProfileScreenView()
//        .environmentObject(UserSession())
//}
