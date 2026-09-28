//
//  ScanResultView.swift
//  Dr.Paw
//
//  CoreML result screen
//  Based on the working CoreMLSandbox pipeline.
//

import SwiftUI
import Vision
import CoreML
import UIKit

struct ScanResultView: View {

    @Environment(\.dismiss) private var dismiss

    let image: UIImage

    @State private var resultText = "Analyzing..."
    @State private var isAnalyzing = true

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            // MARK: - Captured Image

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()

            // MARK: - Bottom Result

            VStack {

                Spacer()

                if isAnalyzing {

                    HStack(spacing: 10) {

                        ProgressView()
                            .tint(.white)

                        Text("Analyzing...")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 13)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())

                } else {

                    Text(resultText)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(.black.opacity(0.78))
                        .clipShape(Capsule())
                        .padding(.horizontal, 20)
                }

                // MARK: - Close Button

                HStack {

                    Button {
                        dismiss()
                    } label: {

                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 52, height: 52)
                            .background(.black.opacity(0.65))
                            .clipShape(Circle())
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }

        .onAppear {
            classify(image)
        }
    }
}


// MARK: - CoreML Classification

extension ScanResultView {

    private func classify(_ image: UIImage) {

        guard let ciImage = CIImage(image: image) else {

            resultText = "This image format isn't supported."
            isAnalyzing = false

            return
        }

        let config = MLModelConfiguration()

        config.computeUnits = .all


        // MARK: Species Model

        guard
            let speciesModel = try? SpeciesClassifier_(configuration: config).model,
            let visionSpeciesModel = try? VNCoreMLModel(
                for: speciesModel
            )
        else {

            resultText = "Species model failed to load."
            isAnalyzing = false

            return
        }


        let speciesRequest = VNCoreMLRequest(
            model: visionSpeciesModel
        ) { request, error in

            if let error {

                DispatchQueue.main.async {

                    resultText =
                        "Prediction failed: \(error.localizedDescription)"

                    isAnalyzing = false
                }

                return
            }


            guard
                let results =
                    request.results as? [VNClassificationObservation],
                let topSpecies = results.first
            else {

                DispatchQueue.main.async {

                    resultText =
                        "The model returned no classification."

                    isAnalyzing = false
                }

                return
            }


            // MARK: Confidence Check

            guard topSpecies.confidence > 0.75 else {

                DispatchQueue.main.async {

                    resultText =
                        "Not confident enough — try a clearer photo."

                    isAnalyzing = false
                }

                return
            }


            // MARK: Species Routing

            switch topSpecies.identifier {

            case "Dogs":

                classifyDogBreed(
                    ciImage: ciImage,
                    config: config
                )


            case "Cats":

                classifyCatBreed(
                    ciImage: ciImage,
                    config: config
                )


            case "Birds":

                classifyBird(
                    ciImage: ciImage,
                    config: config
                )


            case "FarmAnimals":

                classifyFarmAnimal(
                    ciImage: ciImage,
                    config: config
                )


            case "Rodents":

                classifyRodent(
                    ciImage: ciImage,
                    config: config
                )


            case "Turtles":

                DispatchQueue.main.async {

                    resultText =
                        "Turtle — \(Int(topSpecies.confidence * 100))% confident"

                    isAnalyzing = false
                }


            default:

                DispatchQueue.main.async {

                    resultText =
                        "\(topSpecies.identifier) — \(Int(topSpecies.confidence * 100))% confident"

                    isAnalyzing = false
                }
            }
        }


        // MARK: Run Species Model

        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up
        )

        do {

            try handler.perform([
                speciesRequest
            ])

        } catch {

            resultText =
                "Prediction failed: \(error.localizedDescription)"

            isAnalyzing = false
        }
    }
}


// MARK: - Dog Breed

extension ScanResultView {

    private func classifyDogBreed(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let breedModel =
                try? DogBreedClassifier(
                    configuration: config
                ).model,

            let visionBreedModel =
                try? VNCoreMLModel(
                    for: breedModel
                )
        else {

            DispatchQueue.main.async {

                resultText =
                    "Dog breed model failed to load."

                isAnalyzing = false
            }

            return
        }


        let breedRequest = VNCoreMLRequest(
            model: visionBreedModel
        ) { request, error in

            if let error {

                DispatchQueue.main.async {

                    resultText =
                        "Breed prediction failed: \(error.localizedDescription)"

                    isAnalyzing = false
                }

                return
            }


            guard
                let results =
                    request.results as? [VNClassificationObservation],

                let topBreed =
                    results.first
            else {

                DispatchQueue.main.async {

                    resultText =
                        "Dog — breed unclear"

                    isAnalyzing = false
                }

                return
            }


            DispatchQueue.main.async {

                resultText =
                    "\(topBreed.identifier) — \(Int(topBreed.confidence * 100))% confident"

                isAnalyzing = false
            }
        }


        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up
        )

        do {

            try handler.perform([
                breedRequest
            ])

        } catch {

            DispatchQueue.main.async {

                resultText =
                    "Dog breed prediction failed."

                isAnalyzing = false
            }
        }
    }
}


// MARK: - Cat Breed

extension ScanResultView {

    private func classifyCatBreed(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let breedModel =
                try? CatBreedClassifier(
                    configuration: config
                ).model,

            let visionBreedModel =
                try? VNCoreMLModel(
                    for: breedModel
                )
        else {

            DispatchQueue.main.async {

                resultText =
                    "Cat breed model failed to load."

                isAnalyzing = false
            }

            return
        }


        let breedRequest = VNCoreMLRequest(
            model: visionBreedModel
        ) { request, error in

            if let error {

                DispatchQueue.main.async {

                    resultText =
                        "Cat breed prediction failed: \(error.localizedDescription)"

                    isAnalyzing = false
                }

                return
            }


            guard
                let results =
                    request.results as? [VNClassificationObservation],

                let topBreed =
                    results.first
            else {

                DispatchQueue.main.async {

                    resultText =
                        "Cat — breed unclear"

                    isAnalyzing = false
                }

                return
            }


            // THIS is the important part.
            //
            // We do NOT try to find the breed in AnimalData.
            //
            // We simply display exactly what CoreML predicted.

            DispatchQueue.main.async {

                resultText =
                    "\(topBreed.identifier) — \(Int(topBreed.confidence * 100))% confident"

                isAnalyzing = false
            }
        }


        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up
        )

        do {

            try handler.perform([
                breedRequest
            ])

        } catch {

            DispatchQueue.main.async {

                resultText =
                    "Cat breed prediction failed."

                isAnalyzing = false
            }
        }
    }
}


// MARK: - Bird

extension ScanResultView {

    private func classifyBird(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let birdModel =
                try? BirdClassifier(
                    configuration: config
                ).model,

            let visionBirdModel =
                try? VNCoreMLModel(
                    for: birdModel
                )
        else {

            DispatchQueue.main.async {

                resultText =
                    "Bird model failed to load."

                isAnalyzing = false
            }

            return
        }


        let request = VNCoreMLRequest(
            model: visionBirdModel
        ) { request, error in

            guard
                error == nil,

                let results =
                    request.results as? [VNClassificationObservation],

                let topResult =
                    results.first

            else {

                DispatchQueue.main.async {

                    resultText =
                        "Bird — type unclear"

                    isAnalyzing = false
                }

                return
            }


            DispatchQueue.main.async {

                resultText =
                    "\(topResult.identifier) — \(Int(topResult.confidence * 100))% confident"

                isAnalyzing = false
            }
        }


        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up
        )

        do {

            try handler.perform([
                request
            ])

        } catch {

            DispatchQueue.main.async {

                resultText =
                    "Bird prediction failed."

                isAnalyzing = false
            }
        }
    }
}


// MARK: - Farm Animal

extension ScanResultView {

    private func classifyFarmAnimal(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let farmModel =
                try? FarmAnimalClassifier(
                    configuration: config
                ).model,

            let visionFarmModel =
                try? VNCoreMLModel(
                    for: farmModel
                )
        else {

            DispatchQueue.main.async {

                resultText =
                    "Farm animal model failed to load."

                isAnalyzing = false
            }

            return
        }


        let request = VNCoreMLRequest(
            model: visionFarmModel
        ) { request, error in

            guard
                error == nil,

                let results =
                    request.results as? [VNClassificationObservation],

                let topResult =
                    results.first

            else {

                DispatchQueue.main.async {

                    resultText =
                        "Farm animal — type unclear"

                    isAnalyzing = false
                }

                return
            }


            DispatchQueue.main.async {

                resultText =
                    "\(topResult.identifier) — \(Int(topResult.confidence * 100))% confident"

                isAnalyzing = false
            }
        }


        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up
        )

        do {

            try handler.perform([
                request
            ])

        } catch {

            DispatchQueue.main.async {

                resultText =
                    "Farm animal prediction failed."

                isAnalyzing = false
            }
        }
    }
}


// MARK: - Rodent

extension ScanResultView {

    private func classifyRodent(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let rodentModel =
                try? RodentClassifier(
                    configuration: config
                ).model,

            let visionRodentModel =
                try? VNCoreMLModel(
                    for: rodentModel
                )
        else {

            DispatchQueue.main.async {

                resultText =
                    "Rodent model failed to load."

                isAnalyzing = false
            }

            return
        }


        let request = VNCoreMLRequest(
            model: visionRodentModel
        ) { request, error in

            guard
                error == nil,

                let results =
                    request.results as? [VNClassificationObservation],

                let topResult =
                    results.first

            else {

                DispatchQueue.main.async {

                    resultText =
                        "Rodent — type unclear"

                    isAnalyzing = false
                }

                return
            }


            DispatchQueue.main.async {

                resultText =
                    "\(topResult.identifier) — \(Int(topResult.confidence * 100))% confident"

                isAnalyzing = false
            }
        }


        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up
        )

        do {

            try handler.perform([
                request
            ])

        } catch {

            DispatchQueue.main.async {

                resultText =
                    "Rodent prediction failed."

                isAnalyzing = false
            }
        }
    }
}
