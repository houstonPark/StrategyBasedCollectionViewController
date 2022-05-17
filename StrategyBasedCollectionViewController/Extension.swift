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

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
