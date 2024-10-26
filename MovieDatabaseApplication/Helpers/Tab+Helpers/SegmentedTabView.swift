//
//  SegmentedTabView.swift
//  MovieDatabaseApplication
//
//  Created by Kartikeya Singh on 26/10/24.
//

import SwiftUI

struct SegmentedTabView: View {
    @Binding var selectedTab: RatingSource
    @State var segmentTabItems: [RatingSource] = RatingSource.allCases
    @State var underlineColor: Color
    
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
}

