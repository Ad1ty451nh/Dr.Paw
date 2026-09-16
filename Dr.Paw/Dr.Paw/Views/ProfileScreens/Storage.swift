//
//  Storage.swift
//  Dr.Paw
//
//  Created by Adityasinh on 17/07/26.
//

import SwiftUI

struct Storage: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petStore: PetStore
    @EnvironmentObject var weightHeightStore: WeightHeightStore

    private var counts: (weights: Int, heights: Int) {
        weightHeightStore.measurementCounts()
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#F9E7C8"), Color(hex: "#ECE9E7")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
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

                    Text("Storage")
                        .font(.system(size: 22, weight: .bold))

                    Spacer()

                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                VStack(spacing: 0) {
                    storageRow(title: "Pets", value: "\(petStore.pets.count)")
                    Divider().padding(.leading, 16)
                    storageRow(title: "Weight logs", value: "\(counts.weights)")
                    Divider().padding(.leading, 16)
                    storageRow(title: "Height logs", value: "\(counts.heights)")
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .padding(.horizontal)

                Text("All of this is stored on your device. Deleting a pet also removes that pet’s measurement history.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func storageRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(hex: "#6D4093"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    Storage()
        .environmentObject(PetStore(context: PersistenceController.shared.container.viewContext))
        .environmentObject(WeightHeightStore(context: PersistenceController.shared.container.viewContext))
}
