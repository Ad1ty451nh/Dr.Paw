//
//  Animal.swift
//  Dr.Paw
//
//  Created by Adityasinh on 15/07/26.
//

import Foundation
 
enum AnimalCategory: String, Codable, CaseIterable {
    case dog
    case cat
    case bird
    case farmAnimal
    case rodent
    case reptile
 
    var displayName: String {
        switch self {
        case .dog: return "Dogs"
        case .cat: return "Cats"
        case .bird: return "Birds"
        case .farmAnimal: return "Farm Animals"
        case .rodent: return "Rodents"
        case .reptile: return "Reptiles"
        }
    }
}
 
struct Animal: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let species: String
    let category: AnimalCategory
    let imageName: String
 
    let idealEnvironment: String
    let bestFood: String
    let foodToAvoid: String
    let specificTip: String
 
    init(
        id: UUID = UUID(),
        name: String,
        species: String,
        category: AnimalCategory,
        imageName: String,
        idealEnvironment: String,
        bestFood: String,
        foodToAvoid: String,
        specificTip: String
    ) {
        self.id = id
        self.name = name
        self.species = species
        self.category = category
        self.imageName = imageName
        self.idealEnvironment = idealEnvironment
        self.bestFood = bestFood
        self.foodToAvoid = foodToAvoid
        self.specificTip = specificTip
    }
}
 
