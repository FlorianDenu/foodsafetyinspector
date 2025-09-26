//
//  FoodRecallListView.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import SwiftUI

struct FoodRecallListView: View {
    @StateObject private var viewModel = SimpleResolver.shared.resolve(FoodRecallListViewModel.self)
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationView {
        VStack(spacing: 0) {
            // Search Bar
            searchBar
            
            // Content
            contentView
        }
            .navigationTitle("Food Recalls")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Filter") {
                        showingFilterSheet = true
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Refresh") {
                        viewModel.refresh()
                    }
                }
            }
            .sheet(isPresented: $showingFilterSheet) {
                FilterView(selectedClassification: $viewModel.selectedClassification)
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search recalls...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !viewModel.searchText.isEmpty {
                Button("Clear") {
                    viewModel.clearSearch()
                }
                .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.viewState {
        case .loading:
            LoadingView()
            
        case .loaded(let recalls):
            if recalls.isEmpty {
                EmptyStateView()
            } else {
                RecallListView(recalls: recalls)
            }
            
        case .error(let error):
            ErrorView(error: error) {
                viewModel.retry()
            }
            
        case .empty:
            EmptySearchView {
                viewModel.clearSearch()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    FoodRecallListView()
}
