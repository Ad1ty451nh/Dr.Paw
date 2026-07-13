//
//  NearbyVetClinicViewModel.swift
//  Dr.Paw
//
//  Created by Adityasinh on 10/07/26.
//

import Combine
import CoreLocation
import Foundation
import MapKit

@MainActor
final class NearbyVetClinicViewModel: ObservableObject {
    @Published var clinics: [VetClinic] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchClinics(near location: CLLocation) async {
        isLoading = true
        errorMessage = nil

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "veterinary clinic"
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 12000,
            longitudinalMeters: 12000
        )

        do {
            let response = try await MKLocalSearch(request: request).start()
            clinics = response.mapItems
                .map { VetClinic(mapItem: $0, userLocation: location) }
                .sorted { $0.distanceInMeters < $1.distanceInMeters }
            isLoading = false

            if clinics.isEmpty {
                errorMessage = "No nearby vet clinics found right now."
            }
        } catch {
            isLoading = false
            errorMessage = "Could not fetch nearby vet clinics. Please try again."
        }
    }
}
