//
//  EditProfileButtonCollectionCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import QDSKit

class EditProfileButtonCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonLabel: PaddingLabel!
    
    public func configure(text: String?, isSelected: Bool) {
        self.buttonLabel.text = text
        self.buttonLabel.textColor = isSelected ? QDS.Color.white : QDS.Color.gray070
        self.buttonLabel.backgroundColor = isSelected ? QDS.Color.gray100 : QDS.Color.gray010
    }
}

