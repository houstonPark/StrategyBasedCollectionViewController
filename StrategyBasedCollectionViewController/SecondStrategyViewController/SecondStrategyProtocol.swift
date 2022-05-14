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
    
    associatedtype collectionViewItemType : Codable, Hashable
    
    associatedtype requestItemType : Codable, Hashable
    
    var collectionViewItem: collectionViewItemType { get }
    
    var requestItem: requestItemType { get }
    
    var sections : [SecondStrategySection] { get set }
    
    var supplementaryHeaderIdentifier: [SecondStrategySection : String] { get }
    
    var supplementaryFooterIdentifier:  [SecondStrategySection : String] { get }
    
    var cellIndentifier:  [SecondStrategySection : [String]] { get }
    
    var compositionalLayout: UICollectionViewCompositionalLayout { get }

    var compositionalLayoutConfigure: UICollectionViewCompositionalLayoutConfiguration { get }
    
    var currentItems: CurrentValueSubject<[SecondStrategySection: [collectionViewItemType]], Never> { get set }
        
    func numberOfItems(section: Int) -> Int
    
    func sectionItemLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize
    
    func sectionGroupLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize

    func createSnapshot()-> NSDiffableDataSourceSnapshot<SecondStrategySection, collectionViewItemType>
    
    func requestForInit() -> apiRequestItem?
    
    func requestFromHeaderView(searchText: String) -> apiRequestItem?
    
    func requestFromFooterView(searchText: String) -> apiRequestItem?
    
    func convertDataToItem<RequestData>(requestData: RequestData) where RequestData : Hashable & Codable
    
    func selectCell(_ navigationController: UINavigationController?, collectionView: UICollectionView, at selectedItemAt: IndexPath)
    
    func configureCell(_ collectionView: UICollectionView, cellItendifiers: [String], indexPath: IndexPath, item: collectionViewItemType) -> UICollectionViewCell
    
    mutating func supplementaryViewProvider(_ collectionView: UICollectionView, elementKind: String, identifiable: SecondStrategySection, indexPath: NSIndexPath) -> UICollectionReusableView
}
