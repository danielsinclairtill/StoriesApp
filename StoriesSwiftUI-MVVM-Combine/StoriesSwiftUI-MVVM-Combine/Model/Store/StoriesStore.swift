//
//  StoriesStore.swift
//  Stories
//
//
//
//

import Foundation
import CoreData

enum Enitity: String {
    case StoryCD
    case UserCD
}

class StoriesStore: StoreContract {
    private let container: NSPersistentContainer
    private let converter: StoriesStoreConverter

    init(container: NSPersistentContainer,
         converter: StoriesStoreConverter = StoriesStoreConverter()) {
        self.container = container
        // merge changes from parent for async store processes to work correctly
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.converter = converter
    }

    func getStories(success: (([Story]) -> Void)?, failure: ((StoreError) -> Void)?) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Enitity.StoryCD.rawValue)
        // sort by position placed on timeline
        let sortDescriptor = NSSortDescriptor(key: #keyPath(StoryCD.position), ascending: true)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors

        // perform store read on asynchronous thread, completion is called on main thread
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { [weak self] results in
            guard let strongSelf = self else { fatalError("Could not find store class...") }
            if let results = results.finalResult {
                guard let storiesCD = results as? [StoryCD] else {
                    failure?(StoreError.readError)
                    return
                }
                let stories: [Story] = storiesCD.map { strongSelf.converter.convert(storyCD: $0) }
                success?(stories)
            }
        }
        do {
            try container.viewContext.execute(asyncRequest)
        } catch {
            failure?(StoreError.readError)
        }
    }
    
    func storeStories(_ stories: [Story], success: ((Bool) -> Void)?, failure: ((StoreError) -> Void)?) {
        // perform store write on asynchronous thread
        container.performBackgroundTask { [weak self] context in
            guard let strongSelf = self else {
                fatalError("Could not find persistent container...")
            }
            guard let url = context.persistentStoreCoordinator?.persistentStores.first?.url else {
                fatalError("Could not find persistent store for Stories Core Data...")
            }
            
            // wipe previous data
            do {
                try context.persistentStoreCoordinator?.destroyPersistentStore(at:url,
                                                                               ofType: NSSQLiteStoreType,
                                                                               options: nil)
                try context.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                           configurationName: nil,
                                                                           at: url,
                                                                           options: nil)
            } catch {
                // call on main thread
                DispatchQueue.main.async {
                    failure?(StoreError.writeError)
                }
            }
            
            // store stories
            stories.enumerated().forEach { (position, story) -> Void in
                let storyCD = strongSelf.converter.convertAndCreate(story: story, context: context)
                storyCD.position = Int32(position)
            }

            do {
                try context.save()
                // call on main thread
                DispatchQueue.main.async {
                    success?(true)
                }
            } catch {
                DispatchQueue.main.async {
                    failure?(StoreError.writeError)
                }
            }
        }
    }
}
