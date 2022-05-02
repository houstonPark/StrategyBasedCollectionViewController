//
//  APIManager.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import Foundation

//https://rapidapi.com/rapidapi/api/movie-database-alternative/

class APIManger {
    
    static var shared = APIManger()
    
    let baseURLString = "https://movie-database-alternative.p.rapidapi.com/"
    
    let headers = [
        "X-RapidAPI-Host": "movie-database-alternative.p.rapidapi.com",
        "X-RapidAPI-Key": "SIGN-UP-FOR-KEY"
    ]

}
