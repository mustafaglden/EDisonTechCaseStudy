//
//  UserDefaultsManager.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 18.02.2025.
//

import Foundation
import MapKit

final class UserDefaultsManager {
    static let key = "SavedLocations"

    /// Save a single location
    static func saveLocation(_ location: SavedLocation) {
        var savedLocations = getSavedLocations()
        savedLocations.append(location)
        saveAllLocations(savedLocations)
    }

    /// Save all locations
    static func saveAllLocations(_ locations: [SavedLocation]) {
        let data = try? JSONEncoder().encode(locations)
        UserDefaults.standard.set(data, forKey: key)
    }

    /// Retrieve all saved locations
    static func getSavedLocations() -> [SavedLocation] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let savedLocations = try? JSONDecoder().decode([SavedLocation].self, from: data)
        else {
            return []
        }
        return savedLocations
    }

    /// Remove a saved location
    static func removeLocation(_ location: SavedLocation) {
        var savedLocations = getSavedLocations()
        savedLocations.removeAll { $0.id == location.id }
        saveAllLocations(savedLocations)
    }

    /// Rename a saved location
    static func renameLocation(_ location: SavedLocation, newName: String) {
        var savedLocations = getSavedLocations()
        if let index = savedLocations.firstIndex(where: { $0.id == location.id }) {
            savedLocations[index].name = newName
            DispatchQueue.global(qos: .background).async {
                saveAllLocations(savedLocations) 
            }
        }
    }
}
