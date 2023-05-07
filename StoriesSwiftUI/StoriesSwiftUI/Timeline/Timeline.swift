//
//  Timeline.swift
//  StoriesSwiftUI
//
//  Created by Daniel Till on 2023-04-09.
//

import SwiftUI

struct Timeline: View {
    @ObservedObject var viewModel: TimelineCollectionViewModel = TimelineCollectionViewModel(environment: StoriesEnvironment.shared)
    
    var body: some View {
        Group {
            if viewModel.output.isLoading {
                Text("Loading")
            } else {
                List(viewModel.output.stories) { story in
                    Text(story.title ?? "")
                }
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
