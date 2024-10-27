//
//  MovieDetailView.swift
//  MovieDatabaseApplication
//
//  Created by Kartikeya Singh on 26/10/24.
//

import SwiftUI

// MARK: - MovieDetailView
struct MovieDetailView: View {
    let movie: Movie
    @State var isMovieAnalysisOpen: Bool = false
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                isMovieAnalysisOpen.toggle()
            }
        } label: {
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: movie.poster)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 75)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 75)
                            .scaleEffect(0.7)
                            .foregroundColor(.gray)
                    } else {
                        ProgressView()
                            .frame(width: 50, height: 75)
                            .tint(.black)
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(movie.title)
                        .font(.headline)
                    HStack(alignment: .top, spacing: 5) {
                        Text("Language:")
                            .font(.subheadline)
                        VStack(alignment: .leading) {
                            Text(movie.language)
                                .font(.subheadline)
                        }
                    }
                    Text("Year: \(movie.year)")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.9))
                }
            }
        }
        .sheet(isPresented: $isMovieAnalysisOpen, content: {
            MovieInsightsView(movie: movie)
        })
    }
}
