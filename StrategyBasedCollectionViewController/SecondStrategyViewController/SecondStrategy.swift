//
//  SecondStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/11.
//

import UIKit
import Combine

struct SecondStrategy: SecondStrategyProtocol {    
    
    var supplymentaryHeaderIdentifier: [SecondStrategySection : String] = [.main: "TextFieldHeaderView"]
    
    var supplymentaryFooterIdentifier:  [SecondStrategySection : String] = [:]
    
    var cellIndentifier: [SecondStrategySection : String] = [:]
    
    var compositionalLayoutConfigure: UICollectionViewCompositionalLayoutConfiguration
    
    var currentItems: CurrentValueSubject<[SecondStrategySection : [AnyHashable]], Never> = .init([SecondStrategySection: [Drink]]())
    
    func numberOfItems(_ collectionView: UICollectionView, section: Int) -> Int {
        return 1
    }
    
    func sectionItemLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    }
    
    func sectionGroupLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(2/5))
    }
    
    func createSnapshot<Drink>() -> NSDiffableDataSourceSnapshot<SecondStrategySection, Drink> {
        var snapshot = NSDiffableDataSourceSnapshot<SecondStrategySection, Drink>()
        SecondStrategySection.allCases.forEach { section in
            guard let items = self.currentItems.value[section] as? [Drink] else {
                return
            }
            snapshot.appendItems(items, toSection: section)
        }
        return snapshot
    }
    
    func requestForInit() -> apiRequestItem? {
        return nil
    }
    
    func requestFromHeaderView(section: SecondStrategySection) -> apiRequestItem? {
        return nil
    }
    
    func requestFromFooterView(section: SecondStrategySection) -> apiRequestItem? {
        return nil
    }
    
    func selectCell(_ navigationController: UINavigationController?, collectionView: UICollectionView, at selectedItemAt: IndexPath) {
        
    }
    
    func configureCell(_ collectionView: UICollectionView, cellItendifier: String, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
