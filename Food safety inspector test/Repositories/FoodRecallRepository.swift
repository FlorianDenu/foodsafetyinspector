//
//  FoodRecallRepository.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import Foundation
import Combine

// MARK: - Repository Protocol
protocol FoodRecallRepositoryProtocol {
    func fetchRecentRecalls() -> AnyPublisher<[FoodRecallUIModel], APIError>
    func fetchRecalls(limit: Int) -> AnyPublisher<[FoodRecallUIModel], APIError>
}

// MARK: - Food Recall Repository
class FoodRecallRepository: FoodRecallRepositoryProtocol {
    private let apiService: APIServiceProtocol
    private let decoder: JSONDecoder
    private let cache = NSCache<NSString, NSArray>()
    
    init(apiService: APIServiceProtocol, decoder: JSONDecoder) {
        self.apiService = apiService
        self.decoder = decoder
        setupCache()
    }
    
    private func setupCache() {
        cache.countLimit = APIConfiguration.maxCacheSize
    }
    
    func fetchRecentRecalls() -> AnyPublisher<[FoodRecallUIModel], APIError> {
        return fetchRecalls(limit: APIConfiguration.defaultLimit)
    }
    
    func fetchRecalls(limit: Int) -> AnyPublisher<[FoodRecallUIModel], APIError> {
        let cacheKey = "recalls_\(limit)" as NSString
        
        // Check cache first
        if let cachedRecalls = cache.object(forKey: cacheKey) as? [FoodRecallUIModel] {
            return Just(cachedRecalls)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        
        return apiService.fetchFoodRecalls(limit: limit)
            .map { response in
                let recalls = response.results.map { FoodRecallUIModel(from: $0) }
                // Cache the UI models
                self.cache.setObject(recalls as NSArray, forKey: cacheKey)
                return recalls
            }
            .eraseToAnyPublisher()
    }
}

