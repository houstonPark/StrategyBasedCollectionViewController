//
//  EditGradeConcreteStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine

class EditGradeConcreteStrategy: EditProfileStrategy {
    
    private var commonInset: CGFloat = 32
    
    private var cancellable = Set<AnyCancellable>()
    
    var sections: [SectionCase] = [.buttonCollection , .seperator, .buttonCollection]
    
    var items: CurrentValueSubject<[Int: [DiffableData]],Never> = .init([
        0: [
            DiffableData(text: "초등학교", textStatus: .plain),
            DiffableData(text: "중학교", textStatus: .plain),
            DiffableData(text: "고등학교", textStatus: .plain),
        ]
    ])
    
    func cellSize(collectionViewSize: CGSize, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        switch indexPath.section {
        case 0:
            guard let item = self.items.value[indexPath.section]?[indexPath.item] else { return .zero }
            label.text = item.text
            label.sizeToFit()
            return CGSize(width: label.frame.width + commonInset, height: 44)
        case 1:
            return CGSize(width: collectionViewSize.width - commonInset, height: 1)
        case 2:
            guard let item = self.items.value[indexPath.section]?[indexPath.item] else { return .zero }
            label.text = item.text
            label.sizeToFit()
            return CGSize(width: label.frame.width + commonInset, height: 44)
        default:
            return .zero
        }
    }
    
    func editableCheckIfNeeded() -> Bool? {
        nil
    }
    
    func actionHandler(publishedText: String?, callFrom: CallFrom) {
        guard let publishedText = publishedText else {
            return
        }
        switch publishedText {
        case "초등학교":
            self.items.value[1] = [DiffableData()]
            self.items.value[2] = [
                DiffableData(text: "1학년", textStatus: .plain),
                DiffableData(text: "2학년", textStatus: .plain),
                DiffableData(text: "3학년", textStatus: .plain),
                DiffableData(text: "4학년", textStatus: .plain),
                DiffableData(text: "5학년", textStatus: .plain),
                DiffableData(text: "6학년", textStatus: .plain)
            ]
        case "중학교", "고등학교":
            self.items.value[1] = [DiffableData()]
            self.items.value[2] = [
                DiffableData(text: "1학년", textStatus: .plain),
                DiffableData(text: "2학년", textStatus: .plain),
                DiffableData(text: "3학년", textStatus: .plain)
            ]
        default:
            break
        }
    }
    
    func networkHandler(publishedText: String?, callFrom: CallFrom) {
        
    }
    
}
