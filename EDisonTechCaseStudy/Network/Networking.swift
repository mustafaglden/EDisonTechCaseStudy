//
//  Networking.swift
//  EDisonTechCaseStudy
//
//  Created by Mustafa on 15.02.2025.
//

import Foundation

final class Networking: NetworkManager {
    func makeRequest<T: Request>(_ request: T) async throws -> T.E {
        let url = URL(string: "\(API.baseUrl)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        addParameters(to: &urlRequest, using: request.params)
        addHeaders(to: &urlRequest, using: request.headers)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        logResponse(data: data)
        let decodedModel = try JSONDecoder().decode(T.E.self, from: data)
        return decodedModel
    }
    
    private func addParameters(to urlRequest: inout URLRequest, using params: [String: String]) {
        urlRequest.httpBody = params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
    }
    
    private func addHeaders(
        to urlRequest: inout URLRequest,
        using headers: [String: Any]
    ) {
        for header in headers {
            urlRequest.setValue(header.value as? String, forHTTPHeaderField: header.key)
        }
    }
    
    private func logResponse(data: Data) {
        print(data.prettyPrintedJSONString ?? "")
    }
}
