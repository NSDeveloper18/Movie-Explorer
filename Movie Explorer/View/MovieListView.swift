//
//  MovieListView.swift
//  Movie Explorer
//
//  Created by Shakhzod Botirov on 21/05/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @ObservedObject private var networkMonitor: NetworkMonitor = .shared
    @State private var shouldRedirectToFavorites = false
    var body: some View {
        NavigationView {
            if !networkMonitor.isConnected {
                VStack(spacing: 16) {
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    
                    Text("No internet connection")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    Text("Please connect your device to the internet.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .onAppear {
                    shouldRedirectToFavorites = true
                }
            } else {
                List {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieRowView(movie: movie)
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(current: movie)
                                }
                        }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
                .navigationTitle("Популярные фильмы")
                .searchable(text: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchMovies()
                }
                .refreshable {
                    viewModel.movies = []
                    viewModel.currentPage = 1
                    viewModel.fetchPopularMovies()
                }
            }
        }
    }
}

