//
//  LocationViewModel.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

import Foundation
import SwiftUI
import MapKit

final class LocationViewModel: ObservableObject {
    let networking: NetworkManager
    @Published var currentLocation: CoordinateResponseModel = CoordinateResponseModel(latitude: 0, longitude: 0)
    
    // New properties for managing the map’s region and any error message
    @Published var region: MapCameraPosition = .automatic
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var errorMessage: String? = nil
    
    init(networking: NetworkManager = Networking()) {
        self.networking = networking
    }
    
    var onLocationUpdated: (() -> Void)?

    /// Fetch the current location from your API.
    func fetchCurrentLocation() async {
        do {
            let request = CoordinateRequest()
            let fetchedLocation = try await networking.makeRequest(request)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.currentLocation = fetchedLocation
                    let newCoordinate = fetchedLocation.coordinate
                    self.region = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: newCoordinate,
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.01,
                                longitudeDelta: 0.01
                            )
                        )
                    )
                    self.routeCoordinates.append(newCoordinate)
                }
                self.errorMessage = nil
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Konum alınamadı: \(error.localizedDescription)"
            }
            print("Error fetching location: \(error.localizedDescription)")
        }
    }
    
    /// Continuously fetch location every 1 second.
    func startContinuousFetching() async {
        while true {
            await fetchCurrentLocation()
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
    
    func saveLocation() {
        
    }
}
