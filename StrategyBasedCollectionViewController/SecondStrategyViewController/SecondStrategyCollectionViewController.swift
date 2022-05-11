//
//  SecondStrategyViewController.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/11.
//

import UIKit
import Combine

class SecondStrategyCollectionViewController<Item>: UICollectionViewController where Item: Codable, Item: Hashable {
    
    var strategy : SecondStrategyProtocol!
    var viewModel : SecondStrategyViewModel<Item>!
    private var dataSource : UICollectionViewDiffableDataSource<SecondStrategySection, Item>?
    private var cancellable = Set<AnyCancellable>()
    
    static func create<vcItem>(strategy: SecondStrategyProtocol) -> SecondStrategyCollectionViewController<vcItem> where vcItem: Codable, vcItem: Hashable {
        let vc = UIStoryboard(name: "SecondStrategyCollectionViewController", bundle: .main).instantiateViewController(withIdentifier: "SecondStrategyCollectionViewController") as! SecondStrategyCollectionViewController<vcItem>
        vc.strategy = strategy
        vc.viewModel = SecondStrategyViewModel<vcItem>()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.setupLayout()
        self.setupDataSource()
        self.subscribeCurrentItems()
        self.collectionView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createInitialSnapshot()
    }
    
    
    private func registerCells() {
        self.strategy.cellIndentifier.forEach {
            self.collectionView.register(UINib(nibName: $0.value, bundle: .main), forCellWithReuseIdentifier: $0.value)
        }
        self.strategy.supplymentaryHeaderIdentifier.forEach {
            self.collectionView.register(UINib(nibName: $0.value, bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: $0.value)
        }
        self.strategy.supplymentaryFooterIdentifier.forEach {
            self.collectionView.register(UINib(nibName: $0.value, bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: $0.value)
        }
    }
    
    private func setupLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = self.strategy.sectionItemLayoutSize(self.collectionView, at: sectionIndex)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = self.strategy.sectionGroupLayoutSize(self.collectionView, at: sectionIndex)

            let itemCount = self.strategy.numberOfItems(self.collectionView, section: sectionIndex)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: itemCount)

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        layout.configuration = strategy.compositionalLayoutConfigure
        self.collectionView.collectionViewLayout = layout
    }
    
    private func setupDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cellIdentifier = self.strategy.cellIndentifier[SecondStrategySection.allCases[indexPath.section]] else { return UICollectionViewCell() }
            return self.strategy.configureCell(collectionView, cellItendifier: cellIdentifier, indexPath: indexPath, item: itemIdentifier)
        })
    }
    
    private func subscribeCurrentItems() {
        self.strategy.currentItems
            .sink { _ in
                self.dataSourceApply()
            }
            .store(in: &self.cancellable)
    }
    
    private func createInitialSnapshot() {
        if self.strategy.currentItems.value.isEmpty {
            guard let apiItem = self.strategy.requestForInit() else { return }
            self.viewModel.request(apiItem: apiItem)
                .sink { completion in
                    switch completion {
                    case let .failure(error):
                        print("<Error>",error.localizedDescription)
                    case .finished:
                        break
                    }
                } receiveValue: { item in
                    DispatchQueue.main.async {
                        self.dataSourceApply()
                    }
                }
                .store(in: &self.cancellable)
        }
        else {
            self.dataSourceApply()
        }
    }
    
    private func dataSourceApply() {
        guard let snapshot = self.strategy.createSnapshot() as? NSDiffableDataSourceSnapshot<SecondStrategySection, Item>, let dataSource = self.dataSource else {
            return
        }
        dataSource.apply(snapshot)
    }
}
