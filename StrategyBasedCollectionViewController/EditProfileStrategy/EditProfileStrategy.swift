//
//  EditProfileStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine


//  Homework

//  1. SectionCase와 Int를 1개로 표현해보자.
//  2. AsyncList 없애기
//  4. items 노출 없애보기.

protocol EditProfileStrategy {

    typealias DataSource = [SectionCase: [DiffableData]]

    var sections: [SectionCase] { get set }

    func cellSize(collectionViewSize: CGSize, value: String, sizeForItemAt indexPath: IndexPath) -> CGSize

    func fetchDataSource() -> Future<DataSource, Error>
    
    func didValueChanged(_ previousValue: DataSource, newValue: String) -> Future<DataSource?, Error>

    func didSelect(_ previousValue: DataSource, value: String, at indexPath: IndexPath) -> Future<DataSource?, Error>
}

enum SectionCase: Hashable {

    case textField(placeholder: String)

    case textView(placeholder: String)

    case button(_ sectionIndex: Int)

    case seperator(_ sectionIndex: Int)

    case custom(status: AsyncStatus)

    var cellIdentifier: String {
        switch self {
        case .textField(_):
            return "EditProfileTextFieldCell"
        case .textView(_):
            return "EditProfileTextViewCell"
        case .button:
            return "EditProfileButtonCollectionCell"
        case .seperator:
            return "EditProfileSperatorCell"
        case .custom(let rawValue):
            return rawValue.cellIdentifier
        }
    }
}

enum AsyncStatus: Hashable {
    case none
    case loading
    case showList
    case emptyList

    var cellIdentifier: String {
        switch self {
        case .none:
            return "EditProfileEmptyCell"
        case .loading:
            return "EditProfileActivityIndicatorCell"
        case .showList:
            return "EditProfileListCell"
        case .emptyList:
            return "EditProfileEmptyListCell"
        }
    }
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
