//
//  MovieDatabaseViewModel.swift
//  MovieDatabaseApplication
//
//  Created by Kartikeya Singh on 26/10/24.
//

import SwiftUI

class MovieDatabaseViewModel: ObservableObject {
    @Published var movies: Movies?
    @Published var isLoading: Bool = true
    
    func loadMovies() {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            print("Failed to find movies.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Movies.self, from: data)
            DispatchQueue.main.async {
                self.movies = decodedData
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                print("Error loading JSON: \(error.localizedDescription)")
            }
        }
    }
    
    func getMovies() -> Movies {
        guard let movies = movies else { return [] }
        return movies
    }
    
    func getSubCategories(for category: MovieCategory) -> [String] {
        if let movies = movies {
            switch category {
            case .year:
                let years = extractYears(from: movies)
                return years
            case .actors:
                let years = extractSubCategory(keyPath: \.actors, from: movies)
                return years
            case .directors:
                let years = extractSubCategory(keyPath: \.director, from: movies)
                return years
            case .genre:
                let years = extractSubCategory(keyPath: \.genre, from: movies)
                return years
            case .allMovies: return []
            }
        }
        return []
    }
    
    func extractYears(from movies: Movies) -> [String] {
        var uniqueYears: Set<String> = []
        
        for movie in movies {
            let years = movie.year.split(separator: "–").map { $0.trimmingCharacters(in: .whitespaces) }
            
            if years.count > 1, let startYear = Int(years[0]), let endYear = Int(years[1]) {
                for year in startYear...endYear {
                    uniqueYears.insert(String(year))
                }
            } else if let singleYear = Int(years[0]) {
                uniqueYears.insert(String(singleYear))
            }
        }
        
        return Array(uniqueYears).sorted()
    }
    
    func extractSubCategory<Value: StringProtocol>(
        keyPath: KeyPath<Movie, Value>,
        from movies: Movies
    ) -> [String] {
        var uniqueSubCategories: Set<String> = []

        for movie in movies {
            let data = movie[keyPath: keyPath]
            let subCategories = data.split { $0 == "," || $0 == "-" }
                .map { $0.trimmingCharacters(in: .whitespaces) }
            let filteredSubcategories = subCategories.filter({$0 != "N/A"})
            uniqueSubCategories.formUnion(filteredSubcategories)
        }
        
        return Array(uniqueSubCategories).sorted()
    }
}
