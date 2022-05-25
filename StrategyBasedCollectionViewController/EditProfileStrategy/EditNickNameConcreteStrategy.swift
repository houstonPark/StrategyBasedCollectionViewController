//
//  EditNickNameConcreteStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine

class EditNickNameConcreteStrategy: EditProfileStrategy {
    
    private var commonInset: CGFloat = 32
    
    var sections: [SectionCase] = [.textField(placeholder: "닉네임을 입력해주세요.")]
    
    func cellSize(collectionViewSize: CGSize, value: String, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionViewSize.width - commonInset, height: 90)
    }
    
    func fetchDataSource() -> Future<[SectionCase : [DiffableData]], Error> {
        return Future { promise in
            promise(.success(
                [
                    .textField(placeholder: "닉네임을 입력해주세요.") :
                        [DiffableData(message: "닉네임은 한글, 영문, 숫자, 마침표(.), 대시(-), 밑줄(_)의 조합으로 최대 10자까지 가능합니다.", textStatus: .plain)]
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
            promise(.success(nil))
        }
    }
}
