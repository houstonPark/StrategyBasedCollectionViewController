//
//  EditProfileTextViewCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine
import QDSKit

class EditProfileTextViewCell: UICollectionViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countingLabel: UILabel!
    
    private var cancellable = Set<AnyCancellable>()
    public var placeholder: String = "상태 메시지를 입력해주세요."
    public var placeholderColor: UIColor = QDS.Color.gray040
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.textPublisher
            .sink { text in
                guard let text = text, text != self.placeholder else { return }
                if text.count <= 50 {
                    self.countingLabel.text = "\(text.count)/50"
                }
            }
            .store(in: &self.cancellable)
    }
}

extension EditProfileTextViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textView.textColor == placeholderColor {
            self.textView.text = nil
            self.textView.textColor = QDS.Color.gray090
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView.text.isEmpty {
            self.textView.text = placeholder
            self.textView.textColor = placeholderColor
        }
    }
}
