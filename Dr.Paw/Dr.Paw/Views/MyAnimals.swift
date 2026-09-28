//
//  MyAnimals.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//

import SwiftUI
import Charts

struct MyAnimals: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var petStore: PetStore

    var body: some View {

        ZStack {

            screenBackground

            VStack(spacing: 0) {

                header

                if petStore.pets.isEmpty {

                    emptyState

                } else {

                    ScrollView(showsIndicators: false) {

                        VStack(spacing: 16) {

                            activePetsHeader

                            ForEach(
                                petStore.pets,
                                id: \.objectID
                            ) { pet in

                                PetCompanionCard(
                                    pet: pet
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 110)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Background

    private var screenBackground: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.appAccent.opacity(0.14))
                .frame(width: 270, height: 270)
                .blur(radius: 45)
                .offset(x: 170, y: -350)

            Circle()
                .fill(Color.appBrand.opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: -170, y: 400)
        }
    }

    // MARK: - Header

    private var header: some View {

        HStack(spacing: 14) {
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text(" YOUR COMPANIONS")
                    .font(.caption.weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color.appAccent)
                
                Text("My Animals")
                    .font(
                        .system(
                            size: 28,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
            }
            
            
        }
    }

    // MARK: - Active Pets Header

    private var activePetsHeader: some View {

        HStack {

            VStack(alignment: .leading, spacing: 4) {

                Text("MY PETS")
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.appAccent)

                Text(
                    "\(petStore.pets.count) "
                    + (
                        petStore.pets.count == 1
                        ? "companion"
                        : "companions"
                    )
                )
                .font(
                    .system(
                        size: 17,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()

            Image(systemName: "heart.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 34, height: 34)
                .background(Color.appBlush)
                .clipShape(Circle())
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Empty State

    private var emptyState: some View {

        VStack(spacing: 18) {

            Spacer()

            ZStack {

                Circle()
                    .fill(Color.appBlush)
                    .frame(width: 100, height: 100)

                Image(systemName: "pawprint.fill")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(Color.appAccent)
            }

            VStack(spacing: 7) {

                Text("No pets added yet")
                    .font(
                        .system(
                            size: 22,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                Text(
                    "Add a pet from Pets List, then come back to see them here."
                )
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
                .padding(.horizontal, 28)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

// MARK: - Growth Point

private struct GrowthPoint: Identifiable {

    let id: UUID
    let date: Date
    let value: Double
}

// MARK: - Pet Companion Card

private struct PetCompanionCard: View {

    let pet: Pet

    @State private var isExpanded = false

    @FetchRequest private var weightEntries:
        FetchedResults<WeightEntry>

    @FetchRequest private var heightEntries:
        FetchedResults<HeightEntry>

    init(pet: Pet) {

        self.pet = pet

        _weightEntries = FetchRequest(
            sortDescriptors: [
                NSSortDescriptor(
                    keyPath: \WeightEntry.date,
                    ascending: true
                )
            ],
            predicate: NSPredicate(
                format: "pet == %@",
                pet
            ),
            animation: .default
        )

        _heightEntries = FetchRequest(
            sortDescriptors: [
                NSSortDescriptor(
                    keyPath: \HeightEntry.date,
                    ascending: true
                )
            ],
            predicate: NSPredicate(
                format: "pet == %@",
                pet
            ),
            animation: .default
        )
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            cardHeader

            if isExpanded {

                growthSection
                    .padding(.top, 14)
                    .transition(
                        .opacity.combined(
                            with: .move(edge: .top)
                        )
                    )
            }
        }
        .padding(15)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
        .overlay {

            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .stroke(
                Color.appBorder.opacity(0.45),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            y: 5
        )
    }

    // MARK: - Card Header

    private var cardHeader: some View {

        HStack(spacing: 14) {

            petImage

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text(pet.name ?? "Unnamed")
                    .font(
                        .system(
                            size: 19,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                let details = [
                    pet.species,
                    pet.breed
                ]
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .joined(separator: " · ")

                if !details.isEmpty {

                    Text(details)
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(1)
                }

                Button {

                    withAnimation(.easeInOut(duration: 0.25)) {
                        isExpanded.toggle()
                    }

                } label: {

                    HStack(spacing: 5) {

                        Image(
                            systemName:
                                isExpanded
                                ? "chevron.up"
                                : "chart.xyaxis.line"
                        )

                        Text(
                            isExpanded
                            ? "Hide growth graphs"
                            : "View growth graphs"
                        )
                    }
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.appAccent)
                }
                .buttonStyle(.plain)
            }

            Spacer()

            NavigationLink {

                PetDetailsView(pet: pet)

            } label: {

                Image(systemName: "chevron.right")
                    .font(
                        .system(
                            size: 13,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(Color.appTextSecondary)
                    .frame(width: 34, height: 34)
                    .background(Color.appBackground)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Growth Section

    private var growthSection: some View {

        VStack(spacing: 12) {

            miniChartCard(
                title: "Weight",
                unit: "kg",
                icon: "scalemass.fill",
                tint: Color.appBrand,
                points: weightEntries.compactMap { entry in

                    guard let date = entry.date else {
                        return nil
                    }

                    return GrowthPoint(
                        id: entry.id ?? UUID(),
                        date: date,
                        value: entry.valueKg
                    )
                }
            )

            miniChartCard(
                title: "Height",
                unit: "cm",
                icon: "arrow.up.and.down",
                tint: Color.appAccent,
                points: heightEntries.compactMap { entry in

                    guard let date = entry.date else {
                        return nil
                    }

                    return GrowthPoint(
                        id: entry.id ?? UUID(),
                        date: date,
                        value: entry.valueCm
                    )
                }
            )
        }
    }

    // MARK: - Mini Chart

    private func miniChartCard(
        title: String,
        unit: String,
        icon: String,
        tint: Color,
        points: [GrowthPoint]
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            HStack(spacing: 8) {

                Image(systemName: icon)
                    .font(
                        .system(
                            size: 13,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(tint)

                Text("\(title) progress")
                    .font(
                        .system(
                            size: 13,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                Spacer()

                if let latest = points.last?.value {

                    Text(
                        String(
                            format: "%.1f \(unit)",
                            latest
                        )
                    )
                    .font(
                        .system(
                            size: 13,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(tint)
                }
            }

            if points.isEmpty {

                Text(
                    "No \(title.lowercased()) records yet"
                )
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(.vertical, 18)

            } else {

                Chart(points) { point in

                    LineMark(
                        x: .value(
                            "Date",
                            point.date
                        ),
                        y: .value(
                            unit,
                            point.value
                        )
                    )
                    .foregroundStyle(tint)
                    .lineStyle(
                        StrokeStyle(
                            lineWidth: 2.5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .interpolationMethod(.catmullRom)

                    PointMark(
                        x: .value(
                            "Date",
                            point.date
                        ),
                        y: .value(
                            unit,
                            point.value
                        )
                    )
                    .foregroundStyle(tint)
                    .symbolSize(22)
                }
                .chartXAxis {

                    AxisMarks(
                        values: .automatic(
                            desiredCount: 3
                        )
                    ) { _ in

                        AxisGridLine()
                            .foregroundStyle(
                                Color.appBorder.opacity(0.5)
                            )

                        AxisValueLabel()
                            .foregroundStyle(
                                Color.appTextSecondary
                            )
                            .font(.caption2)
                    }
                }
                .chartYAxis {

                    AxisMarks { _ in

                        AxisGridLine()
                            .foregroundStyle(
                                Color.appBorder.opacity(0.5)
                            )

                        AxisValueLabel()
                            .foregroundStyle(
                                Color.appTextSecondary
                            )
                            .font(.caption2)
                    }
                }
                .frame(height: 110)
            }
        }
        .padding(12)
        .background(Color.appBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
        )
    }

    // MARK: - Pet Image

    @ViewBuilder
    private var petImage: some View {

        if let photoData = pet.photoData,
           let uiImage = UIImage(data: photoData) {

            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(
                    width: 68,
                    height: 68
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )

        } else {

            ZStack {

                LinearGradient(
                    colors: [
                        Color.appBrand,
                        Color.appAccent
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Image(systemName: "pawprint.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.appOnBrand)
            }
            .frame(
                width: 68,
                height: 68
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )
        }
    }
}

#Preview {

    NavigationStack {

        MyAnimals()
            .environmentObject(
                PetStore(
                    context:
                        PersistenceController
                            .shared
                            .container
                            .viewContext
                )
            )
    }
}
