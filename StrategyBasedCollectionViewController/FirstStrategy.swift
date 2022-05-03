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
    
    
    func numberOfItems(_ collectionView: UICollectionView, section: Int) -> Int {
        return 3
    }
    
    func loadTopView(view: UIView, subView: UIView) {
        view.addSubview(subView)
        
        let leftConstraint = subView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = subView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let topConstraint = subView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomConstraint = subView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        subView.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func sectionItemLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
    }
    
    func sectionGroupLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return sectionItemLayoutSize(collectionView, at: sectionIndex)
    }
    
    func createDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<FirstStrategySection, Movie> {
        let diffableDataSource = UICollectionViewDiffableDataSource<FirstStrategySection, Movie>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstStrategyCollectionViewCell", for: indexPath) as! FirstStrategyCollectionViewCell
            cell.configure(date: itemIdentifier.Year, title: itemIdentifier.Title)
            return cell
        }
        
        return diffableDataSource
    }
    
    func createSnapshot(item: [Movie]) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Movie> {
        var snapshot = NSDiffableDataSourceSnapshot<FirstStrategySection, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(item , toSection: .main)
        
        return snapshot
    }
    
    func updateSnapshot(_ collectionView: UICollectionView, searchTarget: String) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Movie> {
        let dataSource = self.createDiffableDataSource(collectionView)
        let currentSnapshot = dataSource.snapshot()
        let currentItem = currentSnapshot.itemIdentifiers
        let filteredItem = currentItem.filter { movie in
            movie.Title.contains(searchTarget)
        }
        let filteredSnapshot = self.createSnapshot(item: filteredItem)
        return filteredSnapshot
    }
    
    
    func appendSnapshot(_ collectionView: UICollectionView, item: [Movie]) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Movie> {
        var dataSource = self.createDiffableDataSource(collectionView)
        var snapshot = dataSource.snapshot()
        return snapshot
    }
    
    func requestForInit() -> apiRequestItem? {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "r", value: "json"))
        let item = apiRequestItem(url: APIManger.shared.baseURLString, header: APIManger.shared.headers, parameter: nil, queryItems: queryItems, method: "GET")
        return item
    }
    
    func requestFromHeaderView() -> apiRequestItem? {
        return nil
    }
    
    func requestFromCollectionView() -> apiRequestItem? {
        return nil
    }
    
    
}
