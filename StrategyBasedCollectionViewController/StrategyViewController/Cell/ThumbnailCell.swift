//
//  ThumbnailCell.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/17.
//

import UIKit
import Combine

class ThumbnailCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.imageView.image = UIImage()
    }
    
    public func configure(title: String, imageURL: String) {
        self.titleLabel.text = title
        self.imageView.load(urlString: imageURL)
    }
}
