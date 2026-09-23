//
//  PetStore.swift
//  Dr.Paw
//
//  Created by Adityasinh on 10/09/26.
//

import CoreData
import SwiftUI
import Combine

@MainActor
final class PetStore: ObservableObject {

    @Published var pets: [Pet] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchPets()
    }

    // The pet every other feature screen (weight, medical, food/walk) should read from
    var selectedPet: Pet? {
        pets.first { $0.isSelected }
    }

    func fetchPets() {
        let request = Pet.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Pet.dateAdded, ascending: true)]

        do {
            pets = try context.fetch(request)

            // If nothing is marked selected yet (e.g. first pet ever added), default to the first pet
            if selectedPet == nil, let firstPet = pets.first {
                select(firstPet)
            }
            WidgetSharedStore.sync(from: pets)
        } catch {
            print("Failed to fetch pets: \(error)")
        }
    }

    func addPet(name: String, species: String, breed: String?, photoData: Data?) {
        let pet = Pet(context: context)
        pet.id = UUID()
        pet.name = name
        pet.species = species
        pet.breed = breed
        pet.photoData = photoData
        pet.dateAdded = Date()
        pet.isSelected = pets.isEmpty // first pet added becomes selected automatically

        save()
        fetchPets()
    }

    func select(_ pet: Pet) {
        for existingPet in pets {
            existingPet.isSelected = (existingPet.id == pet.id)
        }
        save()
        fetchPets()
    }

    func delete(_ pet: Pet) {
        let wasSelected = pet.isSelected
        if let id = pet.id?.uuidString {
            NotificationManager.shared.cancelFixedDailyRoutine(petID: id)
        }
        context.delete(pet)
        save()
        fetchPets()

        // If we deleted the active pet, fall back to whichever pet is now first
        if wasSelected, let firstPet = pets.first {
            select(firstPet)
        }
    }

    func deleteAllData() {
        let entityNames = ["WeightEntry", "HeightEntry", "Pet"]
        for entityName in entityNames {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            request.resultType = .resultTypeObjectIDs
            do {
                if let result = try context.execute(request) as? NSBatchDeleteResult,
                   let objectIDs = result.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
                        into: [context]
                    )
                }
            } catch {
                print("Failed to delete \(entityName): \(error)")
            }
        }
        fetchPets()
    }
    
    func updatePet(_ pet: Pet, name: String, species: String, breed: String?, photoData: Data?) {
        pet.name = name
        pet.species = species
        pet.breed = breed
        if let photoData {
            pet.photoData = photoData
        }
        save()
        fetchPets()
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save pet: \(error)")
        }
    }
}
