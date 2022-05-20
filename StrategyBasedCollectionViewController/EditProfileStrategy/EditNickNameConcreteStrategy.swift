//
//  EditNickNameConcreteStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine

class EditNickNameConcreteStrategy: EditProfileStrategy {

    var sections: [SectionCase] = [
        SectionCase.textField(placeholder: "닉네임을 입력해주세요.")
    ]

    var items: [Int : [DiffableData]] = [
        0: [DiffableData(text: nil, message: "닉네임은 한글, 영문, 숫자, 마침표(.), 대시(-), 밑줄(_)의 조합으로 최대 10자까지 가능합니다.", textStatus: .plain)]
    ]
    
    func cellSize(collectionViewSize: CGSize, sectionIndex: Int) -> CGSize {
        CGSize(width: collectionViewSize.width - 32, height: 90)
    }
    
    func editableCheckIfNeeded() -> Bool? {
        return nil
    }
    
}