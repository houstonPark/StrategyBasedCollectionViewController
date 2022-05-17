//
//  StrategyProtocol.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/16.
//

import UIKit
import Combine

protocol StrategyProtocol {

    var sections : [Int] { get }
    
    var supplementaryHeaderIdentifier: [Int : String] { get }
    
    var supplementaryFooterIdentifier:  [Int : String] { get }
    
    var cellIndentifier:  [Int : [String]] { get }
    
    var compositionalLayout: UICollectionViewCompositionalLayout { get }

    var currentItems: CurrentValueSubject<[Int : [AnyHashable]], Never> { get set }
    
    func sectionItemLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize
    
    func sectionGroupLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize
    
    func makeSnapshotFromCurrentItems() -> NSDiffableDataSourceSnapshot<Int, AnyHashable>
    
    func requestWhenViewDidLoad()
    
    func makeApiRequestItem(at sectionIndex: Int) -> apiRequestItem?
    
    func request(apiItem: apiRequestItem, item: AnyHashable)
    
    func selectCell(_ viewController: UIViewController, collectionView: UICollectionView, at selectedItemAt: IndexPath)
    
    func cellForItemAt(_ collectionView: UICollectionView, at indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell
    
    func viewForSupplementary(_ collectionView: UICollectionView, elementKind: String, indexPath: NSIndexPath) -> UICollectionReusableView?
    
    func bindingNavigationItem(navigationItem: UINavigationItem?)
}
