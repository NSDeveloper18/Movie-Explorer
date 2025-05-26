//
//  MovieRowView.swift
//  Movie Explorer
//
//  Created by Shakhzod Botirov on 21/05/25.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    var imageData: Data? = nil
    var body: some View {
        HStack {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
            } else {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath ?? "")")) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "photo.fill")
                        .frame(width: 80)
                        .foregroundColor(.gray)
                    
                }
                .frame(width: 80, height: 120)
                .cornerRadius(10)
            }
            VStack(alignment: .leading, spacing: 12) {
                Text(movie.title)
                    .font(.headline)
                
                Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")
                Text(movie.releaseDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
