//
//  NearbyEcoView.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct NearbyEcoView: View {
    @StateObject private var locationService = LocationService()
    @State private var ecoCenters: [EcoCenter] = [] // Sample eco-friendly centers
    @State private var showPermissionAlert = false

    var body: some View {
        VStack {
            if let location = locationService.userLocation {
                Map(
                    coordinateRegion: .constant(MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )),
                    annotationItems: ecoCenters
                ) { center in
                    MapPin(coordinate: center.coordinate, tint: .green)
                }
                .frame(height: 300)
                .cornerRadius(15)
                .padding()

                Text("Your location is shown on the map.\nNearby eco-friendly centers are marked.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()
                    .multilineTextAlignment(.center)

                Button(action: refreshLocation) {
                    Label("Refresh Location", systemImage: "arrow.clockwise")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            } else {
                VStack(spacing: 20) {
                    if showPermissionAlert {
                        Text("Location permissions are denied. Please enable them in Settings to use this feature.")
                            .font(.headline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        Text("Fetching your location...")
                            .font(.headline)
                            .foregroundColor(.gray)

                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            locationService.requestLocationPermission()
            fetchEcoCenters()
        }
        .alert(isPresented: $showPermissionAlert) {
            Alert(
                title: Text("Location Permission Denied"),
                message: Text("Please enable location permissions in Settings to find nearby eco-friendly centers."),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Nearby Centers")
    }

    private func refreshLocation() {
        locationService.requestLocationPermission()
    }

    private func fetchEcoCenters() {
        // Mock data for nearby eco-friendly centers
        ecoCenters = [
            EcoCenter(name: "Green Recycling Center", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
            EcoCenter(name: "Eco-Friendly Shop", coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094))
        ]
    }
}

// MARK: - EcoCenter Model
struct EcoCenter: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
