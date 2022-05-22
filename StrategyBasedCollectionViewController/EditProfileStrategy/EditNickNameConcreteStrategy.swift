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

    var items: CurrentValueSubject<[Int: [DiffableData]],Never> = .init([
        0: [DiffableData(message: "닉네임은 한글, 영문, 숫자, 마침표(.), 대시(-), 밑줄(_)의 조합으로 최대 10자까지 가능합니다.", textStatus: .plain)]
    ])
    
    func cellSize(collectionViewSize: CGSize, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionViewSize.width - 32, height: 90)
    }
    
    func editableCheckIfNeeded() -> Bool? {
        return nil
    }
    
    func actionHandler(publishedText: String?, callFrom: CallFrom) {
        
    }
    
    func networkHandler(publishedText: String?, callFrom: CallFrom) {
        
    }
}
