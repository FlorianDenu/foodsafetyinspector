//
//  FoodRecallListViewModel.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Sort Options
enum SortOption: String, CaseIterable {
    case priority = "Priority"
    case date = "Date"
    case firm = "Firm"
}

// MARK: - View State
enum ViewState {
    case loading
    case loaded([FoodRecallUIModel])
    case error(APIError)
    case empty
}

// MARK: - Food Recall List ViewModel
class FoodRecallListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var viewState: ViewState = .loading
    @Published var searchText: String = ""
    @Published var selectedClassification: RecallClassificationUI? = nil
    @Published var selectedSeverity: SeverityLevel? = nil
    @Published var sortOption: SortOption = .priority
    
    // MARK: - Private Properties
    private let repository: FoodRecallRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var allRecalls: [FoodRecallUIModel] = []
    
    // MARK: - Computed Properties
    var filteredRecalls: [FoodRecallUIModel] {
        var filtered = allRecalls
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.matchesSearch(searchText) }
        }
        
        // Filter by classification
        if let selectedClassification = selectedClassification {
            filtered = filtered.filter { $0.matchesClassification(selectedClassification) }
        }
        
        // Filter by severity
        if let selectedSeverity = selectedSeverity {
            filtered = filtered.filter { $0.matchesSeverity(selectedSeverity) }
        }
        
        // Apply sorting
        return applySorting(to: filtered)
    }
    
    private func applySorting(to recalls: [FoodRecallUIModel]) -> [FoodRecallUIModel] {
        switch sortOption {
        case .priority:
            return FoodRecallUIModel.sortByPriority(recalls)
        case .date:
            return FoodRecallUIModel.sortByDate(recalls)
        case .firm:
            return FoodRecallUIModel.sortByFirm(recalls)
        }
    }
    
    var isLoading: Bool {
        if case .loading = viewState {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case .error(let error) = viewState {
            return error.localizedDescription
        }
        return nil
    }
    
    // MARK: - Initialization
    init(repository: FoodRecallRepositoryProtocol, decoder: JSONDecoder) {
        self.repository = repository
        setupBindings()
        loadRecalls()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Update filtered results when search text, classification, severity, or sort option changes
        Publishers.CombineLatest4($searchText, $selectedClassification, $selectedSeverity, $sortOption)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateFilteredResults()
            }
            .store(in: &cancellables)
    }
    
        private func loadRecalls() {
            viewState = .loading
            
            repository.fetchRecentRecalls()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        if case .failure(let error) = completion {
                            self?.viewState = .error(error)
                        }
                    }
                },
                receiveValue: { [weak self] recalls in
                    DispatchQueue.main.async {
                        self?.allRecalls = recalls
                        self?.updateFilteredResults()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func updateFilteredResults() {
        let filtered = filteredRecalls
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if filtered.isEmpty && !self.allRecalls.isEmpty {
                self.viewState = .empty
            } else {
                self.viewState = .loaded(filtered)
            }
        }
    }
    
    // MARK: - Public Methods
    func refresh() {
        loadRecalls()
    }
    
    func clearSearch() {
        DispatchQueue.main.async { [weak self] in
            self?.searchText = ""
            self?.selectedClassification = nil
            self?.selectedSeverity = nil
        }
    }
    
    func selectClassification(_ classification: RecallClassificationUI?) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedClassification = classification
        }
    }
    
    func selectSeverity(_ severity: SeverityLevel?) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedSeverity = severity
        }
    }
    
    func setSortOption(_ option: SortOption) {
        DispatchQueue.main.async { [weak self] in
            self?.sortOption = option
        }
    }
    
    func retry() {
        loadRecalls()
    }
}
