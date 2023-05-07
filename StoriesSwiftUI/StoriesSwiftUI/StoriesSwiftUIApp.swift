//
//  StoriesSwiftUIApp.swift
//  StoriesSwiftUI
//
//
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
