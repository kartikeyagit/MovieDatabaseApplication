//
//  MovieDatabase.swift
//  MovieDatabaseApplication
//
//  Created by Kartikeya Singh on 26/10/24.
//

import SwiftUI

// MARK: - MovieDatabaseView
struct MovieDatabaseView: View {
    @StateObject var viewModel = MovieDatabaseViewModel()
    @State private var selectedCategory: MovieCategory? = nil
    @State private var searchString = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Please hold while we load your movies...")
                    } else {
                        VStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                TextField("Search by title, genre, director, actor, or year...", text: $searchString)
                                    .padding(.trailing)
                                    .padding(.vertical)
                                    .font(.system(size: 14))
                            }
                        }
                        .background(Color(.systemGray6).cornerRadius(12))
                        
                        List {
                            if searchString.isEmpty {
                                ForEach(MovieCategory.allCases, id: \.self) { category in
                                    Section(
                                        header:
                                            VStack {
                                                HStack {
                                                    Text(category.displayName)
                                                        .font(.system(size: 18, weight: .medium))
                                                        .frame(height: 35)
                                                        .foregroundStyle(.black)
                                                    Spacer()
                                                    Image(systemName: selectedCategory == category ? "chevron.down" : "chevron.right")
                                                        .foregroundStyle(.gray)
                                                    
                                                }
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.25)) {
                                                        toggleCategory(category)
                                                    }
                                                }
                                            }
                                    ) {
                                        if selectedCategory == category {
                                            if category == .allMovies {
                                                AllMoviesView(movies: viewModel.getMovies())
                                            } else {
                                                SubCategoryView(category: category, subCategories: viewModel.getSubCategories(for: category))
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                ForEach(viewModel.getMovies().filter { movie in
                                    movie.title.localizedCaseInsensitiveContains(searchString)
                                }, id: \.imdbID) { movie in
                                    MovieDetailView(movie: movie)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                .onAppear {
                    viewModel.loadMovies()
                }
                .padding()
            }
            .navigationTitle("Movie Database")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func toggleCategory(_ category: MovieCategory) {
        if selectedCategory == category {
            selectedCategory = nil
        } else {
            selectedCategory = category
        }
    }
}

// MARK: - AllMoviesView
struct AllMoviesView: View {
    var movies: [Movie]
    
    var body: some View {
        ForEach(movies, id: \.imdbID) { movie in
            MovieDetailView(movie: movie)
        }
    }
}

// MARK: - SubCategoryView
struct SubCategoryView: View {
    var category: MovieCategory
    var subCategories: [String]
    
    var body: some View {
        ForEach(subCategories, id: \.self) { subCategory in
            Text(subCategory)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    MovieDatabaseView()
}

// MARK: - MovieCategory Enum
enum MovieCategory: CaseIterable {
    case year, genre, directors, actors, allMovies
    
    var displayName: String {
        switch self {
        case .year: return "Year"
        case .genre: return "Genre"
        case .directors: return "Directors"
        case .actors: return "Actors"
        case .allMovies: return "All Movies"
        }
    }
}


