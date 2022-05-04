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
        return 1
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
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    }
    
    func sectionGroupLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
    }
    
    func createSnapshot(item: [Drink]) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Drink> {
        var snapshot = NSDiffableDataSourceSnapshot<FirstStrategySection, Drink>()
        snapshot.appendSections([.main])
        snapshot.appendItems(item)
        return snapshot
    }
    
    func updateSnapshot(_ collectionView: UICollectionView, searchTarget: String) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Drink> {
        var snapshot = NSDiffableDataSourceSnapshot<FirstStrategySection, Drink>()
        return snapshot
    }
    
    
    func appendSnapshot(_ collectionView: UICollectionView, item: [Drink]) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Drink> {
        var snapshot = NSDiffableDataSourceSnapshot<FirstStrategySection, Drink>()
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
    
    
}
