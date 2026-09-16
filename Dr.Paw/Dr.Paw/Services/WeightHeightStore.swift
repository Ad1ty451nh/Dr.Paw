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

    func exportGrowthCSV(pets: [Pet]) -> String {
        let formatter = ISO8601DateFormatter()
        var lines = ["pet,type,date,value,unit"]

        for pet in pets {
            fetchEntries(for: pet)
            let name = (pet.name ?? "Unnamed").replacingOccurrences(of: ",", with: " ")

            for entry in weightEntries {
                let date = entry.date.map { formatter.string(from: $0) } ?? ""
                lines.append("\(name),weight,\(date),\(entry.valueKg),kg")
            }

            for entry in heightEntries {
                let date = entry.date.map { formatter.string(from: $0) } ?? ""
                lines.append("\(name),height,\(date),\(entry.valueCm),cm")
            }
        }

        return lines.joined(separator: "\n")
    }

    func measurementCounts() -> (weights: Int, heights: Int) {
        let weights = (try? context.count(for: WeightEntry.fetchRequest())) ?? 0
        let heights = (try? context.count(for: HeightEntry.fetchRequest())) ?? 0
        return (weights, heights)
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save entry: \(error)")
        }
    }
}
