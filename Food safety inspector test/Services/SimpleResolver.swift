//
//  SimpleResolver.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import Foundation

// MARK: - Simple Resolver Implementation
class SimpleResolver {
    static let shared = SimpleResolver()
    private var services: [String: Any] = [:]
    
    private init() {}
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        services[key] = factory
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let factory = services[key] as? () -> T else {
            fatalError("Service \(type) not registered")
        }
        return factory()
    }
    
    func resolveAsync<T>(_ type: T.Type) async -> T {
        let key = String(describing: type)
        guard let factory = services[key] as? () async -> T else {
            fatalError("Service \(type) not registered")
        }
        return await factory()
    }
}

// MARK: - Resolver Configuration
extension SimpleResolver {
    static func registerAllServices() {
        let resolver = SimpleResolver.shared
        
        // JSON Decoder
        resolver.register(JSONDecoder.self) {
            let decoder = JSONDecoder()
            // No key decoding strategy needed since we use custom CodingKeys
            return decoder
        }
        
        // URL Session
        resolver.register(URLSession.self) {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = APIConfiguration.requestTimeout
            config.timeoutIntervalForResource = APIConfiguration.resourceTimeout
            return URLSession(configuration: config)
        }
        
        // API Service
        resolver.register(APIServiceProtocol.self) {
            FDAApiService(
                session: resolver.resolve(URLSession.self),
                decoder: resolver.resolve(JSONDecoder.self)
            )
        }
        
        // Repository
        resolver.register(FoodRecallRepositoryProtocol.self) {
            FoodRecallRepository(
                apiService: resolver.resolve(APIServiceProtocol.self),
                decoder: resolver.resolve(JSONDecoder.self)
            )
        }
        
        // ViewModel
        resolver.register(FoodRecallListViewModel.self) {
            FoodRecallListViewModel(
                repository: resolver.resolve(FoodRecallRepositoryProtocol.self),
                decoder: resolver.resolve(JSONDecoder.self)
            )
        }
    }
}
