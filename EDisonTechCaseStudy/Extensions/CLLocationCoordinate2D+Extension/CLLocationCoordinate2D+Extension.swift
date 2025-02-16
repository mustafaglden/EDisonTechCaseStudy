//
//  CLLocationCoordinate2D+Extension.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 16.02.2025.
//

import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
