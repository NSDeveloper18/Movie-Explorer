//
//  MovieListViewModel.swift
//  Movie Explorer
//
//  Created by Shakhzod Botirov on 21/05/25.
//

import Foundation
import Combine

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText = ""
    @Published var currentPage = 1
    @Published var totalPages = 1
    @Published var isLoading = false

    private let service = MovieService()
    private var debounceTask: Task<Void, Never>?

    init() {
        fetchPopularMovies()
    }

    func fetchPopularMovies() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                let result = try await service.fetchPopularMovies(page: currentPage)
                movies += result.results
                totalPages = result.totalPages
                currentPage += 1
            } catch {
                print("Error: \(error)")
            }
            isLoading = false
        }
    }

    func searchMovies() {
        debounceTask?.cancel()
        guard !searchText.isEmpty else {
            currentPage = 1
            movies = []
            fetchPopularMovies()
            return
        }

        debounceTask = Task(priority: .userInitiated) {
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            isLoading = true
            do {
                let result = try await service.searchMovies(query: searchText, page: 1)
                movies = result.results
                totalPages = result.totalPages
                currentPage = 2
            } catch {
                print("Search error: \(error)")
            }
            isLoading = false
        }

    }

    func loadMoreIfNeeded(current: Movie) {
        guard current.id == movies.last?.id, currentPage <= totalPages, !isLoading else { return }
        if searchText.isEmpty {
            fetchPopularMovies()
        } else {
            Task {
                do {
                    let result = try await service.searchMovies(query: searchText, page: currentPage)
                    movies += result.results
                    currentPage += 1
                } catch {
                    print("Load more error: \(error)")
                }
            }
        }
    }
}
