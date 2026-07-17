//
//  VetClinicCardView.swift
//  Dr.Paw
//
//  Created by Adityasinh on 10/07/26.
//

import MapKit
import SwiftUI

struct VetClinicCardView: View {
    let clinic: VetClinic

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: "cross.case.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Color(hex: "#6D4093"))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 6) {
                    Text(clinic.name)
                        .font(.headline)
                        .foregroundStyle(.black)
                        .lineLimit(2)

                    if clinic.address.isEmpty == false {
                        Text(clinic.address)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .lineLimit(2)
                    }
                }

                Spacer()
            }

            HStack(spacing: 10) {
                Label(clinic.formattedDistance, systemImage: "location.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color(hex: "#F79E1B"))

                Spacer()

                Link(destination: mapsURL) {
                    Image(systemName: "map.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(Color(hex: "#F79E1B"))
                        .clipShape(Circle())
                }

                if let phoneURL {
                    Link(destination: phoneURL) {
                        Image(systemName: "phone.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 42, height: 42)
                            .background(Color(hex: "#3A264B"))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(hex: "#6D4093").opacity(0.16), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)
    }

    private var mapsURL: URL {
        let latitude = clinic.coordinate.latitude
        let longitude = clinic.coordinate.longitude
        let encodedName = clinic.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Vet Clinic"

        return URL(string: "http://maps.apple.com/?ll=\(latitude),\(longitude)&q=\(encodedName)")!
    }

    private var phoneURL: URL? {
        guard let phoneNumber = clinic.phoneNumber else {
            return nil
        }

        let digits = phoneNumber.filter { $0.isNumber || $0 == "+" }
        return URL(string: "tel://\(digits)")
    }
}

#Preview {
    VetClinicCardView(
        clinic: VetClinic(
            mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 23.0225, longitude: 72.5714))),
            userLocation: CLLocation(latitude: 23.0225, longitude: 72.5714)
        )
    )
    .padding()
    .background(Color(hex: "#ECE9E7"))
}
