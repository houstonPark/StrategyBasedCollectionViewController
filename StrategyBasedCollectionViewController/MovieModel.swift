//
//  MovieModel.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import Foundation

struct Movie: Hashable, Codable {
    
    var Title: String
    
    var Year: String
    
    var imdbID: String
    
    var type: String
    
    var Poster: String
}

struct Movies: Codable {
    
    var Search: [Movie]
    
    var totalResults: Int
    
    var Response: Bool
    
}
