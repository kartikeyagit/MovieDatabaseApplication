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
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: movie.poster)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 75)
            } placeholder: {
                Color.gray
                    .frame(width: 50, height: 75)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)
                HStack(alignment: .top) {
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
}
