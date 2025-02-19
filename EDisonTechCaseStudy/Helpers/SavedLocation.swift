//
//  SavedLocation.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 18.02.2025.
//

import Foundation

struct SavedLocation: Identifiable, Codable, Hashable {
    var id: UUID
    var coordinate: CLLocationCoordinate2DWrapper
    var name: String
    
    init(id: UUID = UUID(), coordinate: CLLocationCoordinate2DWrapper, name: String) {
        self.id = id
        self.coordinate = coordinate
        self.name = name
    }
}
