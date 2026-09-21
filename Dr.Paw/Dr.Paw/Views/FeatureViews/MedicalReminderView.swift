//
//  MedicalReminderView.swift
//  Dr.Paw
//

import SwiftUI
import CoreData

struct MedicalReminderView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore

    @State private var selectedPetID: String = ""
    @State private var nextVisit = Date()
    @State private var hasVisitDate = false

    private var selectedPet: Pet? {
        petStore.pets.first { $0.id?.uuidString == selectedPetID } ?? petStore.selectedPet ?? petStore.pets.first
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

                VStack(spacing: 20) {
                    header

                    if petStore.pets.isEmpty {
                        Spacer()
                        Text("Add a pet first to set a medical visit.")
                            .foregroundStyle(.gray)
                        Spacer()
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            Picker("Pet", selection: $selectedPetID) {
                                ForEach(petStore.pets, id: \.objectID) { pet in
                                    Text(pet.name ?? "Unnamed")
                                        .tag(pet.id?.uuidString ?? "")
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .onChange(of: selectedPetID) { _, _ in
                                loadVisitDate()
                            }

                            Toggle("Next visit scheduled", isOn: $hasVisitDate)

                            if hasVisitDate {
                                DatePicker("Visit date", selection: $nextVisit, displayedComponents: .date)
                            }

                            if let daysCopy = daysCopy {
                                Text(daysCopy)
                                    .font(.headline)
                                    .foregroundStyle(Color(hex: "#6D4093"))
                            }

                            Button {
                                saveVisit()
                            } label: {
                                Text("Save visit")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 46)
                                    .background(Color(hex: "#6D4093"))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(18)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                WidgetSharedStore.sync(from: petStore.pets)
                if selectedPetID.isEmpty {
                    selectedPetID = petStore.selectedPet?.id?.uuidString ?? petStore.pets.first?.id?.uuidString ?? ""
                }
                loadVisitDate()
            }
        }
    }

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(width: 44, height: 44)
                    .liquidGlass(in: Circle())
            }
            Spacer()
            Text("Medical Reminder")
                .font(.system(size: 22, weight: .bold))
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.top, 8)
    }

    private var daysCopy: String? {
        guard hasVisitDate else { return nil }
        let days = WidgetTimelineSupport.daysUntil(nextVisit)
        if days < 0 { return "Visit was \(-days) days ago" }
        if days == 0 { return "Visit is today" }
        if days == 1 { return "1 day left" }
        return "\(days) days left"
    }

    private func loadVisitDate() {
        guard let id = selectedPet?.id?.uuidString,
              let stored = WidgetSharedStore.pet(id: id)?.nextVisitDate else {
            hasVisitDate = false
            nextVisit = Date()
            return
        }
        hasVisitDate = true
        nextVisit = stored
    }

    private func saveVisit() {
        guard let id = selectedPet?.id?.uuidString else { return }
        WidgetSharedStore.sync(from: petStore.pets)
        WidgetSharedStore.setNextVisit(petID: id, date: hasVisitDate ? nextVisit : nil)
    }
}

#Preview {
    MedicalReminderView()
        .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
}
