//
//  MovieService.swift
//  Movie Explorer
//
//  Created by Shakhzod Botirov on 21/05/25.
//

import Foundation

class MovieService {
    private let apiKey = "0623666c32876091a58e86c83c7f01f4"
    private let baseURL = "https://api.themoviedb.org/3"

    func fetchPopularMovies(page: Int) async throws -> MovieResponse {
        let url = URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)&language=ru-RU&page=\(page)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        return try JSONDecoder().decode(MovieResponse.self, from: data)
    }

    func searchMovies(query: String, page: Int) async throws -> MovieResponse {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&language=ru-RU&query=\(escapedQuery)&page=\(page)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        return try JSONDecoder().decode(MovieResponse.self, from: data)
    }
}
