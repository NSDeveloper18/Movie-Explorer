//
//  FavoritesView.swift
//  Movie Explorer
//
//  Created by Shakhzod Botirov on 21/05/25.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        entity: FavoriteMovie.entity(),
        sortDescriptors: []
    ) private var favorites: FetchedResults<FavoriteMovie>

    var body: some View {
        NavigationView {
            List {
                ForEach(favorites) { fav in
                    let movie = Movie(
                        id: Int(fav.id),
                        title: fav.title ?? "",
                        overview: fav.overview ?? "",
                        posterPath: fav.posterPath,
                        releaseDate: fav.releaseDate ?? "",
                        voteAverage: fav.voteAverage
                    )

                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRowView(movie: movie, imageData: fav.posterImageData)
                    }
                }

                .onDelete(perform: deleteFavorite)
            }
            .navigationTitle("Избранное")
            .toolbar { EditButton() }
        }
    }

    private func deleteFavorite(offsets: IndexSet) {
        for index in offsets {
            context.delete(favorites[index])
        }
        try? context.save()
    }
}

