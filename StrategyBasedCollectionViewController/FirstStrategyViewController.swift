//
//  FirstStrategyViewController.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import UIKit

class FirstStrategyViewController: UIViewController, UICollectionViewDelegate {
    
    var strategy: FirstStrategyProtocol!
    
    init(strategy: FirstStrategyProtocol) {
        super.init(nibName: "FirstStrategyViewController", bundle: .main)
        self.strategy = strategy
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var topStackView: UIStackView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet var topTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
