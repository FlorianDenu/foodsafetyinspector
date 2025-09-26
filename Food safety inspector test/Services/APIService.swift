//
//  APIService.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import Foundation
import Combine

// MARK: - API Service Protocol
protocol APIServiceProtocol {
    func fetchFoodRecalls(limit: Int) -> AnyPublisher<FDAEnforcementResponse, APIError>
}

// MARK: - API Error
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case rateLimitExceeded
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - FDA API Service
class FDAApiService: APIServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let baseURL = APIConfiguration.baseURL
    
    init(session: URLSession, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchFoodRecalls(limit: Int = APIConfiguration.defaultLimit) -> AnyPublisher<FDAEnforcementResponse, APIError> {
        guard let url = URL(string: "\(baseURL)?limit=\(limit)") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FDAEnforcementResponse.self, decoder: decoder)
            .mapError { error in
                if error is DecodingError {
                    return APIError.decodingError
                } else if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet, .networkConnectionLost:
                        return APIError.networkError(error)
                    case .timedOut:
                        return APIError.networkError(error)
                    default:
                        return APIError.networkError(error)
                    }
                } else {
                    return APIError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
