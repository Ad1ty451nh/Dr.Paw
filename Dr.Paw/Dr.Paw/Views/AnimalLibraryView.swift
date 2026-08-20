//
//  AnimalLibraryView.swift
//  Dr.Paw
//  Created by Adityasinh on 06/07/26.
//
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
                Color(hex: "#F7F4F8")
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
                    .frame(height: 110)
                    .frame(maxWidth: .infinity)
                    .clipped()

                categoryBadge
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(animal.name)
                    .font(.subheadline.weight(.semibold))
                Text(animal.species)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    @ViewBuilder
    private var cardImage: some View {
        if UIImage(named: animal.imageName) != nil {
            Image(animal.imageName)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Color(hex: "#6D4093").opacity(0.15)
                Image(systemName: iconForCategory(animal.category))
                    .font(.system(size: 30))
                    .foregroundStyle(Color(hex: "#6D4093"))
            }
        }
    }

    private var categoryBadge: some View {
        Circle()
            .fill(Color(hex: "#F79E1B"))
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
        .background(Color(hex: "#F7F4F8"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "#F7F4F8"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(animal.name)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: "#3B2450"))

            HStack(spacing: 8) {
                Image(systemName: iconForCategory(animal.category))
                Text(animal.category.displayName)
                Text("•")
                Text(animal.species)
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(Color(hex: "#6D4093"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var heroImage: some View {
        ZStack(alignment: .bottomLeading) {
            if UIImage(named: animal.imageName) != nil {
                Image(animal.imageName)
                    .resizable()
                    .scaledToFill()
            } else {
                LinearGradient(
                    colors: [Color(hex: "#6D4093"), Color(hex: "#F79E1B")],
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
        .shadow(color: Color(hex: "#3B2450").opacity(0.18), radius: 14, x: 0, y: 8)
    }

    private var careDetails: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Everyday care")
                .font(.title3.weight(.bold))
                .foregroundStyle(Color(hex: "#3B2450"))

            DetailRow(title: "Best environment", detail: animal.idealEnvironment, icon: "house.fill", tint: Color(hex: "#6D4093"))
            DetailRow(title: "Best food", detail: animal.bestFood, icon: "leaf.fill", tint: Color(hex: "#3E8A5B"))
            DetailRow(title: "Foods to avoid", detail: animal.foodToAvoid, icon: "exclamationmark.triangle.fill", tint: Color(hex: "#CE5A57"))
        }
    }

    private var tipCard: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: "lightbulb.fill")
                .font(.title3)
                .foregroundStyle(Color(hex: "#A56800"))
                .frame(width: 36, height: 36)
                .background(Color(hex: "#FDE8B8"), in: Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text("Dr. Paw's tip")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color(hex: "#754A00"))
                Text(animal.specificTip)
                    .font(.subheadline)
                    .foregroundStyle(Color(hex: "#5B4A2C"))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color(hex: "#FFF7DE"))
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
                .foregroundStyle(tint)
                .frame(width: 36, height: 36)
                .background(tint.opacity(0.13), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color(hex: "#3B2450"))
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 7, x: 0, y: 3)
    }
}

#Preview {
    AnimalLibraryView()
}
