//
//  FirstStrategyProtocl.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import UIKit

enum FirstStrategySection: CaseIterable {
    case main
}

enum TopViewType {
    case textField
    case stackView
    case textView
    case unknown
}

protocol FirstStrategyProtocol {
    
    var topViewType: TopViewType { get }
    
    var topViewHeight: CGFloat { get }
    
    var interSpacingBetweenTopViewCollectionView: CGFloat { get }
    
    var cellReuseIdentifiers: [String] { get }
    
    var interSectionSpacing: CGFloat { get }
    
    var createSnapshotItem: [Drink] { get }
    
    func numberOfItems(_ collectionView: UICollectionView, section: Int) -> Int
    
    func sectionItemLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize
    
    func sectionGroupLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<FirstStrategySection, Drink>
    
    func createSnapshot(item: [Drink]) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Drink>

    func requestForInit() -> apiRequestItem?
    
    func requestFromHeaderView() -> apiRequestItem?
    
    func requestFromCollectionView() -> apiRequestItem?
    
    func selectCell(_ navigationController: UINavigationController?, collectionView: UICollectionView, at selectedItemAt: IndexPath)
    
    func configureCell(_ collectionView: UICollectionView, cellItendifier: String, indexPath: IndexPath, item: Drink) -> UICollectionViewCell
}
