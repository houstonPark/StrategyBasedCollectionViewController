//
//  EditProfileStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit

protocol EditProfileStrategy {
    
    var sections: [SectionCase] { get }
    
    var items: [Int: [DiffableData]] { get }
    
    func cellSize(collectionViewSize: CGSize, sectionIndex: Int) -> CGSize
    
    func editableCheckIfNeeded() -> Bool?
}

enum SectionCase: Hashable {
    case textField(placeholder: String)
    case textView(placeholder: String)
    case buttonCollection
}

struct DiffableData: Hashable {
    var text: String?
    var message: String?
    var textStatus: status
    
    enum status {
        case plain
        case error
        case disable
    }
}
