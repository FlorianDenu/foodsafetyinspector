//
//  APIConfiguration.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import Foundation

// MARK: - API Configuration
struct APIConfiguration {
    // MARK: - Base URLs
    static let baseURL = "https://api.fda.gov/food/enforcement.json"
    
    // MARK: - Timeouts
    static let requestTimeout: TimeInterval = 30.0
    static let resourceTimeout: TimeInterval = 60.0
    
    // MARK: - Limits
    static let defaultLimit = 60
    static let maxLimit = 100
    
    // MARK: - Retry Configuration
    static let maxRetries = 3
    static let retryDelay: TimeInterval = 1.0
    
    // MARK: - Cache Configuration
    static let cacheExpirationTime: TimeInterval = 300.0 // 5 minutes
    static let maxCacheSize = 10
}

