//
//  CategoryCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/17.
//

import UIKit
import Combine

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UILabel!
    
    public func configure(buttonTitle: String) {
        self.button.text = buttonTitle
    }
}
