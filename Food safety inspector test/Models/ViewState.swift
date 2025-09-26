//
//  ViewState.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import Foundation

// MARK: - View State
enum ViewState {
    case loading
    case loaded([FoodRecallUIModel])
    case error(APIError)
    case empty
}
