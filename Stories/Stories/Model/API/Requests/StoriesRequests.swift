//
//  StoriesRequests.swift
//  Stories
//
//
//
//

import Foundation

public struct StoriesRequests {
    /**
     Retrieves a page of list of stories to display on the 'Stories' timeline.

     - Response:
        - stories: list of stories
        - nextUrl: next URL  to use for paginated results
     */
    public struct StoriesTimelinePage: APIRequestContract {
        /// Retrieves the next page of stories to display on the 'Stories' timeline.
        /// - Parameter offset: the offset that is the starting index of the next page
        init(offset: Int = 0) {
            parameters?.updateValue(String(offset), forKey: "offset")
        }
        
        public let path: String = "stories"
        public var parameters: [String : String]? = [
            "offset": "0",
            "limit": "10",
            "fields": "stories(id,title,cover,user,description,tags)",
            "filter": "new",
        ]
        public var timeoutInterval: TimeInterval = 10
        
        public struct Response: Decodable {
            public let stories: [Story]
            public let nextUrl: URL
        }
    }
    
    /**
     Retrieves the details of a story.

     - Response: Story object
     */
    public struct StoryDetail: APIRequestContract {
        /// Retrieves the details of a story.
        /// - Parameter id: the unqiue id of the story
        init(id: String) {
            parameters?.updateValue(id, forKey: "id")
            path = "stories/\(id)"
        }
        
        public var path: String
        public var parameters: [String : String]? = [
            "fields": "id,title,cover,user,description,tags",
        ]
        public var timeoutInterval: TimeInterval = 10
        
        public typealias Response = Story
    }
}
