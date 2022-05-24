//
//  EditGradeConcreteStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine
import QDSKit

class EditGradeConcreteStrategy: EditProfileStrategy {
    
    private var commonInset: CGFloat = 32
    
    private var cancellable = Set<AnyCancellable>()
    
    var sections: [SectionCase] = [.button(0) , .seperator(1), .button(2)]
    
    func cellSize(collectionViewSize: CGSize, value: String, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = QDS.Font.b2
        switch self.sections[indexPath.section] {
        case .button:
            label.text = value
            label.sizeToFit()
            return CGSize(width: label.frame.width + commonInset, height: 44)
        case .seperator:
            return CGSize(width: collectionViewSize.width - commonInset, height: 1)
        default:
            return .zero
        }
    }
    
    func fetchDataSource() -> Future<[SectionCase : [DiffableData]], Error> {
        return Future { promise in
            promise(.success(
                [
                    .button(0):
                        [
                            DiffableData(text: "초등학교", textStatus: .plain),
                            DiffableData(text: "중학교", textStatus: .plain),
                            DiffableData(text: "고등학교", textStatus: .plain)
                        ]
                ]
            ))
        }
    }
    
    func didValueChanged(_ previousValue: [SectionCase : [DiffableData]], newValue: String) -> Future<[SectionCase : [DiffableData]]?, Error> {
        return Future { promise in
            promise(.success(nil))
        }
    }
    
    func didSelect(_ previousValue: [SectionCase : [DiffableData]], value: String, at indexPath: IndexPath) -> Future<[SectionCase : [DiffableData]]?, Error> {
        return Future { promise in
            var items = previousValue
            switch value {
            case "초등학교":
                items[.seperator(1)] = [DiffableData()]
                items[.button(2)] = [
                    DiffableData(text: "1학년", textStatus: .plain),
                    DiffableData(text: "2학년", textStatus: .plain),
                    DiffableData(text: "3학년", textStatus: .plain),
                    DiffableData(text: "4학년", textStatus: .plain),
                    DiffableData(text: "5학년", textStatus: .plain),
                    DiffableData(text: "6학년", textStatus: .plain)
                ]
            case "중학교", "고등학교":
                items[.seperator(1)] = [DiffableData()]
                items[.button(2)] = [
                    DiffableData(text: "1학년", textStatus: .plain),
                    DiffableData(text: "2학년", textStatus: .plain),
                    DiffableData(text: "3학년", textStatus: .plain)
                ]
            default:
                promise(.success(nil))
            }
            promise(.success(items))
        }
    }
}
