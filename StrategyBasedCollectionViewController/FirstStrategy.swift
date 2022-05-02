//
//  FirstStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import Foundation
import UIKit



struct FirstStrategy: FirstStrategyProtocol {
    
    var topViewType: TopViewType = .textField
    
    var topViewHeight: CGFloat = 50
    
    var interSpacingBetweenTopViewCollectionView: CGFloat = 10
    
    var cellReuseIdentifiers: [String] = ["FirstStrategyCollectionViewCell"]
    
    func loadTopView(view: UIView, subView: UIView) {
        view.addSubview(subView)
        
        let leftConstraint = subView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = subView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let topConstraint = subView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomConstraint = subView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        subView.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func sectionItemLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
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
    
    func updateSnapshot() -> NSDiffableDataSourceSnapshot<FirstStrategySection, Movie> {
        return NSDiffableDataSourceSnapshot<FirstStrategySection, Movie>()
    }
    
    func updateSnapshot(response: URLResponse) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Movie> {
        return NSDiffableDataSourceSnapshot<FirstStrategySection, Movie>()
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
