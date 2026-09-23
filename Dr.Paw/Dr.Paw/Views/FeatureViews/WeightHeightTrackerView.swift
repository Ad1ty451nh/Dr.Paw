//
//  WeightHeightTrackerView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 08/09/26.
//

import SwiftUI
import CoreData
import Combine

struct WeightHeightTrackerView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore
    @EnvironmentObject var weightHeightStore: WeightHeightStore

    @State private var showNeedPetAlert = false
    @State private var showAddPetSheet = false

    // Weight state
    @State private var weighWithOwner = false
    @State private var petAloneWeight = ""
    @State private var combinedWeight = ""
    @State private var ownerWeight = ""

    @State private var weightUnit: WeightUnit
    @State private var heightUnit: HeightUnit

    @State private var heightPrimary = ""
    @State private var heightInchesRemainder = ""

    init() {
        let weightRaw =
            UserDefaults.standard.string(forKey: "defaultWeightUnit")
            ?? WeightUnit.kg.rawValue

        let heightRaw =
            UserDefaults.standard.string(forKey: "defaultHeightUnit")
            ?? HeightUnit.cm.rawValue

        _weightUnit = State(
            initialValue: WeightUnit(rawValue: weightRaw) ?? .kg
        )

        _heightUnit = State(
            initialValue: HeightUnit(rawValue: heightRaw) ?? .cm
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                screenBackground

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {

                        header

                        petPickerCard

                        weightCard

                        heightCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 110)
                }
            }
            .navigationBarBackButtonHidden(true)

            .onAppear {
                promptForPetIfNeeded()
                fetchEntriesForSelectedPet()
            }

            .onChange(of: petStore.pets.count) { _, _ in
                promptForPetIfNeeded()
                fetchEntriesForSelectedPet()
            }

            .alert("Add a pet", isPresented: $showNeedPetAlert) {

                Button("Okay") {
                    showAddPetSheet = true
                }

            } message: {

                Text("First add the pet to add its height and weight")
            }

            .sheet(
                isPresented: $showAddPetSheet,
                onDismiss: fetchEntriesForSelectedPet
            ) {
                PetFormView()
                    .environmentObject(petStore)
            }
        }
    }

    // MARK: - Background

    private var screenBackground: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.appBrand.opacity(0.10))
                .frame(width: 260, height: 260)
                .blur(radius: 45)
                .offset(x: 170, y: -330)

            Circle()
                .fill(Color.appAccent.opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 45)
                .offset(x: -160, y: 420)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 14) {

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.appSurface)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.appBorder, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 3) {

                Text("PET HEALTH")
                    .font(.caption.weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color.appAccent)

                Text("Weight & Height")
                    .font(
                        .system(
                            size: 28,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()
        }
    }

    // MARK: - Pet Picker

    private var petPickerCard: some View {
        VStack(alignment: .leading, spacing: 13) {

            sectionLabel(
                title: "SELECT PET",
                icon: "pawprint.fill"
            )

            if petStore.pets.isEmpty {

                Button {
                    showNeedPetAlert = true
                } label: {

                    HStack(spacing: 14) {

                        iconContainer(
                            icon: "pawprint.fill",
                            color: Color.appAccent
                        )

                        VStack(alignment: .leading, spacing: 3) {

                            Text("Add a pet")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(Color.appTextPrimary)

                            Text("Choose a pet to track its growth")
                                .font(.caption)
                                .foregroundStyle(Color.appTextSecondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    .padding(14)
                }
                .buttonStyle(.plain)

            } else {

                Picker("Select pet", selection: selectedPetID) {

                    ForEach(petStore.pets, id: \.objectID) { pet in

                        Text(pet.name ?? "Unnamed")
                            .tag(pet.id ?? UUID())
                    }
                }
                .pickerStyle(.navigationLink)
                .tint(Color.appTextPrimary)
            }
        }
        .padding(18)
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
            .stroke(Color.appBorder.opacity(0.35), lineWidth: 1)
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            y: 5
        )
    }

    private var selectedPetID: Binding<UUID> {
        Binding(
            get: {
                petStore.selectedPet?.id
                    ?? petStore.pets.first?.id
                    ?? UUID()
            },

            set: { newValue in

                guard let pet = petStore.pets.first(
                    where: { $0.id == newValue }
                ) else {
                    return
                }

                petStore.select(pet)

                weightHeightStore.fetchEntries(for: pet)
            }
        )
    }

    private func promptForPetIfNeeded() {
        if petStore.pets.isEmpty {
            showNeedPetAlert = true
        }
    }

    private func fetchEntriesForSelectedPet() {
        if let pet = petStore.selectedPet {
            weightHeightStore.fetchEntries(for: pet)
        }
    }

    // MARK: - Weight Card

    private var weightCard: some View {
        VStack(alignment: .leading, spacing: 18) {

            sectionLabel(
                title: "WEIGHT",
                icon: "scalemass.fill"
            )

            measurementModePicker

            if weighWithOwner {

                labeledField(
                    label: "Combined weight",
                    text: $combinedWeight,
                    unit: weightUnit.rawValue
                )

                labeledField(
                    label: "Your weight",
                    text: $ownerWeight,
                    unit: weightUnit.rawValue
                )

                if let result = calculatedPetWeight {

                    calculatedResult(
                        title: "Pet weight",
                        value: String(
                            format: "%.1f",
                            result
                        ),
                        unit: weightUnit.rawValue
                    )
                }

            } else {

                labeledField(
                    label: "Pet weight",
                    text: $petAloneWeight,
                    unit: weightUnit.rawValue
                )
            }

            unitSectionTitle("WEIGHT UNIT")

            unitPicker(
                selection: $weightUnit,
                units: WeightUnit.allCases
            )

            primaryButton(
                title: "Save Weight",
                icon: "checkmark",
                action: saveWeight
            )
            .disabled(!canSaveWeight)
            .opacity(canSaveWeight ? 1 : 0.45)
        }
        .padding(18)
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
            .stroke(Color.appBorder.opacity(0.35), lineWidth: 1)
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            y: 5
        )
    }

    // MARK: - Weight Mode

    private var measurementModePicker: some View {
        HStack(spacing: 8) {

            modeButton(
                title: "Pet Alone",
                icon: "pawprint.fill",
                isSelected: !weighWithOwner
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    weighWithOwner = false
                }
            }

            modeButton(
                title: "With Owner",
                icon: "person.fill",
                isSelected: weighWithOwner
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    weighWithOwner = true
                }
            }
        }
    }

    private func modeButton(
        title: String,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {

            HStack(spacing: 7) {

                Image(systemName: icon)

                Text(title)
            }
            .font(.caption.weight(.bold))
            .foregroundStyle(
                isSelected
                ? Color.appOnBrand
                : Color.appTextSecondary
            )
            .frame(maxWidth: .infinity)
            .frame(height: 42)
            .background(
                isSelected
                ? Color.appBrand
                : Color.appBackground
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Height Card

    private var heightCard: some View {
        VStack(alignment: .leading, spacing: 18) {

            sectionLabel(
                title: "HEIGHT",
                icon: "ruler.fill"
            )

            unitSectionTitle("HEIGHT UNIT")

            unitPicker(
                selection: $heightUnit,
                units: HeightUnit.allCases
            )
            .onChange(of: heightUnit) { _, _ in
                heightPrimary = ""
                heightInchesRemainder = ""
            }

            if heightUnit == .feet {

                HStack(spacing: 12) {

                    labeledField(
                        label: "Feet",
                        text: $heightPrimary,
                        unit: "ft"
                    )

                    labeledField(
                        label: "Inches",
                        text: $heightInchesRemainder,
                        unit: "in"
                    )
                }

            } else {

                labeledField(
                    label: "Height",
                    text: $heightPrimary,
                    unit: heightUnit.rawValue
                )
            }

            primaryButton(
                title: "Save Height",
                icon: "checkmark",
                action: saveHeight
            )
            .disabled(!canSaveHeight)
            .opacity(canSaveHeight ? 1 : 0.45)
        }
        .padding(18)
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
            .stroke(Color.appBorder.opacity(0.35), lineWidth: 1)
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 10,
            y: 5
        )
    }

    // MARK: - Unit Picker

    private func unitPicker<Unit: Hashable & Identifiable>(
        selection: Binding<Unit>,
        units: [Unit]
    ) -> some View where Unit: RawRepresentable,
                         Unit.RawValue == String {

        HStack(spacing: 8) {

            ForEach(units) { unit in

                Button {

                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection.wrappedValue = unit
                    }

                } label: {

                    Text(unit.rawValue.uppercased())
                        .font(.caption.weight(.bold))
                        .foregroundStyle(
                            selection.wrappedValue == unit
                            ? Color.appOnBrand
                            : Color.appTextSecondary
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            selection.wrappedValue == unit
                            ? Color.appBrand
                            : Color.appBackground
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Shared Field

    private func labeledField(
        label: String,
        text: Binding<String>,
        unit: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 7) {

            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.appTextSecondary)

            HStack(spacing: 10) {

                TextField("0", text: text)
                    .keyboardType(.decimalPad)
                    .font(
                        .system(
                            size: 18,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)

                Text(unit)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.appAccent)
            }
            .padding(.horizontal, 15)
            .frame(height: 54)
            .background(Color.appBackground)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .stroke(
                    Color.appBorder.opacity(0.30),
                    lineWidth: 1
                )
            }
        }
    }

    // MARK: - Calculated Result

    private func calculatedResult(
        title: String,
        value: String,
        unit: String
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(Color.appAccent)

            VStack(alignment: .leading, spacing: 2) {

                Text(title.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(0.8)
                    .foregroundStyle(Color.appTextSecondary)

                Text("\(value) \(unit)")
                    .font(
                        .system(
                            size: 18,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(Color.appTextPrimary)
            }

            Spacer()
        }
        .padding(14)
        .background(Color.appBlush)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
        )
    }

    // MARK: - Section Label

    private func sectionLabel(
        title: String,
        icon: String
    ) -> some View {

        HStack(spacing: 8) {

            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.appAccent)

            Text(title)
                .font(.caption.weight(.bold))
                .tracking(1.3)
                .foregroundStyle(Color.appTextPrimary)
        }
    }

    // MARK: - Small Section Title

    private func unitSectionTitle(_ title: String) -> some View {

        Text(title)
            .font(.caption2.weight(.bold))
            .tracking(1.1)
            .foregroundStyle(Color.appTextSecondary)
    }

    // MARK: - Icon Container

    private func iconContainer(
        icon: String,
        color: Color
    ) -> some View {

        Image(systemName: icon)
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Color.appOnBrand)
            .frame(width: 42, height: 42)
            .background(color)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 13,
                    style: .continuous
                )
            )
    }

    // MARK: - Primary Button

    private func primaryButton(
        title: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {

            HStack(spacing: 8) {

                Image(systemName: icon)

                Text(title)
            }
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Color.appOnBrand)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.appBrandGradient)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Weight Calculation

    private var calculatedPetWeight: Double? {

        guard
            let combined = Double(combinedWeight),
            let owner = Double(ownerWeight),
            combined > owner
        else {
            return nil
        }

        return combined - owner
    }

    private var canSaveWeight: Bool {

        petStore.selectedPet != nil &&
        (
            weighWithOwner
            ? calculatedPetWeight != nil
            : Double(petAloneWeight) != nil
        )
    }

    private func saveWeight() {

        guard let pet = petStore.selectedPet else {
            return
        }

        let finalWeightInSelectedUnit: Double

        if weighWithOwner {

            guard let result = calculatedPetWeight else {
                return
            }

            finalWeightInSelectedUnit = result

        } else {

            guard let value = Double(petAloneWeight) else {
                return
            }

            finalWeightInSelectedUnit = value
        }

        let kgValue =
            weightUnit.toKg(finalWeightInSelectedUnit)

        weightHeightStore.addWeightEntry(
            kg: kgValue,
            for: pet
        )

        petAloneWeight = ""
        combinedWeight = ""
        ownerWeight = ""
    }

    // MARK: - Height Saving

    private var canSaveHeight: Bool {

        petStore.selectedPet != nil &&
        Double(heightPrimary) != nil
    }

    private func saveHeight() {

        guard
            let pet = petStore.selectedPet,
            let primary = Double(heightPrimary)
        else {
            return
        }

        let secondary =
            Double(heightInchesRemainder) ?? 0

        let cmValue = heightUnit.toCm(
            value: primary,
            secondaryValue: secondary
        )

        weightHeightStore.addHeightEntry(
            cm: cmValue,
            for: pet
        )

        heightPrimary = ""
        heightInchesRemainder = ""
    }
}

#Preview {
    WeightHeightTrackerView()
        .environmentObject(
            PetStore(
                context:
                    PersistenceController
                        .shared
                        .container
                        .viewContext
            )
        )
        .environmentObject(
            WeightHeightStore(
                context:
                    PersistenceController
                        .shared
                        .container
                        .viewContext
            )
        )
}
