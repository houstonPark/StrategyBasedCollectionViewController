//
//  StrategyViewController.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/16.
//

import UIKit
import Combine

class StrategyViewController: UICollectionViewController {
    //MARK: - Public Variables
    
    public var strategy: StrategyProtocol
    
    public var dataSource: UICollectionViewDiffableDataSource<Int, AnyHashable>?
    
    public var cancellable = Set<AnyCancellable>()
    
    //MARK: - Init
    init(strategy: StrategyProtocol) {
        self.strategy = strategy
        super.init(collectionViewLayout: self.strategy.compositionalLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.collectionView.backgroundColor = .systemBackground
        self.registerCells()
        self.setupDataSource()
        self.setupLayout()
        self.subscribeCurrentItems()
        self.strategy.requestWhenViewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.strategy.selectCell(self, collectionView: collectionView, at: indexPath)
    }
    
    //MARK: - Strategy Setup
    
    private func registerCells() {
        self.strategy.sections.forEach { sectionIdentifier in
            if let cellIdentifiers = self.strategy.cellIndentifier[sectionIdentifier] {
                cellIdentifiers.forEach { cellIdentifier in
                    self.collectionView.register(UINib(nibName: cellIdentifier, bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
                }
            }
            
            if let headerIdentifier = self.strategy.supplementaryHeaderIdentifier[sectionIdentifier] {
                self.collectionView.register(UINib(nibName: headerIdentifier, bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
            }
            
            if let footerIdentifier = self.strategy.supplementaryFooterIdentifier[sectionIdentifier] {
                self.collectionView.register(UINib(nibName: footerIdentifier, bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
            }
        }
    }
    
    private func setupDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return self.strategy.cellForItemAt(collectionView, at: indexPath, item: itemIdentifier)
        })
    }
    
    private func setupLayout() {
        self.collectionView.collectionViewLayout = self.strategy.compositionalLayout
    }
    
    private func subscribeCurrentItems() {
        self.strategy.currentItems
            .sink { currentItems in
                DispatchQueue.main.async {
                    let snapshot = self.strategy.makeSnapshotFromCurrentItems()
                    self.dataSource?.apply(snapshot)
                }
            }
            .store(in: &self.cancellable)
    }
}
