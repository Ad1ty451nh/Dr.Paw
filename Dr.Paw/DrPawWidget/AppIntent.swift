//
//  AppIntent.swift
//  DrPawWidget
//
//  Created by Adityasinh on 24/08/26.
//

import WidgetKit
import AppIntents


// MARK: - Animal Entity

// AppEntity tells the system that an Animal can be selected
// and displayed as a meaningful item in the widget configuration.
struct AnimalEntity: AppEntity {

    // Every AppEntity needs a unique identifier.
    // We use the animal's name because the names in AnimalData are unique.
    let id: String

    // The name that will be displayed to the user.
    let name: String

    // Tells iOS how to describe this type of entity.
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Animal"
    }

    // Controls how an individual animal appears in the picker.
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)"
        )
    }

    // This is required by AppEntity.
    // It tells App Intents which query object should be used
    // to find and return AnimalEntity objects.
    static var defaultQuery = AnimalQuery()
}


// MARK: - Animal Query

// EntityQuery is responsible for providing the list of animals
// that the user can select from the widget configuration.
struct AnimalQuery: EntityQuery {

    // Returns specific animals when iOS asks for their IDs.
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

    // Returns all available animals.
    // This is what allows the picker to display our AnimalData catalog.
    func suggestedEntities() async throws -> [AnimalEntity] {

        AnimalData.all.map {
            AnimalEntity(
                id: $0.name,
                name: $0.name
            )
        }
    }

    // Provides the default animal when the widget is first created.
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

// This defines the configuration options available to the user
// when they edit the Dr.Paw widget.
struct ConfigurationAppIntent: WidgetConfigurationIntent {

    static var title: LocalizedStringResource {
        "Dr.Paw Widget"
    }

    static var description: IntentDescription {
        "Choose which animal information to display."
    }

    // The user selects an AnimalEntity from the dynamic picker.
    //
    // The selected entity is passed to the Provider,
    // which then finds the matching Animal from AnimalData.
    @Parameter(
        title: "Animal",
        default: AnimalEntity(
            id: "Labrador",
            name: "Labrador"
        )
    )
    var animal: AnimalEntity
}
