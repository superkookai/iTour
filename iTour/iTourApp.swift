//
//  iTourApp.swift
//  iTour
//
//  Created by Weerawut Chaiyasomboon on 03/04/2568.
//

import SwiftUI
import SwiftData

@main
struct iTourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Destination.self)
    }
}

//SwiftData model objects automatically conform to the Identifiable protocol

//SwiftData has three important classes with similar names but very different functionality:
//
//ModelContainer is responsible for creating and managing the actual database file used for all SwiftData’s storage needs.
//ModelContext has the job of tracking all objects that have been created, modified, and deleted in memory, so they can all be saved to the model container at some later point.
//ModelConfiguration determines how and where data is stored, including which CloudKit container to use if any, and whether saving should be enabled or not. This configuration is provided to your model container to determine how it behaves.


//.modelContainer(for: YourModel.self)
//That also creates a model context for us called the main context, and it places that context into SwiftUI’s environment for us to use. This main context always runs on Swift’s main actor, so it’s safe to use from our user interface.
//@Environment(\.modelContext) var modelContext
//This same context is automatically used by @Query in your SwiftUI views.

//Important: Irrespective of which set of configurations you use, you must still make sure you send the full list of model types to your ModelContainer initializer, either explicitly by listing them all or implicitly through relationships.

//Important: SwiftData models with relationships must be part of the same store. For example, if a User model has a relationship with a Recipe model, SwiftData will not let you create a configuration for one that excludes the other – even if you exclude one, it will implicitly be added by SwiftData. To be clear, relationships cannot span multiple SwiftData stores.

//SwiftData automatically saves all our changes effectively immediately – it's so fast the chance of any data loss is effectively zero. Exactly when it happens is an implementation detail, but from what I can tell it's in the following circumstances:
//
//Every time the app goes to the background
//Every time the app moves back to the foreground
//Every time the current runloop ends

//If you decide autosave isn't suitable for your project, you can disable it either when creating your own custom model container, or by adjusting the autosaveEnabled property for an existing model context. Once that's done, call save() manually at whatever points you think work best for you.

//If you’re making a new context by hand, autosave is usually automatically disabled. You can enable it by adjust its autosaveEnabled Boolean

//You’ll use the @Model macro with all your SwiftData model classes. It automatically makes your class load and store from SwiftData, adds support for observing changes, and also adds conformances for Hashable, Identifiable, Observable, and PersistentModel.

//Important: The @Model macro requires your type be a class; it will not work on a struct.

//Any computed properties aren’t affected by the macro, and won’t be stored inside SwiftData persistent storage.

//Another way we can add to our models is to add special attributes to individual properties. For example, we could say that every employee must have a unique email address:
//@Attribute(.unique) var emailAddress: String
//SwiftData will enforce this rule for us automatically, ensuring that no two users have the same email address.

//you can integrate structs into your models if you want, as long as the structs conform to Codable, but recommend to use @Model class instead of struct

//SwiftData is capable of storing a variety of data, but specifically the following:
//
//Any class that uses the @Model macro.
//Any struct that conforms to the Codable protocol.
//Any enum that conforms to the Codable protocol, even if it includes raw values or associated values.

//Use the @Attribute(.unique) macro to mark properties as being unique in your model, meaning that SwiftData will not allow more than one object with that value.
//So, using our credit card example the following might happen:
//
//We create a new credit card using the number 1234.
//We set the balance that to be $1000.
//We create a second credit card using the number 1234.
//We set the balance of that to be $0.
//SwiftData will not allow us to have two credit cards with the same number, because we marked that attribute as unique, so instead when that code finishes we’ll have just one card with a balance of $0 – the most recent value.

//SwiftData automatically saves all stored property into its data storage. If you don’t want that – if you have temporary data that is needed only while your program is running – then you can mark it using the @Transient macro so that SwiftData treats it as ephemeral and disposable, so it won’t be saved along with the rest of your data.
//@Transient var levelsPlayed = 0
//That starts with a default value of 0 when your app runs, and will automatically reset to 0 when the app terminates – it won’t be stored inside SwiftData.

//There are two important things to remember when working with transient properties in SwiftData:
//
//Transient properties cannot be used in SwiftData query predicates because the actual data you’re working with doesn’t exist on disk. Attempting to use a transient property will compile just fine, but crash at runtime.
//Transient properties must always have a default value as shown above, so that when you create a new object or when an existing one is fetched from disk, there’s always a value present.

//@Attribute(.externalStorage, .allowsCloudEncryption) var avatar: Data
//SwiftData is great for storing information such as strings, integers, dates, and custom Codable objects, but if you’re storing larger data such as images or even movies it’s a good idea to have SwiftData store them in external, peripheral files, then reference those filenames in your SwiftData object.

//I always prefer to spell out what I mean rather than relying on SwiftData’s inference getting it right.
//@Relationship(deleteRule: .cascade, inverse: \Student.school) var students: [Student]

//Swift requires that we declare one-to-one relationships as zero-to-one, even if they will never actually be zero-to-one. This is a simple fact of coding: if we try to make both properties non-optional, then we have a tortoise-and-hare problem where we can’t create one without creating the other first.
//Important: Don’t try to insert both the city and country objects – inserting one automatically inserts the other because the two have a relationship, and in fact trying to insert them both is likely to throw up a fatal error with the message, “Duplicate registration attempt for object”

//Important: There are a handful of rules you need to follow with these relationships:
//
//If you intend to use inferred relationships, one side of your data must be optional.
//If you use an explicit relationship where one side of your data is non-optional, be careful how you delete objects – SwiftData uses the .nullify delete rule by default, which can put your data into in an invalid state. To avoid this problem, either use an option value, or use a .cascade delete rule.
//Do not attempt to use collection types other than Array, because your code will simply not compile.

//Important: SwiftData will not infer many-to-many relationships; you must make them explicit using the @Relationship macro

//SwiftData’s default delete rule for relationships is .nullify, which means for example that if you have an School object with many Student objects as a relationship, then deleting the school will leave the students intact in your data store. That might make sense in some places, but you can also specify a .cascade delete rule, meaning that all related objects will be deleted when the parent object is deleted.

//SwiftData’s @Relationship macro allows us to specify minimum and maximum number of objects that should exist in a one-to-many or many-to-many connection.
//
//Important: If you step outside these limits SwiftData's autosave will silently fail and your data may be lost unless you correct it.

//If you use an array on one side of your relationship and an optional on the other, SwiftData will correctly infer the relationship and keep both sides in sync even without calling save() on the context.
//If you use a non-optional on the other side, you must specify the delete rule manually and call save() when inserting the data, otherwise SwiftData won’t refresh the relationship until application is relaunched – even if you call save() at a later date, and even if you create and run a new FetchDescriptor from scratch.

//Important: Calling delete() marks your object for deletion, but doesn’t actually complete the deletion until a save happens. Between those two states your object is stored in the deletedModelsArray of your property, and if the deletion is rolled back the object will be moved back from deletedModelsArray to your live data. Alternatively, if you have autosave disabled and don’t call save() manually, your deletions will automatically be rolled back.

//If you’re deleting an object that has relationships, SwiftData will act on those relationships as part of the deletion – that’s the .nullify delete rule by default, but you might also have requested .cascade or one of the others. If you have a cascade delete in place, SwiftData will automatically continue the cascade down through all objects in a chain: deleting a School might delete all its students, and deleting students might delete all their exam results, for example

//SwiftData’s FetchDescriptor struct is similar to Core Data’s NSFetchRequest, allowing us to fetch a particular set of objects by specifying a model type, predicate, and sort order. However, it also gives us precise control over what’s fetched: you can set a limit of objects to fetch, prefetch relationships, and more.

//FetchDescriptor<Movie>() >> SortDescriptor, #Predicate, fetchLimit, fetchOffset, propertiesToFetch, relationshipKeyPathsForPrefetching, includePendingChanges

//SwiftData’s #Predicate macro lets us filter a wide variety of operations: data loaded through @Query, custom FetchDescriptor configurations, and also deleting lots of model objects using delete(model:) on a model context. All work in exactly the same way: we’re given one object of our model type, and need to return true or false depending on whether that object should be in the final results.

//Sorting SwiftData queries is either done with a key path for simple sorts, or an array of SortDescriptor for more complex sorts.
//To get more advanced sorting, you can specify an array of SortDescriptor. This approach works much the same with both @Query and FetchDescriptor, which does make life a little easier. The advantage of this approach is that you can specify multiple sort orders to have them applied in order: if the first two fields sort the same for two objects, then they are sorted by the second field, then the third, and so on
//@Query(sort: [SortDescriptor(\User.name, comparator: .localizedStandard)]) var users: [User]

//fetchCount() method of your model context. This returns how many objects matches your predicate without loading those objects into memory, which means it executes several orders of magnitude faster and uses almost no memory. In contrast, using a regular fetch then performing a count loads all the objects into memory for no real reason.

//SwiftData’s ModelContext class has a dedicated delete(model:) method that removes from your context all instances of a particular model. Once a save is triggered, either manually or using autosave, the objects will be deleted from disk too.
//If you want only some of your model instances to be deleted, provide a predicate to the where parameter like this. For example, if we wanted to delete all schools that don’t have any active students, we’d write this:
//try modelContext.delete(model: School.self, where: #Predicate { $0.students.isEmpty })

//It is startlingly easy to add undo and redo support to SwiftData, and really it takes just two steps: enabling undo, then calling undo either through the SwiftUI environment or through your model context’s own undo manager.

//SwiftData’s model context has a dedicated enumerate() method that is designed to traverse large amounts of data efficiently.

//You can make any SwiftData model Codable, but you need to add the conformance by hand. If your model has relationships that you want to be encoded and decoded, those relationships must also conform to Codable.





