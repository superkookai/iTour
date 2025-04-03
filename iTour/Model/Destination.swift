//
//  Destination.swift
//  iTour
//
//  Created by Weerawut Chaiyasomboon on 03/04/2568.
//

import Foundation
import SwiftData

@Model
class Destination {
    var name: String
    var details: String
    var date: Date
    var priority: Int
    @Relationship(deleteRule: .cascade) var sights = [Sight]()
    
    init(name: String = "", details: String = "", date: Date = .now, priority: Int = 2) {
        self.name = name
        self.details = details
        self.date = date
        self.priority = priority
    }
}

extension Destination {
    @MainActor
    static var previewContainer: ModelContainer {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Destination.self, configurations: config)
            
            let rome = Destination(name: "Rome")
            let florence = Destination(name: "Florence")
            let naples = Destination(name: "Naples")
            
            container.mainContext.insert(rome)
            container.mainContext.insert(florence)
            container.mainContext.insert(naples)
            
            return container
        } catch {
            fatalError("Failed to create model container.")
        }
    }
}

//Just adding that property that is enough to tell SwiftData that each destination has many sights associated with it. Our original model didn't have that relationship, but that's okay: the next time you run the app, SwiftData will silently upgrade its data store to take this change into account with no extra work from us. This is called a migration, and it allows us to upgrade and adjust our models over time.

//A cascade delete rule means "when we delete this object, delete all its sights too" – exactly what we want
