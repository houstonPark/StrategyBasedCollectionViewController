//
//  ViewController.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//f

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Strategy1Action(_ sender: Any) {
        let firstStrategyVC = FirstStrategyViewController.create(strategy: FirstStrategy())
        self.navigationController?.pushViewController(firstStrategyVC, animated: true)
    }
    
    @IBAction func Strategy2Action(_ sender: Any) {
        let secondStrategy = SecondStrategy()
        let secondStrategyVC = SecondStrategyCollectionViewController<SecondStrategy>(strategy: secondStrategy)
        self.navigationController?.pushViewController(secondStrategyVC, animated: true)
    }
    
    @IBAction func CategoryAction(_ sender: Any) {
        let strategy = Strategy()
        let strategyVC = StrategyViewController(strategy: strategy)
        self.navigationController?.pushViewController(strategyVC, animated: true)
    }
    
}

