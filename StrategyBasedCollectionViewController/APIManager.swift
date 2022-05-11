//
//  APIManager.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import Foundation

//https://www.thecocktaildb.com/api.php

struct apiRequestItem {
    var url: String
    var header: [String: String]?
    var parameter: [String: String]?
    var queryItems: [URLQueryItem]?
    var method: String
}


class APIManger {
    
    static var shared = APIManger()
    
    let baseURLString = "https://www.thecocktaildb.com/api/json/v1/1/search.php"
}
