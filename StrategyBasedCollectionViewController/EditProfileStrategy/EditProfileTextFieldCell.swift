//
//  EditProfileTextFieldCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine
import QDSKit

class EditProfileCollectionViewCell: UICollectionViewCell {

}

class EditProfileTextFieldCell: UICollectionViewCell {
    
    @IBOutlet weak var textField: QDSTextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.clearButtonMode = .whileEditing
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textField.errorMessage = nil
    }
    
    public func configure(text: String, placeholder: String, data: DiffableData) {
        self.textField.placeholder = placeholder
        self.textField.text = text
        switch data.textStatus {
        case .plain:
            self.textField.message = data.message
        case .error:
            self.textField.errorMessage = data.message
        case .disable:
            self.textField.isEnabled = false
            self.textField.message = data.message
        }
    }
}
