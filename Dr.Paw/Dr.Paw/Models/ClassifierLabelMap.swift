//
//  ClassifierLabelMap.swift
//  Dr.Paw
//
//  Created by Adityasinh on 23/09/26.
//

import Foundation

// Maps raw classifier output → the exact `name` used in AnimalData.all
enum ClassifierLabelMap {
    static let toAnimalName: [String: String] = [
        // Dog
        "GermanShepherd": "German Shepherd",
        "Labrador": "Labrador",
        "Rottweiler": "Rottweiler",
        "golden_retriever": "Golden Retriever",
        "pug": "Pug",
        // Cat
        "British Shorthair": "British Shorthair",
        "Persian": "Persian White",
        // Ragdoll, MaineCoon intentionally omitted — not in AnimalData.all yet
        // Bird
        "House Sparrow": "Sparrow",
        "parrot": "Parrot",
        "pigeon": "Pigeon",
        // FarmAnimal
        "buffalo": "Buffalo",
        "cow": "Cow",
        "horse": "Horse",
        // Rodent
        "hamster": "Hamster",
        "rabbit": "Rabbit",
        // Reptile
        "Turtle": "Turtle"
    ]

    static func lookup(_ rawLabel: String) -> Animal? {
        guard let animalName = toAnimalName[rawLabel] else { return nil }
        return AnimalData.all.first { $0.name == animalName }
    }
}
