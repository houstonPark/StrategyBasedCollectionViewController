//
//  FirstStrategyDetail.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/09.
//

import UIKit
import Combine

struct FirstStrategyDetail: FirstStrategyProtocol {
    
    init(item: [Drink]) {
        self.createSnapshotItem = item
    }
    
    var topViewType: TopViewType = .unknown
    
    var topViewHeight: CGFloat = 0
    
    var interSpacingBetweenTopViewCollectionView: CGFloat = 0
    
    var cellReuseIdentifiers: [String] = ["FirstStrategyDetailCollectionViewCell"]
    
    var interSectionSpacing: CGFloat = 0
    
    var createSnapshotItem: [Drink]
    
    func numberOfItems(_ collectionView: UICollectionView, section: Int) -> Int {
        return 1
    }
    
    func sectionItemLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
    }
    
    func sectionGroupLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<FirstStrategySection, Drink> {
        var snapshot = NSDiffableDataSourceSnapshot<FirstStrategySection, Drink>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.createSnapshotItem)
        return snapshot
    }
    
    func createSnapshot(item: [Drink]) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Drink> {
        self.createSnapshot()
    }
    
    func requestForInit() -> apiRequestItem? {
        return nil
    }
    
    func requestFromHeaderView() -> apiRequestItem? {
        return nil
    }
    
    func requestFromCollectionView() -> apiRequestItem? {
        return nil
    }
    
    func selectCell(_ navigationController: UINavigationController?, collectionView: UICollectionView,at selectedItemAt: IndexPath) {}
    
    func configureCell(_ collectionView: UICollectionView, cellItendifier: String, indexPath: IndexPath, item: Drink) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItendifier, for: indexPath) as? FirstStrategyDetailCollectionViewCell else { return UICollectionViewCell() }
        guard let imageURL = item.strDrinkThumb, let instructions = item.strInstructions else { return cell }
        cell.configure(imageURL: imageURL, instruction: instructions)
        return cell
    }
}
