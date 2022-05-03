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
    
    init(strategy: FirstStrategyProtocol) {
        self.strategy = strategy
    }
    
    func request(item: apiRequestItem) -> Future<Movies, URLError> {
        guard let session = self.createSessionPublisher(item: item) else {
            return Future { $0(.failure(URLError(.badURL))) }
        }
        return Future { promise in
            _ = session
                .tryMap({ element -> Data in
                    guard let response = element.response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    switch response.statusCode {
                    case 200..<300:
                        print(response.statusCode)
                        return element.data
                    default:
                        throw URLError(.badServerResponse)
                    }
                })
                .decode(type: Movies.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(_):
                        promise(.failure(URLError(.badServerResponse)))
                    default:
                        break
                    }
                }, receiveValue: { movies in
                    promise(.success(movies))
                })
        }
    }
    
    private func createSessionPublisher(item: apiRequestItem) -> URLSession.DataTaskPublisher {
        var urlComponents = URLComponents(string: item.url)
        urlComponents?.queryItems = item.queryItems
        guard let url = urlComponents?.url else {
            return 
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = item.header
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: item.parameter ?? [:])
        } catch {
            return nil
        }
        urlRequest.httpMethod = item.method
        let session = URLSession.shared.dataTaskPublisher(for: urlRequest)
        return session
    }
}
