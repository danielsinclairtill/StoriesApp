//
//  StoriesSwiftUIApp.swift
//  StoriesSwiftUI
//
//  Created by Daniel Till on 2023-03-23.
//

import SwiftUI

@main
struct StoriesSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentView.ViewModel(environment: StoriesEnvironment.shared))
                .environmentObject(StoriesDesign.shared)
        }
    }
}
