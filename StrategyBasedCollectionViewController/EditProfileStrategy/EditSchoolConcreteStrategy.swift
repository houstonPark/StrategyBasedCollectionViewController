//
//  EditSchoolConcreteStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine

class EditSchoolConcreteStrategy: EditProfileStrategy {

    private var cancellable = Set<AnyCancellable>()

    var sections: [SectionCase] = [.textField(placeholder: "학교 이름을 검색해주세요."), .asyncList(status: .none)]
    
    var items: CurrentValueSubject<[Int: [DiffableData]],Never> = .init([
        0: [DiffableData()]
    ])

//    var cellIdentifiers: [String] = [
//        "EditProfileTextFieldCell",
//        "EditProfileListCell"
//    ]
    
    func cellSize(collectionViewSize: CGSize, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionViewSize.width - 32, height: 44)
        }
        else {
            return CGSize(width: collectionViewSize.width - 32, height: 20)
        }
    }
    
    func actionHandler(publishedText: String?, callFrom: CallFrom) {
        switch callFrom {
        case .viewDidLoad:
            return
        case .dequeueReuseCell:
            self.searching(text: publishedText ?? "")
        case .selectCell:
            self.selectUpdate(text: publishedText ?? "")
        }
    }

    private func searching(text: String) {
        let apiItem = apiRequestItem(url: APIManger.shared.baseURLString, header: nil, parameter: nil, queryItems: [URLQueryItem(name: "s", value: text)], method: "GET")
        self.sections[1] = .asyncList(status: .loading)
        self.items.value[1] = [DiffableData()]
        ViewModel<Drinks>().request(apiItem: apiItem)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("<ERROR>", error.localizedDescription)
                    return
                case .finished:
                    break
                }
            } receiveValue: { Drinks in
                self.items.value[1] = nil
                guard let drinks = Drinks.drinks, drinks.isEmpty == false else {
                    self.sections[1] = .asyncList(status: .emptyList)
                    self.items.value[1] = [DiffableData()]
                    return
                }
                self.sections[1] = .asyncList(status: .showList)
                var listItems: [DiffableData] = []
                drinks.forEach { drink in
                    listItems.append(DiffableData(text: drink.strDrink, textStatus: .plain))
                }
                self.items.value[1] = listItems
            }
            .store(in: &self.cancellable)

    }

    private func selectUpdate(text: String) {
        switch self.sections[1] {
        case let .asyncList(status):
            if status == .showList {
                
            }
        default:
            return
        }
    }
}
