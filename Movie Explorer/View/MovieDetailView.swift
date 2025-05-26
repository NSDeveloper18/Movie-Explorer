//
//  MovieDetailView.swift
//  Movie Explorer
//
//  Created by Shakhzod Botirov on 21/05/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.managedObjectContext) private var context
    @FetchRequest var favorites: FetchedResults<FavoriteMovie>

    init(movie: Movie) {
        self.movie = movie
        _favorites = FetchRequest<FavoriteMovie>(
            sortDescriptors: [], predicate: NSPredicate(format: "id == %d", movie.id),
            animation: .default
        )
    }

    var isFavorite: Bool {
        favorites.first != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "photo.fill")
                        .frame(width: 150)
                        .foregroundColor(.gray)
                }
                .frame(height: 300)
                .cornerRadius(10)

                Text(movie.title)
                    .font(.title)
                    .padding(.top)

                Text("Дата выхода: \(movie.releaseDate)")
                    .foregroundColor(.secondary)

                Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")

                Text(movie.overview)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .toolbar {
            Button {
                toggleFavorite()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
            }
        }
    }

    func toggleFavorite() {
        if isFavorite {
            favorites.first.map(context.delete)
        } else {
            let fav = FavoriteMovie(context: context)
            fav.id = Int64(movie.id)
            fav.title = movie.title
            fav.overview = movie.overview
            fav.posterPath = movie.posterPath
            fav.releaseDate = movie.releaseDate
            fav.voteAverage = movie.voteAverage

            // Download and store image data
            if let path = movie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)"),
               let imageData = try? Data(contentsOf: url) {
                fav.posterImageData = imageData
            }
        }

        try? context.save()
    }

}
