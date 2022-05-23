//
//  EditProfileButtonCollectionCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import QDSKit

class EditProfileButtonCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var labelBackground: UIView!

    public func configure(text: String?, isSelected: Bool) {
        self.buttonLabel.text = text
        self.buttonLabel.textColor = isSelected ? QDS.Color.white : QDS.Color.gray070
        self.labelBackground.backgroundColor = isSelected ? QDS.Color.gray100 : QDS.Color.gray010
    }
}

