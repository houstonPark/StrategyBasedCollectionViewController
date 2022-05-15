//
//  SecondStrategyMemo.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/15.
//

import UIKit
import Combine

struct SecondStrategyMemo: SecondStrategyProtocol {
    
    typealias collectionViewItemType = String
    
    typealias requestItemType = String

    var collectionViewItem: String = "empty"
    
    var requestItem: String = "empty"
    
    var sections: [SecondStrategySection] = [.main]
    
    var supplementaryHeaderIdentifier: [SecondStrategySection : String] = [:]
    
    var supplementaryFooterIdentifier: [SecondStrategySection : String] = [:]
    
    var cellIndentifier: [SecondStrategySection : [String]] = [.main: ["SecondStrategyMemoCell"]]
    
    var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = self.sectionItemLayoutSize(at: sectionIndex)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = self.sectionGroupLayoutSize(at: sectionIndex)
            
            let itemCount = self.numberOfItems(section: sectionIndex)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: itemCount)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        layout.configuration = self.compositionalLayoutConfigure
        return layout
    }
    
    var compositionalLayoutConfigure: UICollectionViewCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
    
    var currentItems: CurrentValueSubject<[SecondStrategySection : [String]], Never> = .init([.main: ["Memo"]])
    
    var rightNavigationBarItem: UIBarButtonItem? = nil
    
    var navigationTitle: String? = nil
    
    func numberOfItems(section: Int) -> Int {
        return 1
    }
    
    func sectionItemLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    }
    
    func sectionGroupLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<SecondStrategySection, String> {
        var snapshot = NSDiffableDataSourceSnapshot<SecondStrategySection, String>()
        snapshot.appendSections(self.sections)
        SecondStrategySection.allCases.forEach { section in
            guard let items = self.currentItems.value[section] else {
                return
            }
            snapshot.appendItems(items, toSection: section)
        }
        return snapshot
    }
    
    func requestForInit() -> apiRequestItem? {
        return nil
    }
    
    func requestFromHeaderView(searchText: String) -> apiRequestItem? {
        return nil
    }
    
    func requestFromFooterView(searchText: String) -> apiRequestItem? {
        return nil
    }
    
    func convertDataToItem<RequestData>(requestData: RequestData) where RequestData : Decodable, RequestData : Encodable, RequestData : Hashable { }
    
    func selectCell(_ viewController: UIViewController, collectionView: UICollectionView, at selectedItemAt: IndexPath) { }
    
    func configureCell(_ collectionView: UICollectionView, cellItendifiers: [String], indexPath: IndexPath, item: String) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch indexPath.section {
        case 0:
            let memoCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItendifiers[0], for: indexPath) as! SecondStrategyMemoCell
            cell = memoCell
        default:
            break
        }
        
        return cell
    }
    
    func supplementaryViewProvider(_ collectionView: UICollectionView, elementKind: String, identifiable: SecondStrategySection, indexPath: NSIndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    func rightBarButtonAction(_ viewController: UIViewController) {}
    
    func bindingRightBarButtonEnable(navigationItem: UIBarButtonItem?) {}
    
}
