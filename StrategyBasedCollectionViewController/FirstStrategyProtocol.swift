//
//  FirstStrategyProtocl.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import UIKit

enum FirstStrategySection: CaseIterable {
    case main
}

enum TopViewType {
    case textField
    case stackView
    case textView
    case unknown
}

struct apiRequestItem {
    var url: String
    var header: [String: String]?
    var parameter: [String: String]?
    var queryItems: [URLQueryItem]?
    var method: String
}

protocol FirstStrategyProtocol {
    
    var topViewType: TopViewType { get }
    
    var topViewHeight: CGFloat { get }
    
    var interSpacingBetweenTopViewCollectionView: CGFloat { get }
    
    var cellReuseIdentifiers: [String] { get }
    
    var interSectionSpacing: CGFloat { get }
    
    func numberOfItems(_ collectionView: UICollectionView, section: Int) -> Int
    
    func loadTopView(view: UIView, subView: UIView)
    
    func sectionItemLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize
    
    func sectionGroupLayoutSize(_ collectionView: UICollectionView, at sectionIndex: Int) -> NSCollectionLayoutSize
    
    func createDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<FirstStrategySection, Movie>
    
    func createSnapshot(item: [Movie]) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Movie>
    
    func updateSnapshot(_ collectionView: UICollectionView, searchTarget: String) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Movie>
    
    func appendSnapshot(_ collectionView: UICollectionView, item: [Movie]) -> NSDiffableDataSourceSnapshot<FirstStrategySection, Movie>
    
    func requestForInit() -> apiRequestItem?
    
    func requestFromHeaderView() -> apiRequestItem?
    
    func requestFromCollectionView() -> apiRequestItem?
    
}
