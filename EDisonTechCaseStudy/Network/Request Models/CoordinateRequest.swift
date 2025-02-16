//
//  CoordinateRequest.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

struct CoordinateRequest: Request {
    typealias E = CoordinateResponseModel

    let method: HTTPMethod = .get
}
