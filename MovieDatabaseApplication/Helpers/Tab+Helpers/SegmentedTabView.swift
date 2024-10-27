//
//  SegmentedTabView.swift
//  MovieDatabaseApplication
//
//  Created by Kartikeya Singh on 26/10/24.
//

import SwiftUI

struct SegmentedTabView: View {
    @Binding var selectedTab: RatingSource
    var movie: Movie
    @State var underlineColor: Color
    
    private var segmentTabItems: [RatingSource] {
        RatingSource.allCases.filter { !getRatingValue(for: $0).isEmpty && getRatingValue(for: $0) != "N/A" }
    }
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(segmentTabItems, id: \.self) { ratingSource in
                        Button(action: {
                            selectedTab = ratingSource
                        }) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(ratingSource.rawValue)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(selectedTab == ratingSource ? underlineColor : .white)
                                    .font(.headline)
                                
                                Capsule()
                                    .fill(selectedTab == ratingSource ? underlineColor : .clear)
                                    .frame(width: 16, height: 2)
                            }
                            .id(ratingSource)
                        }
                        .onAppear {
                            if selectedTab == ratingSource {
                                withAnimation(.spring()) {
                                    scrollViewProxy.scrollTo(selectedTab, anchor: .center)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .frame(height: 47)
            .onChange(of: selectedTab) { oldValue, newValue in
                withAnimation(.spring()) {
                    scrollViewProxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
    
    private func getRatingValue(for source: RatingSource) -> String {
        switch source {
        case .imdb:
            return movie.imdbRating
        case .rottenTomatoes:
            return movie.ratings.first(where: { $0.source.rawValue == "Rotten Tomatoes" })?.value ?? ""
        case .metacritic:
            return movie.ratings.first(where: { $0.source.rawValue == "Metacritic" })?.value ?? ""
        case .internetMovieDatabase:
            return movie.ratings.first(where: { $0.source.rawValue == "Internet Movie Database" })?.value ?? ""
        }
    }
}

