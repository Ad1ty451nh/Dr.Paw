//
//  DrPawWidgetLiveActivity.swift
//  DrPawWidget
//

import ActivityKit
import SwiftUI
import WidgetKit
import AppIntents

struct DrPawWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PetTimeAttributes.self) { context in
            HStack(spacing: 12) {
                Image(systemName: "pawprint.fill")
                    .font(.title2)
                    .foregroundStyle(Color(hex: "#6D4093"))

                VStack(alignment: .leading, spacing: 4) {
                    Text(context.attributes.petName)
                        .font(.headline)
                        .foregroundStyle(Color(hex: "#3A264B"))

                    Text(context.state.isPaused ? "Pet time paused" : "30 min together")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    timerLabel(for: context)

                    activityControls(for: context)
                }
            }
            .padding()
            .activityBackgroundTint(Color(hex: "#F9E7C8"))
            .activitySystemActionForegroundColor(Color(hex: "#6D4093"))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "pawprint.fill")
                        .foregroundStyle(Color(hex: "#6D4093"))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    timerLabel(for: context)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(context.attributes.petName)
                            .font(.headline)
                        Text(context.state.isPaused ? "Paused — resume when ready" : "Pet time in progress")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack {
                            timerLabel(for: context)
                            Spacer()
                            activityControls(for: context)
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: "pawprint.fill")
                    .foregroundStyle(Color(hex: "#6D4093"))
            } compactTrailing: {
                timerLabel(for: context)
                    .font(.caption2)
            } minimal: {
                Image(systemName: "pawprint.fill")
            }
            .keylineTint(Color(hex: "#F79E1B"))
        }
    }

    @ViewBuilder
    private func timerLabel(for context: ActivityViewContext<PetTimeAttributes>) -> some View {
        if context.state.isPaused {
            Text(formattedTime(context.state.pausedRemaining))
                .monospacedDigit()
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
        } else {
            Text(context.state.endDate, style: .timer)
                .monospacedDigit()
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
        }
    }

    @ViewBuilder
    private func activityControls(for context: ActivityViewContext<PetTimeAttributes>) -> some View {
        HStack(spacing: 12) {
            if context.state.isPaused {
                Button(intent: ResumePetTimeIntent(activityID: context.activityID)) {
                    Label("Resume", systemImage: "play.fill")
                }
            } else {
                Button(intent: PausePetTimeIntent(activityID: context.activityID)) {
                    Label("Pause", systemImage: "pause.fill")
                }
            }

            Button(intent: StopPetTimeIntent(activityID: context.activityID)) {
                Label("Stop", systemImage: "stop.fill")
            }
            .tint(Color(hex: "#B95349"))
        }
        .font(.caption.weight(.semibold))
        .buttonStyle(.bordered)
    }

    private func formattedTime(_ interval: TimeInterval) -> String {
        let seconds = max(Int(interval.rounded()), 0)
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }
}
