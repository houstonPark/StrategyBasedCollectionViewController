//
//  SecondStrategyProtocol.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/10.
//

import UIKit
import Combine

enum SecondStrategySection: CaseIterable {
    case main
}

protocol SecondStrategyProtocol {
    
    var supplymentaryHeaderIdentifier: [SecondStrategySection : String] { get }
    
    var supplymentaryFooterIdentifier:  [SecondStrategySection : String] { get }
    
    var cellIndentifier:  [SecondStrategySection : String] { get }

    var compositionalLayoutConfigure: UICollectionViewCompositionalLayoutConfiguration { get }
    
    var currentItems: CurrentValueSubject<[SecondStrategySection: [AnyHashable]], Never> { get set }
        
    func numberOfItems(_ collectionView: UICollectionView, section: Int) -> Int
    
    func sectionItemLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize
    
    func sectionGroupLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize

    func createSnapshot()-> NSDiffableDataSourceSnapshot<SecondStrategySection, AnyHashable>
    
    func requestForInit() -> apiRequestItem?
    
    func requestFromHeaderView(section: SecondStrategySection) -> apiRequestItem?
    
    func requestFromFooterView(section: SecondStrategySection) -> apiRequestItem?
    
    func selectCell(_ navigationController: UINavigationController?, collectionView: UICollectionView, at selectedItemAt: IndexPath)
    
    func configureCell(_ collectionView: UICollectionView, cellItendifier: String, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell
    
}
