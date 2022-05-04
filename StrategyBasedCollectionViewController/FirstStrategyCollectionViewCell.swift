//
//  FirstStrategyCollectionViewCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import UIKit

class FirstStrategyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var alcoholic: UILabel!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var dataLabel: UILabel!


    public func configure(drink: String, instructions: String, date: String) {
        self.alcoholic.text = drink
        self.instructions.text = instructions
        self.dataLabel.text = date
    }
}
