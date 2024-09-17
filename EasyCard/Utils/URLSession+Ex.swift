//
//  URLSession+Ex.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 17.09.24.
//

import Foundation

extension URLSession {
    func fetch<T: Decodable>(url: String, method: HTTPMethod = .GET, bodyParameters: Data? = nil, bearerToken: String? = nil) async throws -> T {
        guard let url = URL(string: url) else {
            throw CustomNetworkError.init(message: "Bad Url")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("01c50e8993b24fa5871d57fbdce233e2", forHTTPHeaderField: "X-Api-Key")
        request.setValue("*/*", forHTTPHeaderField: "accept")
        if let bodyParameters {
            request.httpBody   = bodyParameters
        }
        if let token = bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        do {
            let (data, response) = try await data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw CustomNetworkError.init(message: "Error code:  \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch {
                throw CustomNetworkError.init(message: "Decoding Error")
            }
        }
        
    }
}

struct CustomNetworkError: Error, Decodable {
    let message: String
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case OPTIONS
}
