//
//  ScanResultView.swift
//  Dr.Paw
//
//  Shown right after the camera captures a photo. This is where you'll
//  hook in Vision + CoreML classification (Month 4 of your roadmap).
//

import SwiftUI

struct ScanResultView: View {
    @Environment(\.dismiss) private var dismiss
    let image: UIImage

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#ECE9E7")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                        .padding(.top, 12)

                    // TODO: Replace with real CoreML/Vision classification
                    VStack(spacing: 8) {
                        Text("Analyzing…")
                            .font(.headline)
                        Text("Not sure yet — pick manually")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle("Scan Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ScanResultView(image: UIImage(systemName: "pawprint.fill") ?? UIImage())
}
