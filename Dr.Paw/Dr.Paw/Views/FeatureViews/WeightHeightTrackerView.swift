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
    @State private var heightPrimary = ""   // cm/inches value, or feet when unit == .feet
    @State private var heightInchesRemainder = "" // only used when unit == .feet

    init() {
        let weightRaw = UserDefaults.standard.string(forKey: "defaultWeightUnit") ?? WeightUnit.kg.rawValue
        let heightRaw = UserDefaults.standard.string(forKey: "defaultHeightUnit") ?? HeightUnit.cm.rawValue
        _weightUnit = State(initialValue: WeightUnit(rawValue: weightRaw) ?? .kg)
        _heightUnit = State(initialValue: HeightUnit(rawValue: heightRaw) ?? .cm)
    }

    var body: some View {
        NavigationStack {
            ZStack {

                LinearGradient(
                    colors: [Color(hex: "#F9E7C8"), Color(hex: "#ECE9E7")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

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

                            Text("Weight & Height")
                                .font(.system(size: 22, weight: .bold))

                            Spacer()

                            Color.clear.frame(width: 44, height: 44)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        petPickerCard
                        weightCard
                        heightCard

                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
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
            .sheet(isPresented: $showAddPetSheet, onDismiss: fetchEntriesForSelectedPet) {
                PetFormView()
                    .environmentObject(petStore)
            }
        }
    }

    // MARK: - Pet picker

    private var petPickerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PET")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
                .tracking(0.5)

            if petStore.pets.isEmpty {
                Button {
                    showNeedPetAlert = true
                } label: {
                    HStack {
                        Text("Select pet")
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color(hex: "#6D4093"))
                    }
                    .padding(14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
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
            }
        }
        .padding(18)
        .liquidGlass(in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var selectedPetID: Binding<UUID> {
        Binding(
            get: { petStore.selectedPet?.id ?? petStore.pets.first?.id ?? UUID() },
            set: { newValue in
                guard let pet = petStore.pets.first(where: { $0.id == newValue }) else { return }
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

    // MARK: - Weight card

    private var weightCard: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("WEIGHT")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
                .tracking(0.5)

            Picker("", selection: $weighWithOwner) {
                Text("Pet Alone").tag(false)
                Text("With Owner").tag(true)
            }
            .pickerStyle(.segmented)

            if weighWithOwner {
                labeledField(label: "Combined weight (you + pet)", text: $combinedWeight, unit: weightUnit.rawValue)
                labeledField(label: "Your weight alone", text: $ownerWeight, unit: weightUnit.rawValue)

                if let result = calculatedPetWeight {
                    Text("Pet weight: \(String(format: "%.1f", result)) \(weightUnit.rawValue)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color(hex: "#F79E1B"))
                }
            } else {
                labeledField(label: "Pet weight", text: $petAloneWeight, unit: weightUnit.rawValue)
            }

            Picker("Unit", selection: $weightUnit) {
                ForEach(WeightUnit.allCases) { unit in
                    Text(unit.rawValue.uppercased()).tag(unit)
                }
            }
            .pickerStyle(.segmented)

            Button {
                saveWeight()
            } label: {
                Text("Save Weight")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color(hex: "#6D4093"))
                    .clipShape(Capsule())
            }
            .disabled(!canSaveWeight)

        }
        .padding(18)
        .liquidGlass(in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var calculatedPetWeight: Double? {
        guard let combined = Double(combinedWeight), let owner = Double(ownerWeight), combined > owner else {
            return nil
        }
        return combined - owner
    }

    private var canSaveWeight: Bool {
        petStore.selectedPet != nil && (weighWithOwner ? calculatedPetWeight != nil : Double(petAloneWeight) != nil)
    }

    private func saveWeight() {
        guard let pet = petStore.selectedPet else { return }

        let finalWeightInSelectedUnit: Double
        if weighWithOwner {
            guard let result = calculatedPetWeight else { return }
            finalWeightInSelectedUnit = result
        } else {
            guard let value = Double(petAloneWeight) else { return }
            finalWeightInSelectedUnit = value
        }

        let kgValue = weightUnit.toKg(finalWeightInSelectedUnit)
        weightHeightStore.addWeightEntry(kg: kgValue, for: pet)

        petAloneWeight = ""
        combinedWeight = ""
        ownerWeight = ""
    }

    // MARK: - Height card

    private var heightCard: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("HEIGHT")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
                .tracking(0.5)

            Picker("Unit", selection: $heightUnit) {
                ForEach(HeightUnit.allCases) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: heightUnit) { _, _ in
                heightPrimary = ""
                heightInchesRemainder = ""
            }

            if heightUnit == .feet {
                HStack(spacing: 12) {
                    labeledField(label: "Feet", text: $heightPrimary, unit: "ft")
                    labeledField(label: "Inches", text: $heightInchesRemainder, unit: "in")
                }
            } else {
                labeledField(label: "Height", text: $heightPrimary, unit: heightUnit.rawValue)
            }

            Button {
                saveHeight()
            } label: {
                Text("Save Height")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color(hex: "#6D4093"))
                    .clipShape(Capsule())
            }
            .disabled(!canSaveHeight)

        }
        .padding(18)
        .liquidGlass(in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var canSaveHeight: Bool {
        petStore.selectedPet != nil && Double(heightPrimary) != nil
    }

    private func saveHeight() {
        guard let pet = petStore.selectedPet, let primary = Double(heightPrimary) else { return }

        let secondary = Double(heightInchesRemainder) ?? 0
        let cmValue = heightUnit.toCm(value: primary, secondaryValue: secondary)

        weightHeightStore.addHeightEntry(cm: cmValue, for: pet)

        heightPrimary = ""
        heightInchesRemainder = ""
    }

    // MARK: - Shared field

    private func labeledField(label: String, text: Binding<String>, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.gray)

            HStack {
                TextField("0", text: text)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 17, weight: .semibold))

                Text(unit)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .padding(12)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

#Preview {
    WeightHeightTrackerView()
        .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
        .environmentObject(WeightHeightStore(context: PersistenceController.shared.container.viewContext))
}
