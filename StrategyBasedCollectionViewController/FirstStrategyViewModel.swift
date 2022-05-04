//
//  FirstStrategyViewModel.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/03.
//

import UIKit
import Combine

class FirstStrategyViewModel: ObservableObject {
    
    private var strategy: FirstStrategyProtocol!
    private var cancellable = Set<AnyCancellable>()

    init(strategy: FirstStrategyProtocol) {
        self.strategy = strategy
    }

    func request(item: apiRequestItem) -> AnyPublisher<Drinks, Error> {

        guard var urlComponents = URLComponents(string: item.url) else {
            print("ERROR1")
            return AnyPublisher(Fail<Drinks, Error>(error: URLError(.badURL)))
        }

        urlComponents.queryItems = item.queryItems

        guard let url = urlComponents.url else {
            print("ERROR2")
            return AnyPublisher(Fail<Drinks, Error>(error: URLError(.badURL)))
        }

        var urlRequest = URLRequest(url: url)
        if item.method == "POST" {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: item.parameter ?? [:])
            } catch {
                print("ERROR3")
                return AnyPublisher(Fail<Drinks, Error>(error: URLError(.badURL)))
            }
        }
        urlRequest.httpMethod = item.method

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: Drinks.self, decoder: JSONDecoder())
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
