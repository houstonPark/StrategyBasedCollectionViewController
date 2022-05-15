//
//  CombineCocoa.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/15.
//

import UIKit
import Combine

//MARK: - UITextField textPublisher

extension UITextField {

    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map {
                ($0.object as? UITextField)?.text
            }
            .eraseToAnyPublisher()
    }

}

//MARK: - UITextView textPublisher

extension UITextView {

    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
            .map {
                ($0.object as? UITextView)?.text
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - UIBarButtonItem UIControlPublisher

extension UIBarButtonItem {
    
    var actionPublisher: AnyPublisher<Void, Never> {
        
    }
}
