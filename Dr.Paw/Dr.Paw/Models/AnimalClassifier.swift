//
//  AnimalClassifier.swift
//  Dr.Paw
//
//  Created by Adityasinh on 23/09/26.
//
//  The full two-stage Vision + CoreML pipeline, ported from CoreMLSandbox.
//  Reports its result through a completion closure since this is a plain
//  service now, not View code — no @State to write into directly.

import Foundation
import Vision
import CoreML
import UIKit

enum AnimalClassifier {

    // Same threshold tuned during sandbox testing (raised from 0.6 to
    // 0.75 after the face-misclassification edge case).
    private static let confidenceThreshold: Float = 0.75

    /// Runs the full pipeline on a captured photo.
    /// completion gives back (rawLabel, confidence). rawLabel is nil when
    /// nothing could be classified confidently — check that first.
    static func classify(_ image: UIImage, completion: @escaping (String?, Float) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(nil, 0)
            return
        }

        let config = MLModelConfiguration()
        config.computeUnits = .all

        // STAGE 1: Species classification (Dogs / Cats / Birds / FarmAnimals / Rodents / Turtles / NotAnAnimal)
        guard let speciesModel = try? SpeciesClassifier_(configuration: config).model,
              let visionSpeciesModel = try? VNCoreMLModel(for: speciesModel) else {
            completion(nil, 0)
            return
        }

        let speciesRequest = VNCoreMLRequest(model: visionSpeciesModel) { request, error in
            guard error == nil,
                  let results = request.results as? [VNClassificationObservation],
                  let topSpecies = results.first else {
                completion(nil, 0)
                return
            }

            guard topSpecies.confidence > confidenceThreshold else {
                // Not confident enough — treat as "couldn't identify"
                completion(nil, topSpecies.confidence)
                return
            }

            switch topSpecies.identifier {
            case "Dogs":
                classifyDogBreed(ciImage: ciImage, config: config, completion: completion)
            case "Cats":
                classifyCatBreed(ciImage: ciImage, config: config, completion: completion)
            case "Birds":
                classifyBird(ciImage: ciImage, config: config, completion: completion)
            case "FarmAnimals":
                classifyFarmAnimal(ciImage: ciImage, config: config, completion: completion)
            case "Rodents":
                classifyRodent(ciImage: ciImage, config: config, completion: completion)
            case "Turtles":
                // No Stage 2 model exists — only one known reptile, report it directly
                completion("Turtle", topSpecies.confidence)
            default:
                // NotAnAnimal, or anything unexpected
                completion(nil, topSpecies.confidence)
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        do {
            try handler.perform([speciesRequest])
        } catch {
            completion(nil, 0)
        }
    }

    // MARK: - Stage 2 specialists
    // Each function below is structurally identical to the ones in the
    // sandbox's ContentView — just pointed at a different model, and
    // reporting through completion(_:_:) instead of mutating resultText.

    private static func classifyDogBreed(ciImage: CIImage, config: MLModelConfiguration, completion: @escaping (String?, Float) -> Void) {
        guard let breedModel = try? DogBreedClassifier(configuration: config).model,
              let visionBreedModel = try? VNCoreMLModel(for: breedModel) else {
            completion(nil, 0)
            return
        }
        let breedRequest = VNCoreMLRequest(model: visionBreedModel) { request, error in
            guard error == nil,
                  let results = request.results as? [VNClassificationObservation],
                  let topBreed = results.first else {
                completion(nil, 0)
                return
            }
            completion(topBreed.identifier, topBreed.confidence)
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        try? handler.perform([breedRequest])
    }

    private static func classifyCatBreed(ciImage: CIImage, config: MLModelConfiguration, completion: @escaping (String?, Float) -> Void) {
        guard let breedModel = try? CatBreedClassifier(configuration: config).model,
              let visionBreedModel = try? VNCoreMLModel(for: breedModel) else {
            completion(nil, 0)
            return
        }
        let breedRequest = VNCoreMLRequest(model: visionBreedModel) { request, error in
            guard error == nil,
                  let results = request.results as? [VNClassificationObservation],
                  let topBreed = results.first else {
                completion(nil, 0)
                return
            }
            completion(topBreed.identifier, topBreed.confidence)
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        try? handler.perform([breedRequest])
    }

    private static func classifyBird(ciImage: CIImage, config: MLModelConfiguration, completion: @escaping (String?, Float) -> Void) {
        guard let birdModel = try? BirdClassifier(configuration: config).model,
              let visionBirdModel = try? VNCoreMLModel(for: birdModel) else {
            completion(nil, 0)
            return
        }
        let birdRequest = VNCoreMLRequest(model: visionBirdModel) { request, error in
            guard error == nil,
                  let results = request.results as? [VNClassificationObservation],
                  let topBird = results.first else {
                completion(nil, 0)
                return
            }
            completion(topBird.identifier, topBird.confidence)
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        try? handler.perform([birdRequest])
    }

    private static func classifyFarmAnimal(ciImage: CIImage, config: MLModelConfiguration, completion: @escaping (String?, Float) -> Void) {
        guard let farmModel = try? FarmAnimalClassifier(configuration: config).model,
              let visionFarmModel = try? VNCoreMLModel(for: farmModel) else {
            completion(nil, 0)
            return
        }
        let farmRequest = VNCoreMLRequest(model: visionFarmModel) { request, error in
            guard error == nil,
                  let results = request.results as? [VNClassificationObservation],
                  let topFarm = results.first else {
                completion(nil, 0)
                return
            }
            completion(topFarm.identifier, topFarm.confidence)
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        try? handler.perform([farmRequest])
    }

    private static func classifyRodent(ciImage: CIImage, config: MLModelConfiguration, completion: @escaping (String?, Float) -> Void) {
        guard let rodentModel = try? RodentClassifier(configuration: config).model,
              let visionRodentModel = try? VNCoreMLModel(for: rodentModel) else {
            completion(nil, 0)
            return
        }
        let rodentRequest = VNCoreMLRequest(model: visionRodentModel) { request, error in
            guard error == nil,
                  let results = request.results as? [VNClassificationObservation],
                  let topRodent = results.first else {
                completion(nil, 0)
                return
            }
            completion(topRodent.identifier, topRodent.confidence)
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        try? handler.perform([rodentRequest])
    }
}
