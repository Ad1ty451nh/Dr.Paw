//
//  MeasurementUnits.swift
//  Dr.Paw
//
//  Created by Adityasinh on 11/09/26.
//

import Foundation

enum HeightUnit: String, CaseIterable, Identifiable {
    case cm = "cm"
    case inch = "in"
    case feet = "ft"

    var id: String { rawValue }

    // Convert a value already in this unit → canonical cm for storage
    // For .feet, `value` is feet and `secondaryValue` is the leftover inches
    func toCm(value: Double, secondaryValue: Double = 0) -> Double {
        switch self {
        case .cm:
            return value
        case .inch:
            return value * 2.54
        case .feet:
            let totalInches = (value * 12) + secondaryValue
            return totalInches * 2.54
        }
    }

    // Convert a canonical cm value → this unit, for display when editing/viewing
    // Returns (primary, secondary) — secondary is only meaningful for .feet
    func fromCm(_ cm: Double) -> (primary: Double, secondary: Double) {
        switch self {
        case .cm:
            return (cm, 0)
        case .inch:
            return (cm / 2.54, 0)
        case .feet:
            let totalInches = cm / 2.54
            let feet = (totalInches / 12).rounded(.down)
            let remainingInches = totalInches - (feet * 12)
            return (feet, remainingInches)
        }
    }
}

enum WeightUnit: String, CaseIterable, Identifiable {
    case kg = "kg"
    case lb = "lb"

    var id: String { rawValue }

    func toKg(_ value: Double) -> Double {
        self == .kg ? value : value * 0.453592
    }

    func fromKg(_ kg: Double) -> Double {
        self == .kg ? kg : kg / 0.453592
    }
}
