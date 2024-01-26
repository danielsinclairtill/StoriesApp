//
//  StoriesListCell.swift
//  StoriesSwiftUI
//
//
//

import Foundation
import SwiftUI

struct StoriesListCell: View {
    @EnvironmentObject var environment: StoriesSwiftUIEnvironment
    @State var story: Story
    
    var body: some View {
        HStack(spacing: 8.0) {
            Spacer().frame(width: 80)
            VStack(alignment: .leading, spacing: 8.0) {
                Text(story.title ?? "...")
                Text(story.user?.name ?? "...")
            }
            Spacer()
        }
    }
}

struct StoriesListCell_Previews: PreviewProvider {
    static var previews: some View {
        StoriesListCell(story: Story(id: "test",
                                     title: "Title",
                                     user: User(name: "Author",
                                                avatar: nil,
                                                fullname: nil),
                                     cover: nil,
                                     description: nil,
                                     tags: nil))
    }
}
