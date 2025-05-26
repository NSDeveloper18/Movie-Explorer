//
//  Movie_ExplorerApp.swift
//  Movie Explorer
//
//  Created by Shakhzod Botirov on 21/05/25.
//

import SwiftUI

@main
struct Movie_ExplorerApp: App {
    let persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView {
                MovieListView()
                    .tabItem {
                        Label("Фильмы", systemImage: "film")
                    }

                FavoritesView()
                    .tabItem {
                        Label("Избранное", systemImage: "heart")
                    }
            }
            .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
