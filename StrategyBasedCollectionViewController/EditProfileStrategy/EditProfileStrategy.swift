//
//  EditProfileStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine

protocol EditProfileStrategy {
    
    var sections: [SectionCase] { get set }
    
    var items: CurrentValueSubject<[Int: [DiffableData]],Never> { get set }

    var cellIdentifiers: [String] { get }

    func cellSize(collectionViewSize: CGSize, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func editableCheckIfNeeded() -> Bool?
    
    func actionHandler(publishedText: String?, callFrom: CallFrom)
}

enum SectionCase: Hashable {
    case textField(placeholder: String)
    case textView(placeholder: String)
    case buttonCollection
    case seperator
    case asyncList(status: AsyncStatus)
}

enum AsyncStatus {
    case none
    case loading
    case showList
    case emptyList
}

struct DiffableData: Hashable {
    
    init(text: String? = nil, message: String? = nil, textStatus: status = .plain) {
        self.text = text
        self.message = message
        self.textStatus = textStatus
    }

    var id = UUID()
    var text: String?
    var message: String?
    var textStatus: status
    
    enum status {
        case plain
        case error
        case disable
    }
}

enum CallFrom {
    case viewDidLoad
    case dequeueReuseCell
    case selectCell
}
