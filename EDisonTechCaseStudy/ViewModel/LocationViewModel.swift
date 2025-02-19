//
//  LocationViewModel.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

import Foundation
import SwiftUI
import MapKit

@MainActor
final class LocationViewModel: ObservableObject {
    let networking: NetworkManager
    @Published var currentLocation: CoordinateResponseModel = CoordinateResponseModel(latitude: 0, longitude: 0)
    @Published var region: MapCameraPosition?
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var errorMessage: String? = nil
    @Published var savedLocations: [SavedLocation] = UserDefaultsManager.getSavedLocations()
    
    private var fetchTask: Task<Void, Never>? // Stores background fetch task

    init(networking: NetworkManager = Networking()) {
        self.networking = networking
    }
    
    /// Fetch the current location from the API.
    func fetchCurrentLocation() async {
        do {
            print("Fetching location from API...") // 🔍 Debug Log
            
            let request = CoordinateRequest()
            let fetchedLocation = try await networking.makeRequest(request)

            let newCoordinate = fetchedLocation.coordinate
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.currentLocation = fetchedLocation
                    self.region = .region(
                                MKCoordinateRegion(
                                    center: newCoordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                )
                            )
                    self.routeCoordinates.append(newCoordinate)
                }
            }
            self.errorMessage = nil
        } catch {
            await MainActor.run {
                self.errorMessage = "Konum alınamadı: \(error.localizedDescription)"
            }
        }
    }
    
    /// Start fetching location continuously, even when in the background.
    func startContinuousFetching() {
        if fetchTask != nil { return } // Prevent multiple fetch tasks
        
        fetchTask = Task(priority: .background) { [weak self] in
            while !Task.isCancelled {
                await self?.fetchCurrentLocation()
                try? await Task.sleep(nanoseconds: 1_000_000_000) // Wait 1 sec
            }
        }
    }

    /// Save a new location
    func saveLocation(_ location: SavedLocation) {
        var adjustedLocation = location
        adjustedLocation.coordinate.latitude += 0.0001
        adjustedLocation.coordinate.longitude += 0.0001

        savedLocations.append(adjustedLocation)
        UserDefaultsManager.saveAllLocations(savedLocations)
    }


    /// Remove a location and update UI
    func removeLocation(_ location: SavedLocation) {
        savedLocations.removeAll { $0.id == location.id }
        UserDefaultsManager.removeLocation(location)
    }

    /// Rename a location and update UI
    func renameLocation(_ location: SavedLocation, newName: String) {
        if let index = savedLocations.firstIndex(where: { $0.id == location.id }) {
            savedLocations[index].name = newName
            UserDefaultsManager.renameLocation(savedLocations[index], newName: newName)
            DispatchQueue.main.async {
                self.savedLocations = UserDefaultsManager.getSavedLocations()
            }
        }
    }
}
