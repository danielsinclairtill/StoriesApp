//
//  StoriesSwiftUI_MVVM_CombineApp.swift
//  StoriesSwiftUI-MVVM-Combine
//
//  Created by Daniel Till on 2024-01-24.
//

import SwiftUI

@main
struct StoriesSwiftUI_MVVM_CombineApp: App {
    @StateObject var environment = StoriesSwiftUIEnvironment()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(environment)
        }
    }
}

class StoriesSwiftUIEnvironment: ObservableObject {
    let environment: any EnvironmentContract
    let design: StoriesDesign
    
    init(environment: any EnvironmentContract = StoriesEnvironment.shared,
         design: StoriesDesign = StoriesDesign.shared) {
        self.environment = environment
        self.design = design
    }
}
