//
//  EditDestinationView.swift
//  iTour
//
//  Created by Weerawut Chaiyasomboon on 03/04/2568.
//

import SwiftUI
import SwiftData

struct EditDestinationView: View {
    @Bindable var destination: Destination
    @State private var newSightName: String = ""
    
    var body: some View {
        Form {
            TextField("Destination Name", text: $destination.name)
            TextField("Destination Details", text: $destination.details, axis: .vertical)
            
            Section("Priority") {
                Picker("Priority", selection: $destination.priority) {
                    Text("Meh").tag(1)
                    Text("Maybe").tag(2)
                    Text("Must").tag(3)
                }
                .pickerStyle(.segmented)
            }
            
            Section("Sights") {
                ForEach(destination.sights) { sight in
                    Text(sight.name.capitalized)
                        .swipeActions {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                guard let index = destination.sights.firstIndex(of: sight) else { return }
                                destination.sights.remove(at: index)
                            }
                        }
                }
                
                HStack {
                    TextField("Sight name", text: $newSightName)
                    
                    Button {
                        addSight()
                    } label: {
                        Text("Add")
                    }

                }
            }
        }
        .navigationTitle("Edit Destination")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addSight() {
        guard newSightName.isEmpty == false else { return }
        
        withAnimation {
            let sight = Sight(name: newSightName)
            destination.sights.append(sight)
            newSightName = ""
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)
        let example = Destination(name: "Example Destination", details: "Example details go here and will automatically expand vertically as they are edited.")
        return EditDestinationView(destination: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

//we need to use a property wrapper called @Bindable, which is able to create bindings any SwiftData object. This was built for the Swift observation that was introduced in iOS 17, but because SwiftData builds on observation it works just as well here too.
