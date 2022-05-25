//
//  EditSchoolConcreteStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine

class EditSchoolConcreteStrategy: EditProfileStrategy {
    
    private var commonInset: CGFloat = 32
    
    private var cancellable = Set<AnyCancellable>()
    
    var sections: [SectionCase] = [.textField(placeholder: "학교 이름을 검색해주세요."), .custom(status: .none)]
    
    func cellSize(collectionViewSize: CGSize, value: String, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionViewSize.width - commonInset, height: 44)
        }
        else {
            return CGSize(width: collectionViewSize.width - commonInset, height: 20)
        }
    }
    
    func fetchDataSource() -> Future<[SectionCase : [DiffableData]], Error> {
        return Future { promise in
            promise(.success(
                [.textField(placeholder: "학교 이름을 검색해주세요."):  [DiffableData()]]
            ))
        }
    }
    
    func didValueChanged(_ previousValue: [SectionCase : [DiffableData]], newValue: String) -> Future<[SectionCase : [DiffableData]]?, Error> {
        let apiItem = apiRequestItem(url: APIManger.shared.baseURLString, header: nil, parameter: nil, queryItems: [URLQueryItem(name: "s", value: newValue)], method: "GET")
        var items = previousValue
        return Future { promise in
            ViewModel<Drinks>().request(apiItem: apiItem)
                .sink { completion in
                    switch completion {
                    case let .failure(error):
                        print("<ERROR>", error.localizedDescription)
                        promise(.failure(error))
                    case .finished:
                        break
                    }
                } receiveValue: { drinks in
                    if let drinks = drinks.drinks, drinks.isEmpty == false {
                        self.sections[1] = .custom(status: .showList)
                        var listItems: [DiffableData] = []
                        drinks.forEach { drink in
                            listItems.append(DiffableData(text: drink.strDrink, textStatus: .plain))
                        }
                        items[.custom(status: .showList)] = listItems
                    }
                    else {
                        self.sections[1] = .custom(status: .emptyList)
                        items[.custom(status: .emptyList)] = [DiffableData()]
                    }
                    promise(.success(items))
                }
                .store(in: &self.cancellable)
        }
    }
    
    func didSelect(_ previousValue: [SectionCase : [DiffableData]], value: String, at indexPath: IndexPath) -> Future<[SectionCase : [DiffableData]]?, Error> {
        return Future { promise in
            if self.sections[indexPath.section] == .custom(status: .showList) {
                var items = previousValue
                items[.textField(placeholder: "학교 이름을 검색해주세요.")] = [DiffableData(text: value, textStatus: .plain)]
                promise(.success(items))
            }
            else {
                promise(.success(nil))
            }
        }
    }
}
