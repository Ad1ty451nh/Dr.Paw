//
//  WeightHeightStore.swift
//  Dr.Paw
//
//  Created by Adityasinh on 11/09/26.
//

import Combine
import CoreData
import SwiftUI

@MainActor
final class WeightHeightStore: ObservableObject {

    @Published var weightEntries: [WeightEntry] = []
    @Published var heightEntries: [HeightEntry] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchEntries(for pet: Pet) {
        let weightRequest = WeightEntry.fetchRequest()
        weightRequest.predicate = NSPredicate(format: "pet == %@", pet)
        weightRequest.sortDescriptors = [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: true)]

        let heightRequest = HeightEntry.fetchRequest()
        heightRequest.predicate = NSPredicate(format: "pet == %@", pet)
        heightRequest.sortDescriptors = [NSSortDescriptor(keyPath: \HeightEntry.date, ascending: true)]

        do {
            weightEntries = try context.fetch(weightRequest)
            heightEntries = try context.fetch(heightRequest)
        } catch {
            print("Failed to fetch weight/height entries: \(error)")
        }
    }

    func addWeightEntry(kg: Double, for pet: Pet) {
        let entry = WeightEntry(context: context)
        entry.id = UUID()
        entry.date = Date()
        entry.valueKg = kg
        entry.pet = pet
        save()
        fetchEntries(for: pet)
    }

    func addHeightEntry(cm: Double, for pet: Pet) {
        let entry = HeightEntry(context: context)
        entry.id = UUID()
        entry.date = Date()
        entry.valueCm = cm
        entry.pet = pet
        save()
        fetchEntries(for: pet)
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save entry: \(error)")
        }
    }
}
