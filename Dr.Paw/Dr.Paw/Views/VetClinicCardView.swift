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
        VStack(alignment: .leading, spacing: 16) {
            clinicHeader
            clinicInfo
            actionButtons
        }
        .padding(18)
        .background(Color.appSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .stroke(Color.appBorder, lineWidth: 1)
        }
        .shadow(
            color: Color.appElevatedShadow,
            radius: 12,
            x: 0,
            y: 6
        )
    }
}

// MARK: - UI Components

private extension VetClinicCardView {
    
    var clinicHeader: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.appBlush)
                    .frame(width: 52, height: 52)
                
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.appBrand)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(clinic.name)
                    .font(.system(
                        size: 17,
                        weight: .bold,
                        design: .rounded
                    ))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)
                
                if !clinic.address.isEmpty {
                    Text(clinic.address)
                        .font(.system(
                            size: 13,
                            weight: .medium,
                            design: .rounded
                        ))
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
    }
    
    var clinicInfo: some View {
        HStack(spacing: 8) {
            Image(systemName: "location.fill")
                .font(.system(size: 12, weight: .semibold))
            
            Text(clinic.formattedDistance)
                .font(.system(
                    size: 13,
                    weight: .bold,
                    design: .rounded
                ))
        }
        .foregroundStyle(Color.appAccent)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.appBlush.opacity(0.7))
        .clipShape(Capsule())
    }
    
    var actionButtons: some View {
        HStack(spacing: 10) {
            Link(destination: mapsURL) {
                HStack(spacing: 8) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 14, weight: .bold))
                    
                    Text("Directions")
                        .font(.system(
                            size: 14,
                            weight: .bold,
                            design: .rounded
                        ))
                }
                .foregroundStyle(Color.appOnBrand)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(Color.appBrand)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 15,
                        style: .continuous
                    )
                )
            }
            
            if let phoneURL {
                Link(destination: phoneURL) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.appBrand)
                        .frame(width: 46, height: 46)
                        .background(Color.appBlush)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 15,
                                style: .continuous
                            )
                        )
                        .overlay {
                            RoundedRectangle(
                                cornerRadius: 15,
                                style: .continuous
                            )
                            .stroke(
                                Color.appBorder,
                                lineWidth: 1
                            )
                        }
                }
            }
        }
    }
}

// MARK: - URLs

private extension VetClinicCardView {
    
    var mapsURL: URL {
        let latitude = clinic.coordinate.latitude
        let longitude = clinic.coordinate.longitude
        
        let encodedName = clinic.name.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? "Vet Clinic"
        
        return URL(
            string:
                "http://maps.apple.com/?ll=\(latitude),\(longitude)&q=\(encodedName)"
        )!
    }
    
    var phoneURL: URL? {
        guard let phoneNumber = clinic.phoneNumber else {
            return nil
        }
        
        let digits = phoneNumber.filter {
            $0.isNumber || $0 == "+"
        }
        
        guard !digits.isEmpty else {
            return nil
        }
        
        return URL(string: "tel://\(digits)")
    }
}

// MARK: - Preview

#Preview {
    VetClinicCardView(
        clinic: VetClinic(
            mapItem: MKMapItem(
                placemark: MKPlacemark(
                    coordinate: CLLocationCoordinate2D(
                        latitude: 23.0225,
                        longitude: 72.5714
                    )
                )
            ),
            userLocation: CLLocation(
                latitude: 23.0225,
                longitude: 72.5714
            )
        )
    )
    .padding()
    .background(Color.appBackground)
}
