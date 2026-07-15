//
//  AnimalLibraryView.swift
//  Dr.Paw
//
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
        ScrollView {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(animals) { animal in
                            AnimalCardView(animal: animal)
                        }
                    }
                    .padding(16)
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

#Preview {
    AnimalLibraryView()
}
