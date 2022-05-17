//
//  SecondStrategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/11.
//

import UIKit
import Combine

class GlobalCancellable {
    static var cancellable = Set<AnyCancellable>()
}

struct SecondStrategy: SecondStrategyProtocol {
    
    typealias collectionViewItemType = Drink
    
    typealias requestItemType = Drinks
    
    var collectionViewItem: Drink = Drink()
    
    var requestItem: Drinks = Drinks()
    
    var sections : [SecondStrategySection] = [.main]
    
    var supplementaryHeaderIdentifier: [SecondStrategySection : String] = [.main: "TextFieldHeaderView"]
    
    var supplementaryFooterIdentifier:  [SecondStrategySection : String] = [:]
    
    var cellIndentifier: [SecondStrategySection : [String]] = [.main: ["FirstStrategyCollectionViewCell"]]
    
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
    
    var compositionalLayoutConfigure: UICollectionViewCompositionalLayoutConfiguration {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = true
        configuration.boundarySupplementaryItems = [header]
        configuration.interSectionSpacing = 20
        return configuration
    }
    
    var currentItems: CurrentValueSubject<[SecondStrategySection : [collectionViewItemType]], Never> = .init([SecondStrategySection: [Drink]]())
    
    var navigationTitle: String? = nil
    
    func numberOfItems(section: Int) -> Int {
        return 1
    }
    
    func sectionItemLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    }
    
    func sectionGroupLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(2/5))
    }
    
    func createSnapshot<Drink>() -> NSDiffableDataSourceSnapshot<SecondStrategySection, Drink> {
        var snapshot = NSDiffableDataSourceSnapshot<SecondStrategySection, Drink>()
        snapshot.appendSections(self.sections)
        SecondStrategySection.allCases.forEach { section in
            guard let items = self.currentItems.value[section] as? [Drink] else {
                return
            }
            snapshot.appendItems(items, toSection: section)
        }
        return snapshot
    }
    
    func requestForInit() -> apiRequestItem? {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "s", value: ""))
        let item = apiRequestItem(url: APIManger.shared.baseURLString, header: nil, parameter: nil, queryItems: queryItems, method: "GET")
        return item
    }
    
    func requestFromHeaderView(searchText: String) -> apiRequestItem? {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "s", value: searchText))
        let item = apiRequestItem(url: APIManger.shared.baseURLString, header: nil, parameter: nil, queryItems: queryItems, method: "GET")
        return item
    }
    
    func requestFromFooterView(searchText: String) -> apiRequestItem? {
        return nil
    }
    
    func convertDataToItem<RequestData>(requestData: RequestData) where RequestData : Hashable & Codable {
        guard requestData is Drinks else { return }
        let drinks = requestData as! Drinks
        guard let drinks = drinks.drinks else { return }
        self.currentItems.send([.main: drinks])
    }
    
    func selectCell(_ viewController: UIViewController, collectionView: UICollectionView, at selectedItemAt: IndexPath) {
        let selectedSection = self.sections[selectedItemAt.section]
        guard let items = self.currentItems.value[selectedSection] else { return }
        let selectedItem = items[selectedItemAt.item]
        let strategy = SecondStrategyDetail(drink: selectedItem)
        let vc = SecondStrategyCollectionViewController<SecondStrategyDetail>(strategy: strategy)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureCell(_ collectionView: UICollectionView, cellItendifiers: [String], indexPath: IndexPath, item: collectionViewItemType) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch indexPath.section {
        case 0:
            let drinkCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItendifiers[0], for: indexPath) as! FirstStrategyCollectionViewCell
            let drinkItem = item as Drink
            drinkCell.configure(drink: drinkItem.strDrink ?? "", instructions: drinkItem.strInstructions ?? "", date: drinkItem.dateModified ?? "")
            cell = drinkCell
        default:
            break
        }
        return cell
    }
    
    func supplementaryViewProvider(_ collectionView: UICollectionView, elementKind: String, identifiable: SecondStrategySection, indexPath: NSIndexPath) -> UICollectionReusableView {
        var reuseableView = UICollectionReusableView()
        guard let reuseIdentifier = self.supplementaryHeaderIdentifier[identifiable] else { return reuseableView }
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            switch (indexPath as NSIndexPath).section {
            case 0:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TextFieldHeaderView
                reuseableView = headerView
                headerView.textField.textPublisher
                    .sink { text in
                        guard let text = text, let apiItem = self.requestFromHeaderView(searchText: text) else { return }
                        print("Text:", text)
                        let viewModel = SecondStrategyViewModel<requestItemType>()
                        viewModel.request(apiItem: apiItem)
                            .sink { completion in
                                switch completion {
                                case let .failure(error):
                                    print("<Error>",error.localizedDescription)
                                case .finished:
                                    break
                                }
                            } receiveValue: { Drinks in
                                print("Drinks:", Drinks)
                                self.currentItems.value[identifiable] = Drinks.drinks
                            }
                            .store(in: &GlobalCancellable.cancellable)
                    }
                    .store(in: &GlobalCancellable.cancellable)
            default:
                reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
            }
        case UICollectionView.elementKindSectionFooter:
            break
        default:
            break
        }
        return reuseableView
    }

    var rightNavigationBarItem: UIBarButtonItem? {
        return createUIBarButton(index: 0, style: .plain, title: nil, image: UIImage(systemName: "doc.text"))
    }

    func rightBarButtonAction(_ viewController: UIViewController) {
        let memoStrategy = SecondStrategyMemo()
        let vc = SecondStrategyCollectionViewController<SecondStrategyMemo>(strategy: memoStrategy)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }

    func bindingRightBarButtonEnable(navigationItem: UIBarButtonItem?) {
        guard let navigationItem = navigationItem else {
            return
        }
        self.currentItems
            .sink { value in
                DispatchQueue.main.async {
                    navigationItem.isEnabled = !value.isEmpty
                    navigationItem.tintColor = value.isEmpty ? .systemGray : .systemBlue
                    print("isEnabled", navigationItem.isEnabled)
                }
            }
            .store(in: &GlobalCancellable.cancellable)
    }
    
    func createUIBarButton(index: Int, style: UIBarButtonItem.Style, title: String?, image: UIImage?) -> UIBarButtonItem {
        let button = UIBarButtonItem()
        button.tag = index
        button.style = style
        if let title = title {
            button.title = title
        }
        if let image = image {
            button.image = image
        }
        return button
    }
}
