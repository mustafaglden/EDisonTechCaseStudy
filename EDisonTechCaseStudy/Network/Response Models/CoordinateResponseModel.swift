//
//  CoordinateResponseModel.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

import MapKit

struct CoordinateResponseModel: Codable, Identifiable {
    var id: String { "\(latitude),\(longitude)" }
    let latitude, longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
