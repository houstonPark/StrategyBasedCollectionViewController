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
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.textView.text = ""
    }
    
    public func configure(imageURL: String, instruction: String) {
        guard let url = URL(string: imageURL) else { return }
        var data = Data()
        do {
            data = try Data(contentsOf: url)
        } catch { return }
        guard let uiimage = UIImage(data: data) else { return }
        self.imageView.image = uiimage
        self.textView.text = instruction
    }
}
