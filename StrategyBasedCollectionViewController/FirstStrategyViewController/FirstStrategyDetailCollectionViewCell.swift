//
//  FirstStrategyDetailCollectionViewCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/08.
//

import UIKit

class FirstStrategyDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    public func configure(imageURL: String, instruction: String) {
        guard let url = URL(string: imageURL) else { return }
        
    }
}
