//
//  AnimalLibraryView.swift
//  Dr.Paw
//  Created by Adityasinh on 06/07/26.
//
//  UI PASS: restyled to the new neutral appBackground/appSurface/appBrand
//  palette (see ColorExtension.swift) instead of the old hardcoded hex
//  colors. Grid layout, navigation, and detail screen structure unchanged.
//

import SwiftUI

struct AnimalLibraryView: View {
    
    private let animals = AnimalData.all
    
    private let columns = [
        GridItem(.flexible(),spacing: 14),
        GridItem(.flexible(),spacing: 14)
    ]
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(animals) { animal in
                            NavigationLink(value: animal) {
                                AnimalCardView(animal: animal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 92)
                }
            }
            
            .navigationTitle("Animal Library")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Animal.self) { animal in
                AnimalDetailView(animal: animal)
            }
        }
    }
}

struct AnimalCardView: View {
    let animal: Animal

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                cardImage
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 110)
                    .frame(width:180)
                    .clipped()
                    .shadow(radius: 5)

                categoryBadge
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(animal.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.appTextPrimary)
                Text(animal.species)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        .frame(maxWidth:180)
    }

    @ViewBuilder
    private var cardImage: some View {
        if UIImage(named: animal.imageName) != nil {
            Image(animal.imageName)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Color.appBrand.opacity(0.15)
                Image(systemName: iconForCategory(animal.category))
                    .font(.system(size: 30))
                    .foregroundStyle(Color.appBrand)
            }
        }
    }

    private var categoryBadge: some View {
        Circle()
            .fill(Color.appAccent)
            .frame(width: 26, height: 26)
            .overlay(
                Image(systemName: iconForCategory(animal.category))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
            )
            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
    }
}

private func iconForCategory(_ category: AnimalCategory) -> String {
    switch category {
    case .dog: return "dog.fill"
    case .cat: return "cat.fill"
    case .bird: return "bird.fill"
    case .rodent: return "hare.fill"
    case .reptile: return "tortoise.fill"
    case .farmAnimal: return "pawprint.fill" // no dedicated cow/horse symbol exists
    }
}

struct AnimalDetailView: View {
    let animal: Animal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                heroImage
                careDetails
                tipCard
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 110)
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.appBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(animal.name)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appTextPrimary)

            HStack(spacing: 8) {
                Image(systemName: iconForCategory(animal.category))
                Text(animal.category.displayName)
                Text("•")
                Text(animal.species)
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(Color.appAccent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
        // MARK:- Detail view image
    private var heroImage: some View {
        ZStack(alignment: .bottomLeading) {
            if UIImage(named: animal.imageName) != nil {
                Image(animal.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 370)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 27, style: .continuous)
                            .stroke(
                                Color.black.opacity(0.5),
                                lineWidth: 2.5
                            )
                            .shadow(color: .black, radius: 3)
                    )
            } else {
                LinearGradient(
                    colors: [Color.appBrand, Color.appAccent],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Image(systemName: iconForCategory(animal.category))
                    .font(.system(size: 72, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }

            LinearGradient(
                colors: [.clear, .black.opacity(0.42)],
                startPoint: .center,
                endPoint: .bottom
            )

            Label("Care guide", systemImage: "heart.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.black.opacity(0.22), in: Capsule())
                .padding(16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 270)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color.appBrand.opacity(0.18), radius: 14, x: 0, y: 8)
    }

    private var careDetails: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Everyday care")
                .font(.title3.weight(.bold))
                .foregroundStyle(Color.appTextPrimary)

            DetailRow(title: "Best environment", detail: animal.idealEnvironment, icon: "house.fill", tint: .blue)
            DetailRow(title: "Best food", detail: animal.bestFood, icon: "leaf.fill", tint: .green)
            DetailRow(title: "Foods to avoid", detail: animal.foodToAvoid, icon: "exclamationmark.triangle.fill", tint: .orange)
        }
    }

    private var tipCard: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: "lightbulb.fill")
                .font(.title3)
                .foregroundStyle(.yellow)
                .frame(width: 36, height: 36)
                .background(Color.yellow.opacity(0.18), in: Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text("Dr. Paw's tip")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                Text(animal.specificTip)
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.yellow.opacity(0.14), Color.appSurface],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct DetailRow: View {
    let title: String
    let detail: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(tint, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.appTextPrimary)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 7, x: 0, y: 3)
    }
}

#Preview {
    AnimalLibraryView()
}
