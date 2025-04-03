//
//  DestinationListingView.swift
//  iTour
//
//  Created by Weerawut Chaiyasomboon on 03/04/2568.
//

import SwiftUI
import SwiftData

struct DestinationListingView: View {
    @Query var destinations: [Destination]
    @Environment(\.modelContext) var modelContext
    
    init(sort: SortDescriptor<Destination>, searchText: String) {
        _destinations = Query(filter: #Predicate {
            if searchText.isEmpty {
                return true
            } else {
                return $0.name.localizedStandardContains(searchText)
            }
        }, sort: [sort])
    }
    
    var body: some View {
        List(destinations) { destination in
            NavigationLink(value: destination) {
                VStack(alignment: .leading) {
                    Text(destination.name)
                        .font(.headline)
                    Text(destination.date.formatted(date: .long, time: .shortened))
                }
            }
            .swipeActions {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    modelContext.delete(destination)
                }
            }
            
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        DestinationListingView(sort: SortDescriptor(\Destination.name), searchText: "")
            .modelContainer(Destination.previewContainer)
    }
}
