//
//  FirstStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import Foundation
import UIKit



struct FirstStrategy: FirstStrategyProtocol {

    var interSectionSpacing: CGFloat = 10
    
    var topViewType: TopViewType = .textField
    
    var topViewHeight: CGFloat = 50
    
    var interSpacingBetweenTopViewCollectionView: CGFloat = 10
    
    var cellReuseIdentifiers: [String] = ["FirstStrategyCollectionViewCell"]
    
    var createSnapshotItem: [Drink] = []
    
    func numberOfItems(_ collectionView: UICollectionView, section: Int) -> Int {
        return 1
    }
    
    func sectionItemLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    }
    
    func sectionGroupLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<FirstStrategySection, Drink> {
        var snapshot = NSDiffableDataSourceSnapshot<FirstStrategySection, Drink>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.createSnapshotItem)
        return snapshot
    }
    
    func createSnapshot(item: [Drink]) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Drink> {
        var snapshot = NSDiffableDataSourceSnapshot<FirstStrategySection, Drink>()
        snapshot.appendSections([.main])
        snapshot.appendItems(item)
        return snapshot
    }
    
    func requestForInit() -> apiRequestItem? {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "s", value: ""))
        let item = apiRequestItem(url: APIManger.shared.baseURLString, header: nil, parameter: nil, queryItems: queryItems, method: "GET")
        return item
    }
    
    func requestFromHeaderView() -> apiRequestItem? {
        return nil
    }
    
    func requestFromCollectionView() -> apiRequestItem? {
        return nil
    }
    
    func selectCell(_ navigationController: UINavigationController?, collectionView: UICollectionView, at selectedItemAt: IndexPath) {
        print(1)
        guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<FirstStrategySection, Drink> else { return }
        print(2)
        guard let item = dataSource.itemIdentifier(for: selectedItemAt) else { return }
        print(3)
        let vc = FirstStrategyViewController.create(strategy: FirstStrategyDetail(item: [item]))
        print(4)
        navigationController?.pushViewController(vc, animated: true)
    }
}
