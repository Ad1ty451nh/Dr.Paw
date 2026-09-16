//
//  AppIntent.swift
//  DrPawWidget
//
//  Created by Adityasinh on 24/08/26.
//

import WidgetKit
import AppIntents


// MARK: - Animal Entity

struct AnimalEntity: AppEntity {

    let id: String

    let name: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Animal"
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)"
        )
    }

    static var defaultQuery = AnimalQuery()
}


// MARK: - Animal Query

struct AnimalQuery: EntityQuery {

    func entities(
        for identifiers: [AnimalEntity.ID]
    ) async throws -> [AnimalEntity] {

        AnimalData.all
            .filter { identifiers.contains($0.name) }
            .map {
                AnimalEntity(
                    id: $0.name,
                    name: $0.name
                )
            }
    }

    func suggestedEntities() async throws -> [AnimalEntity] {

        AnimalData.all.map {
            AnimalEntity(
                id: $0.name,
                name: $0.name
            )
        }
    }

    func defaultResult() async -> AnimalEntity? {

        guard let firstAnimal = AnimalData.all.first else {
            return nil
        }

        return AnimalEntity(
            id: firstAnimal.name,
            name: firstAnimal.name
        )
    }
}


// MARK: - Widget Configuration

struct ConfigurationAppIntent: WidgetConfigurationIntent {

    static var title: LocalizedStringResource {
        "Dr.Paw Widget"
    }

    static var description: IntentDescription {
        "Choose which animal information to display."
    }

    @Parameter(
        title: "Animal",
        default: AnimalEntity(
            id: "Labrador",
            name: "Labrador"
        )
    )
    var animal: AnimalEntity
}
