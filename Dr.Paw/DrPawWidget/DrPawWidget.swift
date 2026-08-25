//
//  DrPawWidget.swift
//  DrPawWidget
//
//  Created by Adityasinh on 24/08/26.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
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
        SimpleEntry(
            date: Date(),
            animal: AnimalData.all[0]
        )
    }
    
    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<SimpleEntry> {

        let animal = AnimalData.all[0]

        let entry = SimpleEntry(
            date: Date(),
            animal: animal
        )

        return Timeline(
            entries: [entry],
            policy: .never
        )
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let animal: Animal
}

struct DrPawWidgetEntryView: View {

    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {

            Text("🐾 Dr.Paw")
                .font(.headline)

            Text(entry.animal.name)
                .font(.title3)
                .bold()

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
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DrPawWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {

    DrPawWidget()

} timeline: {

    SimpleEntry(
        date: .now,
        animal: AnimalData.all[0]
    )
}
