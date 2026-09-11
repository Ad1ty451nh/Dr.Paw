//
//  MedicalReminderView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 08/09/26.
//

import SwiftUI

struct MedicalReminderView: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
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

                        Text("Medical Reminder")
                            .font(.system(size: 22, weight: .bold))

                        Spacer()

                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // TODO: next visit date picker, countdown widget hook-up,
                    // and past-visit log list go here
                    Spacer()

                    Text("Medical Reminder coming soon")
                        .font(.subheadline)
                        .foregroundStyle(.gray)

                    Spacer()

                }
                .padding(.horizontal)

            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    MedicalReminderView()
}
