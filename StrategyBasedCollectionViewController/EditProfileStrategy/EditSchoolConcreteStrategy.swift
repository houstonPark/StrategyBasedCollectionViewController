//
//  EditSchoolConcreteStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine

class EditSchoolConcreteStrategy: EditProfileStrategy {

    var sections: [SectionCase] = [SectionCase.textField(placeholder: "학교 이름을 검색해주세요.")]
    
    var items: CurrentValueSubject<[Int: [DiffableData]],Never> = .init([
        0: [DiffableData()]
    ])
    
    func cellSize(collectionViewSize: CGSize, sectionIndex: Int) -> CGSize {
        if sectionIndex == 0 {
            return CGSize(width: collectionViewSize.width - 32, height: 68)
        }
        else {
            return CGSize(width: collectionViewSize.width - 32, height: 20)
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
