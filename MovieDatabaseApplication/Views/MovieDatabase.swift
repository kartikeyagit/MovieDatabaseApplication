//
//  MovieDatabase.swift
//  MovieDatabaseApplication
//
//  Created by Kartikeya Singh on 26/10/24.
//

import SwiftUI

struct MovieDatabase: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                        Text("List of Movies")
                    }
                    .padding()
                }
            }
            .navigationTitle("Movie Database")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MovieDatabase()
}
