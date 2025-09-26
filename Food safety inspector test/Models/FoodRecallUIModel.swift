//
//  FoodRecallUIModel.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import Foundation
import SwiftUI

// MARK: - UI Model for Food Recall
struct FoodRecallUIModel: Identifiable, Hashable {
    let id = UUID()
    let productDescription: String
    let reasonForRecall: String
    let formattedDate: String
    let location: String
    let recallingFirm: String
    let distributionPattern: String
    let classification: RecallClassificationUI
    let severityLevel: SeverityLevel
    let displayPriority: Int // For sorting (Class I = 1, Class II = 2, Class III = 3, Unknown = 4)
    
    // MARK: - Initializer from API Model
    init(from apiModel: FoodRecall) {
        self.productDescription = apiModel.productDescription
        self.reasonForRecall = apiModel.reasonForRecall
        self.formattedDate = apiModel.recallInitiationDate
        self.location = "\(apiModel.city), \(apiModel.state)"
        self.recallingFirm = apiModel.recallingFirm
        self.distributionPattern = apiModel.distributionPattern
        self.classification = RecallClassificationUI.from(apiModel.recallClassification)
        self.severityLevel = SeverityLevel.from(apiModel.recallClassification)
        self.displayPriority = Self.calculatePriority(for: apiModel.recallClassification)
    }
    
    // MARK: - Helper Methods
    private static func calculatePriority(for classification: RecallClassification) -> Int {
        switch classification {
        case .classI: return 1
        case .classII: return 2
        case .classIII: return 3
        }
    }
    
    // MARK: - Search Helper
    func matchesSearch(_ searchText: String) -> Bool {
        let searchLower = searchText.lowercased()
        return productDescription.lowercased().contains(searchLower) ||
               reasonForRecall.lowercased().contains(searchLower) ||
               recallingFirm.lowercased().contains(searchLower) ||
               location.lowercased().contains(searchLower) ||
               distributionPattern.lowercased().contains(searchLower)
    }
}

// MARK: - UI-Optimized Classification
enum RecallClassificationUI: String, CaseIterable, Identifiable {
    case classI = "Class I"
    case classII = "Class II"
    case classIII = "Class III"
    case unknown = "Unknown"
    
    var id: String { rawValue }
    
    // MARK: - Visual Properties
    var color: Color {
        switch self {
        case .classI: return .red
        case .classII: return .orange
        case .classIII: return .yellow
        case .unknown: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .classI: return "exclamationmark.triangle.fill"
        case .classII: return "exclamationmark.triangle"
        case .classIII: return "info.circle"
        case .unknown: return "questionmark.circle"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .classI: return "High Risk"
        case .classII: return "Moderate Risk"
        case .classIII: return "Low Risk"
        case .unknown: return "Unknown Risk"
        }
    }
    
    var fullDescription: String {
        switch self {
        case .classI:
            return "Dangerous or defective products that predictably could cause serious health problems or death"
        case .classII:
            return "Products that might cause a temporary health problem, or pose only a slight threat of a serious nature"
        case .classIII:
            return "Products that are unlikely to cause any adverse health reaction, but violate FDA labeling or manufacturing laws"
        case .unknown:
            return "Classification not available"
        }
    }
    
    // MARK: - Conversion from API Model
    static func from(_ apiClassification: RecallClassification) -> RecallClassificationUI {
        switch apiClassification {
        case .classI: return .classI
        case .classII: return .classII
        case .classIII: return .classIII
        }
    }
}

// MARK: - Severity Level for UI Logic
enum SeverityLevel: Int, CaseIterable {
    case critical = 1
    case high = 2
    case medium = 3
    case low = 4
    case unknown = 5
    
    var displayName: String {
        switch self {
        case .critical: return "Critical"
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        case .unknown: return "Unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .critical: return .red
        case .high: return .orange
        case .medium: return .yellow
        case .low: return .green
        case .unknown: return .gray
        }
    }
    
    static func from(_ classification: RecallClassification) -> SeverityLevel {
        switch classification {
        case .classI: return .critical
        case .classII: return .high
        case .classIII: return .medium
        }
    }
}

// MARK: - UI Model Extensions
extension FoodRecallUIModel {
    // MARK: - Display Helpers
    var isHighPriority: Bool {
        return severityLevel == .critical || severityLevel == .high
    }
    
    var shouldShowWarning: Bool {
        return classification == .classI || classification == .classII
    }
    
    var displayTitle: String {
        return productDescription
    }
    
    var displaySubtitle: String {
        return "\(recallingFirm) • \(location)"
    }
    
    var displayDate: String {
        return formattedDate
    }
    
    // MARK: - Filtering Helpers
    func matchesClassification(_ filter: RecallClassificationUI?) -> Bool {
        guard let filter = filter else { return true }
        return classification == filter
    }
    
    func matchesSeverity(_ severity: SeverityLevel?) -> Bool {
        guard let severity = severity else { return true }
        return severityLevel == severity
    }
}

// MARK: - Sorting Helpers
extension FoodRecallUIModel {
    static func sortByPriority(_ recalls: [FoodRecallUIModel]) -> [FoodRecallUIModel] {
        return recalls.sorted { $0.displayPriority < $1.displayPriority }
    }
    
    static func sortByDate(_ recalls: [FoodRecallUIModel]) -> [FoodRecallUIModel] {
        return recalls.sorted { $0.formattedDate > $1.formattedDate }
    }
    
    static func sortByFirm(_ recalls: [FoodRecallUIModel]) -> [FoodRecallUIModel] {
        return recalls.sorted { $0.recallingFirm < $1.recallingFirm }
    }
}
