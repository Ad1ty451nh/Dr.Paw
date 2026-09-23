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

    @State private var matchedAnimal: Animal?
    @State private var isAnalyzing = true
    @State private var noMatchMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#ECE9E7").ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(uiImage: image)
                        .resizable().scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal).padding(.top, 12)

                    if isAnalyzing {
                        ProgressView("Analyzing…")
                    } else if let noMatchMessage {
                        Text(noMatchMessage)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal)
                    }
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
            // Programmatic redirect — fires the moment a match is found
            .navigationDestination(item: $matchedAnimal) { animal in
                AnimalDetailView(animal: animal)
            }
            .onAppear {
                AnimalClassifier.classify(image) { rawLabel, confidence in
                    DispatchQueue.main.async {
                        isAnalyzing = false
                        if let rawLabel, let animal = ClassifierLabelMap.lookup(rawLabel) {
                            matchedAnimal = animal
                        } else {
                            noMatchMessage = rawLabel == nil
                                ? "Couldn't identify this animal confidently."
                                : "Recognized as \(rawLabel!), but it's not in our library yet."
                        }
                    }
                }
            }
        }
    }
}
