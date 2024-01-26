//
//  ContentView.swift
//  StoriesSwiftUI
//
//
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var environment: StoriesSwiftUIEnvironment
    
    @State private var selection = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                StoriesList(viewModel: StoriesListViewModel(environment: environment.environment))
                .tabItem {
                    Label("Stories", image: selection == 0 ? "Stories" : "StoriesUnselected")
                }
                .tag(0)
                Text("Settings")
                .tabItem {
                    Label("Settings", image: selection == 1 ? "Settings" : "SettingsUnselected")
                }
                .tag(1)
            }
            .tint(environment.design.theme.attributes.colors.primaryFill())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var environment = StoriesSwiftUIEnvironment()
    
    static var previews: some View {
        ContentView()
            .environmentObject(ContentView_Previews.environment)
    }
}
