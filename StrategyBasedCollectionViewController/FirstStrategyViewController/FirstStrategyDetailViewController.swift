//
//  FirstStrategyDetailViewController.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/08.
//

import UIKit
import Combine

class FirstStrategyDetailViewController: UIViewController, UICollectionViewDelegate {
    
    private var strategy: FirstStrategyProtocol!
    private var viewModel: FirstStrategyViewModel!
    private var cancellable = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<FirstStrategySection, Drink>?
    
    static func create(strategy: FirstStrategyProtocol) -> FirstStrategyDetailViewController {
        
        return FirstStrategyDetailViewController()
    }
}
