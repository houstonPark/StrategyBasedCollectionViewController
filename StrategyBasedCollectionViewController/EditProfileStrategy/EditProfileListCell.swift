//
//  EditProfileListCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/23.
//

import UIKit

class EditProfileListCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!

    public func configure(label: String) {
        self.label.text = label
    }
}
