//
//  Timeline.swift
//  StoriesSwiftUI
//
//
//

import SwiftUI

struct Timeline: View {
    @StateObject var viewModel: TimelineCollectionViewModel = TimelineCollectionViewModel(environment: StoriesEnvironment.shared)
    
    var body: some View {
        Group {
            if viewModel.output.isLoading {
                Text("Loading")
            } else {
                List(viewModel.output.stories) { story in
                    TimelineCell(story: story)
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            viewModel.input.viewDidLoad.send(())
        }
    }
}

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        Timeline()
    }
}
