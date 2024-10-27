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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Please hold while we load your movies...")
                    } else {
                        Divider()
                            .foregroundStyle(.gray)
                            .padding(.bottom, 5)
                        VStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                TextField("Search by title, genre, director, actor, or year.", text: $searchString)
                                    .padding(.trailing)
                                    .padding(.vertical)
                                    .font(.system(size: 15))
                                    .focused($isFocused)
                                    .onSubmit {
                                        isFocused = false
                                    }
                                if searchString != "" {
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.gray)
                                        .padding(.trailing)
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                searchString = ""
                                                isFocused = false
                                            }
                                        }
                                }
                            }
                        }
                        .background(Color(.lightGray).opacity(0.15).cornerRadius(12))
                        .padding(.horizontal)
                        
                        Divider()
                            .foregroundStyle(.gray)
                            .padding(.top, 5)
                        
                        List {
                            if searchString.isEmpty {
                                ForEach(MovieCategory.allCases, id: \.self) { category in
                                    Section(
                                        header:
                                            VStack {
                                                HStack {
                                                    Text(category.displayName)
                                                        .font(.system(size: 18, weight: .medium))
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
                                                Divider()
                                                    .foregroundStyle(Color.gray)
                                                    .opacity(selectedCategory == category ? 0 : 1)
                                                    .padding(.top, 5)
                                            }
                                            .frame(height: 35)
                                    ) {
                                        if selectedCategory == category {
                                            if category == .allMovies {
                                                AllMoviesView(movies: viewModel.getMovies())
                                            } else {
                                                SubCategoryView(subCategories: viewModel.getSubCategories(for: category), searchString: $searchString)
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                // Handling search operations
                                let filteredMovies = viewModel.getMovies().filter { movie in
                                    let years = movie.year.split(separator: "–").map { $0.trimmingCharacters(in: .whitespaces) }
                                    
                                    let matchesTitle = movie.title.localizedCaseInsensitiveContains(searchString)
                                    let matchesGenre = movie.genre.localizedStandardContains(searchString)
                                    let matchesActors = movie.actors.localizedStandardContains(searchString)
                                    let matchesDirector = movie.director.localizedStandardContains(searchString)
                                    
                                    let matchesYear: Bool
                                    if years.count > 1,
                                       let startYear = Int(years[0]),
                                       let endYear = Int(years[1]) {
                                        matchesYear = (startYear...endYear).contains(Int(searchString) ?? -1)
                                    } else if let singleYear = Int(years[0]) {
                                        matchesYear = searchString.localizedCaseInsensitiveContains(String(singleYear))
                                    } else {
                                        matchesYear = false
                                    }
                                    
                                    return matchesTitle || matchesYear || matchesGenre || matchesActors || matchesDirector
                                }
                                
                                if filteredMovies.isEmpty {
                                    Text("No results found")
                                        .foregroundColor(.gray)
                                        .font(.headline)
                                        .padding()
                                } else {
                                    ForEach(filteredMovies, id: \.imdbID) { movie in
                                        MovieDetailView(movie: movie)
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .padding(.horizontal)
                        .preferredColorScheme(.light)
                    }
                }
                .onAppear {
                    viewModel.loadMovies()
                }
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
    var movies: Movies
    
    var body: some View {
        ForEach(movies, id: \.imdbID) { movie in
            MovieDetailView(movie: movie)
        }
    }
}

// MARK: - SubCategoryView
struct SubCategoryView: View {
    var subCategories: [String]
    @Binding var searchString: String
    
    var body: some View {
        ForEach(subCategories, id: \.self) { subCategory in
            Button {
                withAnimation(.spring()) {
                    searchString = subCategory.description
                }
            } label: {
                Text(subCategory)
                    .foregroundStyle(.black)
            }
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


