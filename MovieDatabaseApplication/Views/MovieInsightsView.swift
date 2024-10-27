//
//  MovieInsightsView.swift
//  MovieDatabaseApplication
//
//  Created by Kartikeya Singh on 26/10/24.
//

import SwiftUI

struct MovieInsightsView: View {
    var movie: Movie
    @State private var selectedRatingSource: RatingSource = .imdb
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let posterURL = URL(string: movie.poster) {
                    AsyncImage(url: posterURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                                .scaleEffect(0.2)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ProgressView()
                                .frame(height: 300)
                                .tint(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(movie.plot)
                    .font(.body)
                    .foregroundColor(.gray)
                
                if movie.actors != "N/A" {
                    Text("Cast & Crew:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(movie.actors)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                Text("Released: \(movie.released)")
                    .font(.body)
                    .foregroundColor(.gray)
                
                Text("Genre: \(movie.genre)")
                    .font(.body)
                    .foregroundColor(.gray)
                
                VStack {
                    Text("Rating")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    SegmentedTabView(selectedTab: $selectedRatingSource, movie: movie, underlineColor: .yellow)
                        .padding(.leading)
                    
                    HStack(spacing: 5) {
                        Text("Rating:")
                            .foregroundColor(.white)
                        Text("\(getRatingValue(for: selectedRatingSource))")
                            .foregroundColor(.yellow)
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .foregroundColor(.white)
    }
    
    private func getRatingValue(for source: RatingSource) -> String {
        switch source {
        case .imdb:
            return movie.imdbRating
        case .rottenTomatoes:
            return movie.ratings.first(where: {$0.source.rawValue == "Rotten Tomatoes"})?.value ?? ""
        case .metacritic:
            return movie.ratings.first(where: {$0.source.rawValue == "Metacritic"})?.value ?? ""
        case .internetMovieDatabase:
            return movie.ratings.first(where: {$0.source.rawValue == "Internet Movie Database"})?.value ?? ""
        }
    }
}

enum RatingSource: String, CaseIterable {
    case imdb = "IMDB"
    case rottenTomatoes = "Rotten Tomatoes"
    case metacritic = "Metacritic"
    case internetMovieDatabase = "Internet Movie Database"
}
