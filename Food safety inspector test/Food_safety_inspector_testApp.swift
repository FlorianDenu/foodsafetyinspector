//
//  Food_safety_inspector_testApp.swift
//  Food safety inspector test
//
//  Created by Florian Denu pro on 2025-09-26.
//

import SwiftUI

@main
struct Food_safety_inspector_testApp: App {
    init() {
        // Register all dependencies
        SimpleResolver.registerAllServices()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
