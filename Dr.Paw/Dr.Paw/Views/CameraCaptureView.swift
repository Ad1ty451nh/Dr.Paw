//
//  CameraCaptureView.swift
//  Dr.Paw
//
//  Camera + CoreML animal breed detection.
//
//  FLOW:
//
//  Camera
//      ↓
//  Take Photo
//      ↓
//  Retake / Use Photo
//      ↓
//  CoreML
//      ↓
//  "Maine Coon — 99% confident"
//
//  No ScanResultView.
//  No navigation to another screen.
//

import SwiftUI
import UIKit
import Vision
import CoreML


// MARK: - Camera Capture View

struct CameraCaptureView: View {

    // Allows this view to dismiss the fullScreenCover from HomeScreenView.
    @Environment(\.dismiss) private var dismiss

    // The image selected after pressing "Use Photo".
    @State private var capturedImage: UIImage?

    // Result displayed directly over the captured image.
    @State private var resultText = "Analyzing..."

    // Shows the loading state while CoreML is working.
    @State private var isClassifying = false

    // Controls whether the native camera is visible.
    @State private var showCamera = true


    var body: some View {

        ZStack {

            // MARK: - Captured Image

            if let capturedImage {

                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .background(Color.black)
                    .ignoresSafeArea()

            } else {

                Color.black
                    .ignoresSafeArea()
            }


            // MARK: - Result

            if capturedImage != nil {

                VStack {

                    Spacer()

                    if isClassifying {

                        HStack(spacing: 10) {

                            ProgressView()
                                .tint(.white)

                            Text("Analyzing...")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())

                    } else {

                        Text(resultText)
                            .font(.system(
                                size: 18,
                                weight: .bold,
                                design: .rounded
                            ))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 22)
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
                                .font(.system(
                                    size: 22,
                                    weight: .bold
                                ))
                                .foregroundStyle(.white)
                                .frame(width: 56, height: 56)
                                .background(
                                    .black.opacity(0.65)
                                )
                                .clipShape(Circle())
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
        }


        // MARK: - Native Camera

        .fullScreenCover(
            isPresented: $showCamera
        ) {

            NativeCameraPicker { image in

                guard let image else {

                    dismiss()

                    return
                }

                // Save the selected image.
                capturedImage = image

                // Hide the native camera.
                showCamera = false

                // Start CoreML.
                classify(image)
            }
        }
    }
}


// MARK: - CoreML

private extension CameraCaptureView {

    func classify(_ image: UIImage) {

        guard let ciImage = CIImage(image: image) else {

            resultText = "This image format isn't supported."
            isClassifying = false

            return
        }

        isClassifying = true
        resultText = "Analyzing..."


        // MARK: - Model Configuration

        let config = MLModelConfiguration()

        config.computeUnits = .all


        // MARK: - Species Model

        guard
            let speciesModel = try? SpeciesClassifier_(
                configuration: config
            ).model,

            let visionSpeciesModel = try? VNCoreMLModel(
                for: speciesModel
            )

        else {

            resultText = "Species model failed to load."
            isClassifying = false

            return
        }


        let speciesRequest = VNCoreMLRequest(
            model: visionSpeciesModel
        ) { request, error in

            if let error {

                DispatchQueue.main.async {

                    resultText =
                        "Prediction failed: \(error.localizedDescription)"

                    isClassifying = false
                }

                return
            }


            guard
                let results =
                    request.results as? [VNClassificationObservation],

                let topSpecies =
                    results.first

            else {

                DispatchQueue.main.async {

                    resultText =
                        "The model returned no classification."

                    isClassifying = false
                }

                return
            }


            // MARK: Confidence

            guard topSpecies.confidence > 0.75 else {

                DispatchQueue.main.async {

                    resultText =
                        "Not confident enough — try a clearer photo."

                    isClassifying = false
                }

                return
            }


            // MARK: Species → Breed Model

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

                    isClassifying = false
                }


            default:

                DispatchQueue.main.async {

                    resultText =
                        "\(topSpecies.identifier) — \(Int(topSpecies.confidence * 100))% confident"

                    isClassifying = false
                }
            }
        }


        // MARK: - Run Species Model

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

            isClassifying = false
        }
    }
}


// MARK: - Dog Breed

private extension CameraCaptureView {

    func classifyDogBreed(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let breedModel = try? DogBreedClassifier(
                configuration: config
            ).model,

            let visionBreedModel = try? VNCoreMLModel(
                for: breedModel
            )

        else {

            DispatchQueue.main.async {

                resultText =
                    "Dog breed model failed to load."

                isClassifying = false
            }

            return
        }


        let request = VNCoreMLRequest(
            model: visionBreedModel
        ) { request, error in

            guard
                error == nil,

                let results =
                    request.results as? [VNClassificationObservation],

                let topBreed =
                    results.first

            else {

                DispatchQueue.main.async {

                    resultText =
                        "Dog — breed unclear"

                    isClassifying = false
                }

                return
            }


            DispatchQueue.main.async {

                resultText =
                    "\(topBreed.identifier) — \(Int(topBreed.confidence * 100))% confident"

                isClassifying = false
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
                    "Dog breed prediction failed."

                isClassifying = false
            }
        }
    }
}


// MARK: - Cat Breed

private extension CameraCaptureView {

    func classifyCatBreed(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let breedModel = try? CatBreedClassifier(
                configuration: config
            ).model,

            let visionBreedModel = try? VNCoreMLModel(
                for: breedModel
            )

        else {

            DispatchQueue.main.async {

                resultText =
                    "Cat breed model failed to load."

                isClassifying = false
            }

            return
        }


        let request = VNCoreMLRequest(
            model: visionBreedModel
        ) { request, error in

            guard
                error == nil,

                let results =
                    request.results as? [VNClassificationObservation],

                let topBreed =
                    results.first

            else {

                DispatchQueue.main.async {

                    resultText =
                        "Cat — breed unclear"

                    isClassifying = false
                }

                return
            }


            // THIS is what we want.
            //
            // No AnimalData.
            // No AnimalDatabase.
            // No ScanResultView.
            //
            // Just show the CoreML prediction.

            DispatchQueue.main.async {

                resultText =
                    "\(topBreed.identifier) — \(Int(topBreed.confidence * 100))% confident"

                isClassifying = false
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
                    "Cat breed prediction failed."

                isClassifying = false
            }
        }
    }
}


// MARK: - Bird

private extension CameraCaptureView {

    func classifyBird(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let model = try? BirdClassifier(
                configuration: config
            ).model,

            let visionModel = try? VNCoreMLModel(
                for: model
            )

        else {

            DispatchQueue.main.async {

                resultText =
                    "Bird model failed to load."

                isClassifying = false
            }

            return
        }


        let request = VNCoreMLRequest(
            model: visionModel
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

                    isClassifying = false
                }

                return
            }


            DispatchQueue.main.async {

                resultText =
                    "\(topResult.identifier) — \(Int(topResult.confidence * 100))% confident"

                isClassifying = false
            }
        }


        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up
        )

        try? handler.perform([
            request
        ])
    }
}


// MARK: - Farm Animal

private extension CameraCaptureView {

    func classifyFarmAnimal(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let model = try? FarmAnimalClassifier(
                configuration: config
            ).model,

            let visionModel = try? VNCoreMLModel(
                for: model
            )

        else {

            DispatchQueue.main.async {

                resultText =
                    "Farm animal model failed to load."

                isClassifying = false
            }

            return
        }


        let request = VNCoreMLRequest(
            model: visionModel
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

                    isClassifying = false
                }

                return
            }


            DispatchQueue.main.async {

                resultText =
                    "\(topResult.identifier) — \(Int(topResult.confidence * 100))% confident"

                isClassifying = false
            }
        }


        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up
        )

        try? handler.perform([
            request
        ])
    }
}


// MARK: - Rodent

private extension CameraCaptureView {

    func classifyRodent(
        ciImage: CIImage,
        config: MLModelConfiguration
    ) {

        guard
            let model = try? RodentClassifier(
                configuration: config
            ).model,

            let visionModel = try? VNCoreMLModel(
                for: model
            )

        else {

            DispatchQueue.main.async {

                resultText =
                    "Rodent model failed to load."

                isClassifying = false
            }

            return
        }


        let request = VNCoreMLRequest(
            model: visionModel
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

                    isClassifying = false
                }

                return
            }


            DispatchQueue.main.async {

                resultText =
                    "\(topResult.identifier) — \(Int(topResult.confidence * 100))% confident"

                isClassifying = false
            }
        }


        let handler = VNImageRequestHandler(
            ciImage: ciImage,
            orientation: .up
        )

        try? handler.perform([
            request
        ])
    }
}


// MARK: - Native Camera Picker

private struct NativeCameraPicker: UIViewControllerRepresentable {

    let onFinish: (UIImage?) -> Void


    func makeCoordinator() -> Coordinator {

        Coordinator(
            onFinish: onFinish
        )
    }


    func makeUIViewController(
        context: Context
    ) -> UIImagePickerController {

        let picker = UIImagePickerController()

        picker.delegate = context.coordinator

        picker.sourceType = .camera

        picker.cameraCaptureMode = .photo

        picker.allowsEditing = false

        return picker
    }


    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {
        // Nothing required.
    }


    final class Coordinator:
        NSObject,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate {


        let onFinish: (UIImage?) -> Void


        init(
            onFinish: @escaping (UIImage?) -> Void
        ) {

            self.onFinish = onFinish
        }


        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info:
                [UIImagePickerController.InfoKey: Any]
        ) {

            let image =
                info[.originalImage] as? UIImage

            onFinish(image)
        }


        func imagePickerControllerDidCancel(
            _ picker: UIImagePickerController
        ) {

            onFinish(nil)
        }
    }
}
