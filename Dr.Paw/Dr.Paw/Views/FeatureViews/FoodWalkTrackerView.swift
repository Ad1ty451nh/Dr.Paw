//
//  FoodWalkTrackerView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 08/09/26.
//

import SwiftUI

struct FoodWalkTrackerView: View {

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

                        Text("Food & Walk")
                            .font(.system(size: 22, weight: .bold))

                        Spacer()

                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // TODO: max-per-day setup (food/walk limits), today's toggle log,
                    // and per-entry timestamp history go here
                    Spacer()

                    Text("Food & Walk Tracker coming soon")
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
    FoodWalkTrackerView()
}
