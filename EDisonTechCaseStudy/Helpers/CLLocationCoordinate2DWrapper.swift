//
//  CLLocationCoordinate2DWrapper.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 18.02.2025.
//

import MapKit

struct CLLocationCoordinate2DWrapper: Codable, Hashable {
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
