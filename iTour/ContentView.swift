//
//  ContentView.swift
//  iTour
//
//  Created by Weerawut Chaiyasomboon on 03/04/2568.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var sortOrder = SortDescriptor(\Destination.name)
    
    @State private var path = [Destination]()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            DestinationListingView(sort: sortOrder, searchText: searchText)
                .navigationTitle("iTour")
                .toolbar {
                    Button(action: addDestination) {
                        Image(systemName: "plus")
                    }
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort Order", selection: $sortOrder) {
                            Text("Name")
                                .tag(SortDescriptor(\Destination.name))
                            Text("Priority")
                                .tag(SortDescriptor(\Destination.priority, order: .reverse))
                            Text("Date")
                                .tag(SortDescriptor(\Destination.date))
                        }
                        .pickerStyle(.inline)
                    }
                }
                .navigationDestination(for: Destination.self) { destination in
                    EditDestinationView(destination: destination)
                }
                .searchable(text: $searchText, prompt: "By name")
        }
    }
    
    private func addDestination() {
        let destination = Destination()
        modelContext.insert(destination)
        path = [destination]
    }
    
}

#Preview {
    ContentView()
        .modelContainer(Destination.previewContainer)
}


//@Query is really smart: it will load all the destinations immediately when the view appears, but it will also watch the database for changes so that whenever any Destination object gets added, deleted, or changed, the destinations property will also be updated.

//When we used the modelContainer() modifier earlier that also created a model context for us, and placed that context into SwiftUI’s environment for us to use. This automatic model context always runs on Swift’s main actor, so it’s safe to use from our user interface.

//This autosave behavior is enabled by default: as soon as our button code finishes executing SwiftData will save all our changes to its permanent storage, so our data is always safe.
