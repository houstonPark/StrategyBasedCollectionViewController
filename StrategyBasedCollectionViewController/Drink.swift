//
//  MovieModel.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import Foundation

struct Drinks: Hashable, Codable {
    var drinks: [Drink]?
}

struct Drink: Hashable, Codable {
    var idDrink: String?
    var strDrink: String?
    var strCategory: String?
    var strAlcoholic: String?
    var strInstructions: String?
    var strDrinkThumb: String?
    var dateModified: String?
}
