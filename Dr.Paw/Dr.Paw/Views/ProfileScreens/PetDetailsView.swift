//
//  PetDetailsView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 11/09/26.
//

import Charts
import SwiftUI

struct PetDetailsView: View {
    let pet: Pet

    @Environment(\.dismiss) var dismiss

    @FetchRequest private var weightEntries: FetchedResults<WeightEntry>
    @FetchRequest private var heightEntries: FetchedResults<HeightEntry>

    init(pet: Pet) {
        self.pet = pet
        _weightEntries = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: true)],
            predicate: NSPredicate(format: "pet == %@", pet),
            animation: .default
        )
        _heightEntries = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \HeightEntry.date, ascending: true)],
            predicate: NSPredicate(format: "pet == %@", pet),
            animation: .default
        )
    }

    private var latestWeightKg: Double? {
        weightEntries.last?.valueKg
    }

    private var latestHeightCm: Double? {
        heightEntries.last?.valueCm
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#F9E7C8"), Color(hex: "#ECE9E7")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(width: 44, height: 44)
                            .liquidGlass(in: Circle())
                    }

                    Spacer()

                    Text("Pet Details")
                        .font(.system(size: 22, weight: .bold))

                    Spacer()

                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                ScrollView {
                    VStack(spacing: 20) {
                        profileCard
                        weightChartCard
                        heightChartCard
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var profileCard: some View {
        VStack(spacing: 16) {
            if let photoData = pet.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(hex: "#F79E1B"), lineWidth: 3))
            } else {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#6D4093").opacity(0.15))
                        .frame(width: 110, height: 110)

                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color(hex: "#6D4093"))
                }
            }

            Text(pet.name ?? "Unnamed")
                .font(.system(size: 24, weight: .bold))

            VStack(spacing: 4) {
                if let species = pet.species, !species.isEmpty {
                    Text(species)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                Text(pet.breed?.isEmpty == false ? (pet.breed ?? "") : "Breed not set")
                    .font(.system(size: 16, weight: .medium))
            }

            HStack(spacing: 20) {
                statBlock(
                    title: "Weight",
                    value: latestWeightKg.map { String(format: "%.1f kg", $0) } ?? "—"
                )
                statBlock(
                    title: "Height",
                    value: latestHeightCm.map { String(format: "%.1f cm", $0) } ?? "—"
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .liquidGlass(in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func statBlock(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
                .tracking(0.5)

            Text(value)
                .font(.system(size: 18, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var weightChartCard: some View {
        chartCard(
            title: "Weight track",
            unit: "kg",
            points: weightEntries.compactMap { entry in
                guard let date = entry.date else { return nil }
                return MeasurementPoint(id: entry.id ?? UUID(), date: date, value: entry.valueKg)
            },
            lineColor: Color(hex: "#6D4093")
        )
    }

    private var heightChartCard: some View {
        chartCard(
            title: "Height track",
            unit: "cm",
            points: heightEntries.compactMap { entry in
                guard let date = entry.date else { return nil }
                return MeasurementPoint(id: entry.id ?? UUID(), date: date, value: entry.valueCm)
            },
            lineColor: Color(hex: "#F79E1B")
        )
    }

    private func chartCard(title: String, unit: String, points: [MeasurementPoint], lineColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title.uppercased())
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
                .tracking(0.5)

            if points.isEmpty {
                Text("No records yet")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, minHeight: 160)
            } else {
                Chart(points) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value(unit, point.value)
                    )
                    .foregroundStyle(lineColor)
                    .interpolationMethod(.catmullRom)
                }
                .chartYAxisLabel(unit)
                .frame(height: 180)
            }
        }
        .padding(18)
        .liquidGlass(in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct MeasurementPoint: Identifiable {
    let id: UUID
    let date: Date
    let value: Double
}
