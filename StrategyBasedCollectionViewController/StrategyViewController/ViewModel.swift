//
//  ViewModel.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/17.
//

import Foundation
import Combine

class ViewModel<Item> where Item : Codable, Item : Hashable {
    
    private var cancellable = Set<AnyCancellable>()
    
    func request(apiItem: apiRequestItem) -> AnyPublisher<Item, Error> {
        
        guard var urlComponents = URLComponents(string: apiItem.url) else {
            print("ERROR1")
            return AnyPublisher(Fail<Item, Error>(error: URLError(.badURL)))
        }
        
        urlComponents.queryItems = apiItem.queryItems

        guard let url = urlComponents.url else {
            print("ERROR2")
            return AnyPublisher(Fail<Item, Error>(error: URLError(.badURL)))
        }
        
        var urlRequest = URLRequest(url: url)
        if apiItem.method == "POST" {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: apiItem.parameter ?? [:])
            } catch {
                print("ERROR3")
                return AnyPublisher(Fail<Item, Error>(error: URLError(.badURL)))
            }
        }
        urlRequest.httpMethod = apiItem.method

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: Item.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? URLError {
                    print("ERROR5")
                    return error
                } else {
                    print("ERROR6")
                    return URLError(.badServerResponse)
                }
            }
            .eraseToAnyPublisher()
    }
}
