//
//  StoriesListCell.swift
//  StoriesSwiftUI
//
//
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct StoriesListCell: View {
    @EnvironmentObject var environment: StoriesSwiftUIEnvironment
    @State var story: Story
    
    var body: some View {
        HStack(spacing: 8.0) {
            WebImage(url: story.cover)
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .transition(.fade)
                .aspectRatio(2/3, contentMode: .fit)
                .frame(maxWidth: 100)
            VStack(alignment: .leading, spacing: 8.0) {
                Text(story.title ?? "...")
                    .font(environment.design.theme.attributes.fonts.primaryTitle())
                Text(story.user?.name ?? "...")
                    .font(environment.design.theme.attributes.fonts.body())
                Spacer()
            }
            Spacer()
        }
        .padding(8)
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
        .environmentObject(StoriesSwiftUIEnvironment())
        .frame(height: 180)
    }
}
