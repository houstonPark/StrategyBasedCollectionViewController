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

    var keyboardWillHidePublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.keyboardWillHideNotification, object: self)
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

    var keyboardWillHidePublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextView.keyboardWillHideNotification, object: self)
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

class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    open var itemSpacing: CGFloat = 12

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 16.0
        self.minimumInteritemSpacing = 12
        self.sectionInset = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
        guard let superArray = super.layoutAttributesForElements(in: rect) else { return nil }

        guard let attributes = NSArray(array: superArray, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }


        var leftMargin = sectionInset.left
        var maxY: CGFloat = .leastNormalMagnitude
        attributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + itemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
