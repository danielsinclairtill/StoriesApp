//
//  StoriesStoreConverter.swift
//  Stories
//
//
//
//

import Foundation
import CoreData

class StoriesStoreConverter {
    // MARK: Story
    func convertAndCreate(story: Story, context: NSManagedObjectContext) -> StoryCD {
        let storyCD = StoryCD(context: context)
        storyCD.id = story.id
        storyCD.title = story.title
        storyCD.cover = story.cover?.absoluteString

        if let user = story.user {
            let user = convertAndCreate(user: user, context: context)
            storyCD.user = user
        } else {
            storyCD.user = nil
        }

        return storyCD
    }

    func convert(storyCD: StoryCD) -> Story {
        var user: User? = nil
        if let userCD = storyCD.user {
            user = convert(userCD: userCD)
        }
        var cover: URL? = nil
        if let coverURLString = storyCD.cover {
            cover = URL(string: coverURLString)
        }

        return Story(id: storyCD.id,
                     title: storyCD.title,
                     user: user,
                     cover: cover,
                     description: nil,
                     tags: nil)
    }
    
    // MARK: User
    func convertAndCreate(user: User, context: NSManagedObjectContext) -> UserCD {
        let userCD = UserCD(context: context)
        userCD.name = user.name
        userCD.avatar = user.avatar?.absoluteString
        userCD.fullName = user.fullname
        
        return userCD
    }

    func convert(userCD: UserCD) -> User {
        var avatar: URL? = nil
        if let avatarURLString = userCD.avatar {
            avatar = URL(string: avatarURLString)
        }

        return User(name: userCD.name,
                    avatar: avatar,
                    fullname: userCD.fullName)
    }
}
