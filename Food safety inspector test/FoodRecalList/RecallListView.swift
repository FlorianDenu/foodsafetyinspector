//
//  RecallListView.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import SwiftUI

struct RecallListView: View {
    let recalls: [FoodRecallUIModel]
    
    var body: some View {
        List(recalls) { recall in
            RecallRowView(recall: recall)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(PlainListStyle())
    }
}

// MARK: - Recall Row View
struct RecallRowView: View {
    let recall: FoodRecallUIModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header with classification indicator
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recall.displayTitle)
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    Text(recall.displaySubtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ClassificationIndicator(classification: recall.classification)
            }
            
            // Recall reason
            Text(recall.reasonForRecall)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(3)
            
            // Footer with date and location
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(recall.displayDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(recall.location)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Classification Indicator
struct ClassificationIndicator: View {
    let classification: RecallClassificationUI
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: classification.icon)
                .font(.title2)
                .foregroundColor(classification.color)
            
            Text(classification.rawValue)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(classification.color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(classification.color.opacity(0.1))
        )
    }
}
