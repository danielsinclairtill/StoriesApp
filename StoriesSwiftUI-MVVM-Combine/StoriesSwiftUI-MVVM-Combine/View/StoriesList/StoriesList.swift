//
//  StoriesList.swift
//  StoriesSwiftUI
//
//
//

import SwiftUI

struct StoriesList: View {
    @EnvironmentObject var environment: StoriesSwiftUIEnvironment
    @StateObject var viewModel: StoriesListViewModel
    
    var body: some View {
        Group {
            if viewModel.output.isLoading {
                Text("Loading")
                    .task {
                        // wait for 2 seconds
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        viewModel.input.refresh.send()
                    }
            } else {
                List(viewModel.output.stories) { story in
                    NavigationLink(value: story) {
                        StoriesListCell(story: story)
                            .frame(height: 180)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.input.refreshBegin.send()
                }
            }
        }
        .onAppear {
            if viewModel.output.stories.isEmpty {
                viewModel.input.viewDidLoad.send(())
            }
        }
        .navigationDestination(for: Story.self) { story in
            Text("test")
        }
    }
}

struct StoriesList_Previews: PreviewProvider {
    static var previews: some View {
        StoriesList(viewModel: StoriesListViewModel(environment: StoriesEnvironment.shared))
    }
}
