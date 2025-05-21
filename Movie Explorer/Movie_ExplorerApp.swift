//
//  Movie_ExplorerApp.swift
//  Movie Explorer
//
//  Created by Shakhzod Botirov on 21/05/25.
//

import SwiftUI

@main
struct Movie_ExplorerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
