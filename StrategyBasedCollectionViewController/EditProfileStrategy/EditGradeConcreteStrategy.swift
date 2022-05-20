//
//  EditGradeConcreteStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine

class EditGradeConcreteStrategy: EditProfileStrategy {
    
    private var cancellable = Set<AnyCancellable>()
    
    var sections: [SectionCase] = [SectionCase.buttonCollection, SectionCase.seperator, SectionCase.buttonCollection]
    
    var items: CurrentValueSubject<[Int: [DiffableData]],Never> = .init([
        0: [
            DiffableData(text: "초등학교", textStatus: .plain),
            DiffableData(text: "중학교", textStatus: .plain),
            DiffableData(text: "고등학교", textStatus: .plain),
        ],
        1: [
            DiffableData()
        ],
        2 : [
            DiffableData(text: "1학년", textStatus: .plain),
            DiffableData(text: "2학년", textStatus: .plain),
            DiffableData(text: "3학년", textStatus: .plain),
            DiffableData(text: "4학년", textStatus: .plain),
            DiffableData(text: "5학년", textStatus: .plain),
            DiffableData(text: "6학년", textStatus: .plain),
        ]
        
    ])
    
    func cellSize(collectionViewSize: CGSize, sectionIndex: Int) -> CGSize {
        switch sectionIndex {
        case 0:
            return CGSize(width: 84, height: 44)
        case 1:
            return CGSize(width: collectionViewSize.width - 32, height: 1)
        case 2:
            return CGSize(width: 65, height: 44)
        default:
            return .zero
        }
    }
    
    func editableCheckIfNeeded() -> Bool? {
        nil
    }
    
    func actionHandler(publishedText: String, callFrom: CallFrom) {
        
    }
    
    func networkHandler(publishedText: String, callFrom: CallFrom) {
        
    }
    
}
