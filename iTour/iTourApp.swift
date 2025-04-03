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
