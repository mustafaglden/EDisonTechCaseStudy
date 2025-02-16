//
//  Request.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

import Foundation

protocol Request<E> {
    associatedtype E: Decodable

    var method: HTTPMethod { get }
    
    var params: [String: String] { get }
    
    var headers: [String: Any] { get }
}

extension Request {
    var headers: [String: Any] {
        [:]
    }
    
    var params: [String: String] {
        [:]
    }
}
