//
//  FirstStrategyCollectionViewCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import UIKit

class FirstStrategyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    public func configure(date: String, title: String) {
        self.dateLabel.text = date
        self.titleLabel.text = title
    }
}
