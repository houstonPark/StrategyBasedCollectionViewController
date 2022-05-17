//
//  SecondStrategyViewController.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/11.
//

import UIKit
import Combine

class SecondStrategyCollectionViewController<Strategy>: UICollectionViewController where Strategy: SecondStrategyProtocol {
    
    public var strategy: Strategy
    public var cancellable = Set<AnyCancellable>()
    public var dataSource : UICollectionViewDiffableDataSource<SecondStrategySection, Strategy.collectionViewItemType>?
    private var viewModel : SecondStrategyViewModel<Strategy.requestItemType>
    
    init(strategy: Strategy) {
        self.strategy = strategy
        self.viewModel = SecondStrategyViewModel<Strategy.requestItemType>()
        super.init(collectionViewLayout: strategy.compositionalLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.view.backgroundColor = .systemBackground
        self.collectionView.backgroundColor = .systemBackground
        self.registerCells()
        self.setupDataSource()
        self.subscribeCurrentItems()
        self.collectionView.keyboardDismissMode = .onDrag
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createInitialSnapshot()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.strategy.selectCell(self, collectionView: collectionView, at: indexPath)
    }
    
    private func setupNavigationBar() {
        self.setupNavigationItem()
        self.strategy.bindingRightBarButtonEnable(navigationItem: self.navigationItem.rightBarButtonItem)
        self.navigationItem.title = self.strategy.navigationTitle
    }
    
    private func setupNavigationItem() {
        guard let button = self.strategy.rightNavigationBarItem else { return }
        button.target = self
        button.action = #selector(navigationButtonAction(_:))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func navigationButtonAction(_ sender: UIBarButtonItem) {
        self.strategy.rightBarButtonAction(self)
    }
    
    private func registerCells() {
        self.strategy.cellIndentifier.forEach {
            $0.value.forEach { identifier in
                self.collectionView.register(UINib(nibName: identifier, bundle: .main), forCellWithReuseIdentifier: identifier)
            }
        }
        self.strategy.supplementaryHeaderIdentifier.forEach {
            self.collectionView.register(UINib(nibName: $0.value, bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: $0.value)
        }
        self.strategy.supplementaryFooterIdentifier.forEach {
            self.collectionView.register(UINib(nibName: $0.value, bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: $0.value)
        }
    }

    private func setupDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cellIdentifier = self.strategy.cellIndentifier[SecondStrategySection.allCases[indexPath.section]] else { return UICollectionViewCell() }
            return self.strategy.configureCell(collectionView, cellItendifiers: cellIdentifier, indexPath: indexPath, item: itemIdentifier)
        })
        
        self.dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let identifiable = SecondStrategySection.allCases[(indexPath as NSIndexPath).section]
            // 그냥 indexPath.section 하면 터지는 오모한 버그 때문에 (indexPath as NSIndexPath).section 으로 해야지 안터진다... 왜지?
            return self.strategy.supplementaryViewProvider(collectionView, elementKind: kind, identifiable: identifiable, indexPath: indexPath as NSIndexPath)
        }
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
            self.request(item: apiItem)
        }
        else {
            self.dataSourceApply()
        }
    }

    private func dataSourceApply() {
        DispatchQueue.main.async {
            let snapshot = self.strategy.createSnapshot()
            self.dataSource?.apply(snapshot)
        }
    }

    private func request(item: apiRequestItem) {
        self.viewModel.request(apiItem: item)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("<Error>",error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { requestData in
                self.strategy.convertDataToItem(requestData: requestData)
            }
            .store(in: &self.cancellable)
    }
}
