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
    
    private var latestWeightKg: Double? {
        weightEntries.last?.valueKg
    }
    
    private var latestHeightCm: Double? {
        heightEntries.last?.valueCm
    }
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    profileCard
                    measurementSummary
                    weightChartCard
                    heightChartCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Header

private extension PetDetailsView {
    
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.appSurface)
                    .clipShape(Circle())
                    .shadow(
                        color: Color.appElevatedShadow,
                        radius: 8,
                        x: 0,
                        y: 3
                    )
            }
            
            Spacer()
            
            Text("Pet Details")
                .font(.system(
                    size: 22,
                    weight: .bold,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
}

// MARK: - Profile

private extension PetDetailsView {
    
    var profileCard: some View {
        VStack(spacing: 16) {
            petImage
            
            VStack(spacing: 5) {
                Text(pet.name ?? "Unnamed")
                    .font(.system(
                        size: 27,
                        weight: .bold,
                        design: .rounded
                    ))
                    .foregroundStyle(Color.appTextPrimary)
                
                if let species = pet.species,
                   !species.isEmpty {
                    Text(species)
                        .font(.system(
                            size: 15,
                            weight: .medium,
                            design: .rounded
                        ))
                        .foregroundStyle(Color.appTextSecondary)
                }
                
                Text(
                    pet.breed?.isEmpty == false
                    ? (pet.breed ?? "")
                    : "Breed not set"
                )
                .font(.system(
                    size: 14,
                    weight: .medium,
                    design: .rounded
                ))
                .foregroundStyle(Color.appBrand)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 18)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
            .stroke(Color.appBorder, lineWidth: 1)
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 12,
            x: 0,
            y: 6
        )
    }
    
    var petImage: some View {
        Group {
            if let photoData = pet.photoData,
               let uiImage = UIImage(data: photoData) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 125, height: 125)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(
                                Color.appAccent,
                                lineWidth: 4
                            )
                    }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.appBlush)
                        .frame(width: 125, height: 125)
                    
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 42, weight: .medium))
                        .foregroundStyle(Color.appBrand)
                }
                .overlay {
                    Circle()
                        .stroke(
                            Color.appBorder,
                            lineWidth: 2
                        )
                }
            }
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            x: 0,
            y: 5
        )
    }
}

// MARK: - Measurements

private extension PetDetailsView {
    
    var measurementSummary: some View {
        HStack(spacing: 12) {
            measurementCard(
                icon: "scalemass.fill",
                title: "Weight",
                value: latestWeightKg.map {
                    String(format: "%.1f kg", $0)
                } ?? "—"
            )
            
            measurementCard(
                icon: "arrow.up.and.down",
                title: "Height",
                value: latestHeightCm.map {
                    String(format: "%.1f cm", $0)
                } ?? "—"
            )
        }
    }
    
    func measurementCard(
        icon: String,
        title: String,
        value: String
    ) -> some View {
        VStack(spacing: 9) {
            ZStack {
                Circle()
                    .fill(Color.appBlush)
                    .frame(width: 42, height: 42)
                
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.appBrand)
            }
            
            Text(title)
                .font(.system(
                    size: 13,
                    weight: .medium,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextSecondary)
            
            Text(value)
                .font(.system(
                    size: 17,
                    weight: .bold,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 17)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .stroke(Color.appBorder, lineWidth: 1)
        }
    }
}

// MARK: - Charts

private extension PetDetailsView {
    
    var weightChartCard: some View {
        chartCard(
            title: "Weight Progress",
            subtitle: "Track your pet's weight over time",
            unit: "kg",
            points: weightEntries.compactMap { entry in
                guard let date = entry.date else {
                    return nil
                }
                
                return MeasurementPoint(
                    id: entry.id ?? UUID(),
                    date: date,
                    value: entry.valueKg
                )
            },
            lineColor: Color.appBrand,
            icon: "scalemass.fill"
        )
    }
    
    var heightChartCard: some View {
        chartCard(
            title: "Height Progress",
            subtitle: "Track your pet's height over time",
            unit: "cm",
            points: heightEntries.compactMap { entry in
                guard let date = entry.date else {
                    return nil
                }
                
                return MeasurementPoint(
                    id: entry.id ?? UUID(),
                    date: date,
                    value: entry.valueCm
                )
            },
            lineColor: Color.appAccent,
            icon: "arrow.up.and.down"
        )
    }
    
    func chartCard(
        title: String,
        subtitle: String,
        unit: String,
        points: [MeasurementPoint],
        lineColor: Color,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.appBlush)
                        .frame(width: 42, height: 42)
                    
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(lineColor)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(
                            size: 18,
                            weight: .bold,
                            design: .rounded
                        ))
                        .foregroundStyle(Color.appTextPrimary)
                    
                    Text(subtitle)
                        .font(.system(
                            size: 12,
                            weight: .medium,
                            design: .rounded
                        ))
                        .foregroundStyle(Color.appTextSecondary)
                }
                
                Spacer()
            }
            
            if points.isEmpty {
                emptyChartState
            } else {
                Chart(points) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value(unit, point.value)
                    )
                    .foregroundStyle(lineColor)
                    .lineStyle(
                        StrokeStyle(
                            lineWidth: 3,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Date", point.date),
                        y: .value(unit, point.value)
                    )
                    .foregroundStyle(lineColor)
                    .symbolSize(35)
                }
                .chartYAxisLabel(unit)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                            .foregroundStyle(
                                Color.appBorder.opacity(0.6)
                            )
                        
                        AxisValueLabel()
                            .foregroundStyle(
                                Color.appTextSecondary
                            )
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                            .foregroundStyle(
                                Color.appBorder.opacity(0.6)
                            )
                        
                        AxisValueLabel()
                            .foregroundStyle(
                                Color.appTextSecondary
                            )
                    }
                }
                .frame(height: 190)
            }
        }
        .padding(18)
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
            .stroke(Color.appBorder, lineWidth: 1)
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            x: 0,
            y: 5
        )
    }
    
    var emptyChartState: some View {
        VStack(spacing: 10) {
            Image(systemName: "chart.xyaxis.line")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(Color.appTextSecondary)
            
            Text("No records yet")
                .font(.system(
                    size: 14,
                    weight: .medium,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextSecondary)
            
            Text("Add measurements to see progress here.")
                .font(.system(
                    size: 12,
                    weight: .regular,
                    design: .rounded
                ))
                .foregroundStyle(Color.appTextSecondary.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
    }
}

// MARK: - Measurement Model

private struct MeasurementPoint: Identifiable {
    let id: UUID
    let date: Date
    let value: Double
}
