//
//  DrPawWidget.swift
//  DrPawWidget
//
//  Created by Adityasinh on 24/08/26.
//

import WidgetKit
import SwiftUI


// MARK: - Timeline Provider

struct Provider: AppIntentTimelineProvider {

    private func selectedAnimal(for configuration: ConfigurationAppIntent) -> Animal {
        AnimalData.all.first { animal in
            animal.name == configuration.animal.id
        } ?? AnimalData.all[0]
    }

    func placeholder(in context: Context) -> SimpleEntry {

        SimpleEntry(
            date: Date(),
            animal: AnimalData.all[0]
        )
    }


    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> SimpleEntry {

        return SimpleEntry(
            date: Date(),
            animal: selectedAnimal(for: configuration)
        )
    }

    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<SimpleEntry> {

        let entry = SimpleEntry(
            date: Date(),
            animal: selectedAnimal(for: configuration)
        )

        return Timeline(
            entries: [entry],
            policy: .after(entry.date.addingTimeInterval(1))
        )
    }
}


// MARK: - Timeline Entry

struct SimpleEntry: TimelineEntry {

    let date: Date
    let animal: Animal
}


// MARK: - Widget UI

struct DrPawWidgetEntryView: View {

    var entry: Provider.Entry

    var body: some View {

        VStack(alignment: .leading) {

            Text("🐾 Dr.Paw")
                .font(.headline)

            Text(entry.animal.name)
                .font(.title3)
                .bold()

            Text(entry.animal.species)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("💡 Tip")
                .font(.caption)
                .bold()

            Text(entry.animal.specificTip)
                .font(.caption)
                .lineLimit(4)
        }
        .padding()
    }
}

struct DrPawWidget: Widget {

    let kind: String = "DrPawWidget"

    var body: some WidgetConfiguration {

        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in

            DrPawWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}


// MARK: - Preview
#Preview(as: .systemSmall) {

    DrPawWidget()

} timeline: {

    SimpleEntry(
        date: .now,
        animal: AnimalData.all[0]
    )
}
