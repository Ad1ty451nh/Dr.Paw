//
//  FoodWalkTrackerView.swift
//  Dr.Paw
//

import SwiftUI
import CoreData

struct FoodWalkTrackerView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore
    @State private var progress = FoodWalkProgress()

    private var slot: FoodWalkSlot { .current() }

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
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.black)
                                .frame(width: 44, height: 44)
                                .liquidGlass(in: Circle())
                        }
                        Spacer()
                        Text("Food & Walk")
                            .font(.system(size: 22, weight: .bold))
                        Spacer()
                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 12) {
                        Label(slot.title, systemImage: slot.icon)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color(hex: "#6D4093"))

                        Text(slot.detail)
                            .foregroundStyle(.gray)

                        if let pet = petStore.selectedPet ?? petStore.pets.first {
                            Text("For \(pet.name ?? "your pet")")
                                .font(.headline)
                        }

                        if let petID = activePetID {
                            taskStatus(for: .food, petID: petID)
                            taskStatus(for: .walk, petID: petID)
                        } else {
                            Text("Add a pet to start tracking food and walks.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }

                        Text("This resets at 12 PM and midnight, so Food and Walk can be tracked twice a day.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                WidgetSharedStore.sync(from: petStore.pets)
                refreshProgress()
            }
        }
    }

    private var activePetID: String? {
        (petStore.selectedPet ?? petStore.pets.first)?.id?.uuidString
    }

    private func taskStatus(for task: FoodWalkTask, petID: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: progress.isComplete(task) ? "checkmark.circle.fill" : task.icon)
                .font(.title3)
                .foregroundStyle(progress.isComplete(task) ? .green : Color(hex: "#6D4093"))

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.headline)
                Text(progress.isComplete(task) ? "Completed this \(slot.rawValue)" : "Not completed yet")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if !progress.isComplete(task) {
                Button("Mark done") {
                    WidgetSharedStore.completeFoodWalkTask(task, petID: petID, slot: slot)
                    refreshProgress()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: "#6D4093"))
            }
        }
        .padding(14)
        .background(Color(hex: "#F9E7C8").opacity(0.5), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func refreshProgress() {
        guard let petID = activePetID else {
            progress = FoodWalkProgress()
            return
        }
        progress = WidgetSharedStore.foodWalkProgress(petID: petID, slot: slot)
    }
}

#Preview {
    FoodWalkTrackerView()
        .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
}
