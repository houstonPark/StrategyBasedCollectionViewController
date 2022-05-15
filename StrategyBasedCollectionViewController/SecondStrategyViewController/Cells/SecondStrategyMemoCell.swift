//
//  SecondStrategyMemoCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/15.
//

import UIKit
import Combine

class SecondStrategyMemoCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    private var cancellable = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.countLabel.text = "0/100"
        self.textView.textPublisher
            .sink { text in
                guard let count = text?.count else {
                    return
                }
                self.countLabel.text = "\(count)/100"
            }
            .store(in: &self.cancellable)
    }
}
