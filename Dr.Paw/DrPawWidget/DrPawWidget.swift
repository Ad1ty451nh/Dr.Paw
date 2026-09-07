//
//  DrPawWidget.swift
//  DrPawWidget
//
//  Created by Adityasinh on 24/08/26.
//

import WidgetKit
import SwiftUI


// MARK: - Timeline Provider

// The Provider is responsible for supplying data to the widget.
// It decides WHAT data the widget should display and WHEN it should refresh.
struct Provider: AppIntentTimelineProvider {

    /// Resolves the current picker value every time WidgetKit asks for a
    /// preview or a timeline. This is what keeps the widget face in sync
    /// while the user is editing its configuration.
    private func selectedAnimal(for configuration: ConfigurationAppIntent) -> Animal {
        AnimalData.all.first { animal in
            animal.name == configuration.animal.id
        } ?? AnimalData.all[0]
    }

    // Used when iOS needs a temporary/placeholder version of the widget.
    // We use the first animal from our static AnimalData as sample content.
    func placeholder(in context: Context) -> SimpleEntry {

        SimpleEntry(
            date: Date(),
            animal: AnimalData.all[0]
        )
    }

    // Used when iOS requests a quick snapshot of the widget.
    // This is commonly used while displaying previews or the widget gallery.
    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> SimpleEntry {

        return SimpleEntry(
            date: Date(),
            animal: selectedAnimal(for: configuration)
        )
    }

    // The timeline tells WidgetKit what data to display.
    // iOS calls this method when it needs a new timeline.
    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<SimpleEntry> {

        // Create the timeline entry using the selected animal.
        let entry = SimpleEntry(
            date: Date(),
            animal: selectedAnimal(for: configuration)
        )

        // Do not keep this value forever. A `.never` policy leaves the
        // previously rendered animal on the widget face until something
        // explicitly reloads the timeline. Using `.atEnd` lets WidgetKit
        // request a fresh entry after the edit is applied.
        return Timeline(
            entries: [entry],
            policy: .after(entry.date.addingTimeInterval(1))
        )
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}


// MARK: - Timeline Entry

// A TimelineEntry represents the data for ONE particular state of our widget.
//
// Currently our widget needs two pieces of information:
// 1. date   → when this entry represents
// 2. animal → the animal information we want to display
struct SimpleEntry: TimelineEntry {

    let date: Date
    let animal: Animal
}


// MARK: - Widget UI

// This SwiftUI View is responsible for drawing the actual widget.
//
// The Provider gives us a SimpleEntry,
// and this View decides how that data should look on screen.
struct DrPawWidgetEntryView: View {

    var entry: Provider.Entry

    var body: some View {

        VStack(alignment: .leading) {

            Text("🐾 Dr.Paw")
                .font(.headline)

            // This comes from the animal selected in the picker.
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


// MARK: - Widget Configuration

// This tells WidgetKit that DrPawWidget is an actual widget
// and connects our configuration, Provider, and UI together.
struct DrPawWidget: Widget {

    // A unique identifier for this widget.
    let kind: String = "DrPawWidget"

    var body: some WidgetConfiguration {

        // AppIntentConfiguration connects:
        //
        // ConfigurationAppIntent
        //          ↓
        //       Provider
        //          ↓
        //    DrPawWidgetEntryView
        //
        // The user configuration is passed into the Provider,
        // allowing us to determine which animal to display.
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

// This preview lets us see the widget directly inside Xcode
// without installing it on the Home Screen.
#Preview(as: .systemSmall) {

    DrPawWidget()

} timeline: {

    SimpleEntry(
        date: .now,
        animal: AnimalData.all[0]
    )
}
