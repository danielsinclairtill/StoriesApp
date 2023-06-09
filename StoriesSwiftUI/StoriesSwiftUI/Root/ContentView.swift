//
//  ContentView.swift
//  StoriesSwiftUI
//
//
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @EnvironmentObject var design: StoriesDesign
    
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                Timeline()
            }
            .tabItem {
                Label("Stories", image: selection == 0 ? "Stories" : "StoriesUnselected")
            }
            .tag(0)
            NavigationView {
                Text("Settings")
            }
            .tabItem {
                Label("Settings", image: selection == 1 ? "Settings" : "SettingsUnselected")
            }
            .tag(1)
        }
        .tint(design.theme.attributes.colors.primaryFill())
    }
}

// MARK: - ViewModel
extension ContentView {
    class ViewModel: ObservableObject {
        let environment: StoriesEnvironment
        
        init(environment: StoriesEnvironment) {
            self.environment = environment
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentView.ViewModel(environment: StoriesEnvironment.shared))
            .environmentObject(StoriesDesign.shared)
    }
}
