//
//  FoodRecall.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import Foundation

// MARK: - API Response Models
struct FDAEnforcementResponse: Codable {
    let results: [FoodRecall]
}

struct FoodRecall: Codable, Identifiable {
    let id = UUID()
    let productDescription: String
    let reasonForRecall: String
    let recallInitiationDate: String
    let state: String
    let city: String
    let recallingFirm: String
    let distributionPattern: String
    let classification: String
    
    enum CodingKeys: String, CodingKey {
        case productDescription = "product_description"
        case reasonForRecall = "reason_for_recall"
        case recallInitiationDate = "recall_initiation_date"
        case state = "state"
        case city = "city"
        case recallingFirm = "recalling_firm"
        case distributionPattern = "distribution_pattern"
        case classification = "classification"
    }
}

// MARK: - Recall Classification
enum RecallClassification: String, CaseIterable {
    case classI = "Class I"
    case classII = "Class II"
    case classIII = "Class III"
    
    var description: String {
        switch self {
        case .classI:
            return "Dangerous or defective products that predictably could cause serious health problems or death"
        case .classII:
            return "Products that might cause a temporary health problem, or pose only a slight threat of a serious nature"
        case .classIII:
            return "Products that are unlikely to cause any adverse health reaction"
        }
    }
}

// MARK: - Extensions
extension FoodRecall {    
    var recallClassification: RecallClassification {
        switch classification.lowercased() {
        case "class i":
            return .classI
        case "class ii":
            return .classII
        default: 
            return .classIII
        }
    }
}
