//
//  VetClinic.swift
//  Dr.Paw
//
//  Created by Adityasinh on 10/07/26.
//

import Foundation
import MapKit

struct VetClinic: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let phoneNumber: String?
    let coordinate: CLLocationCoordinate2D
    let distanceInMeters: CLLocationDistance

    var formattedDistance: String {
        if distanceInMeters >= 1000 {
            return String(format: "%.1f km", distanceInMeters / 1000)
        }

        return "\(Int(distanceInMeters)) m"
    }

    init(mapItem: MKMapItem, userLocation: CLLocation) {
        let placemark = mapItem.placemark
        let clinicLocation = CLLocation(
            latitude: placemark.coordinate.latitude,
            longitude: placemark.coordinate.longitude
        )

        name = mapItem.name ?? "Veterinary Clinic"
        address = [
            placemark.subThoroughfare,
            placemark.thoroughfare,
            placemark.locality
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
        phoneNumber = mapItem.phoneNumber
        coordinate = placemark.coordinate
        distanceInMeters = userLocation.distance(from: clinicLocation)
    }
}
