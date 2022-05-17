//
//  Strategy.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/17.
//

import UIKit
import Combine

struct Strategy: StrategyProtocol {
    
    var sections: [Int] = [0, 1]
    
    var supplementaryHeaderIdentifier: [Int : String] = [:]
    
    var supplementaryFooterIdentifier: [Int : String] = [:]
    
    var cellIndentifier: [Int : [String]] = [
        0: ["CategoryCell"],
        1: ["ThumbnailCell"]
    ]
    
    var compositionalLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { index, _ in
            let itemSize = self.sectionItemLayoutSize(at: index)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = self.sectionGroupLayoutSize(at: index)
            var group = NSCollectionLayoutGroup(layoutSize: groupSize)
            switch index {
            case 0:
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            case 1:
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            default:
                break
            }
            let section = NSCollectionLayoutSection(group: group)
            if index == 0 {
                section.orthogonalScrollingBehavior = .continuous
            }
            return section
        }
        return layout
    }
    
    var currentItems: CurrentValueSubject<[Int : [AnyHashable]], Never> = .init([:])
    
    func sectionItemLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize {
        switch sectionIndex {
        case 0, 1:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        default:
            return NSCollectionLayoutSize(widthDimension: .absolute(0), heightDimension: .absolute(0))
        }
    }
    
    func sectionGroupLayoutSize(at sectionIndex: Int) -> NSCollectionLayoutSize {
        switch sectionIndex {
        case 0:
            return NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(70))
        case 1:
            return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        default:
            return NSCollectionLayoutSize(widthDimension: .absolute(0), heightDimension: .absolute(0))
        }
    }
    
    func makeSnapshotFromCurrentItems() -> NSDiffableDataSourceSnapshot<Int, AnyHashable> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        snapshot.appendSections(self.sections)
        self.sections.forEach { sectionIndex in
            switch sectionIndex {
            case 0:
                if let items = self.currentItems.value[sectionIndex] as? [DrinkCategory] {
                    snapshot.appendItems(items, toSection: sectionIndex)
                }
                break
            case 1:
                if let items = self.currentItems.value[sectionIndex] as? [Drink] {
                    snapshot.appendItems(items, toSection: sectionIndex)
                }
                break
            default:
                break
            }
        }
        return snapshot
    }
    
    func requestWhenViewDidLoad() {
        let categoryViewModel = ViewModel<DrinkList>()
        let drinksViewModel = ViewModel<Drinks>()
        guard let categoryApiItem = makeApiRequestItem(at: 0) else { return }
        guard let drinksApiItem = makeApiRequestItem(at: 1) else { return }
        
        let categorySubscriber = categoryViewModel.request(apiItem: categoryApiItem)
        let drinksSubscriber = drinksViewModel.request(apiItem: drinksApiItem)
        
        Publishers.Zip(categorySubscriber, drinksSubscriber)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("<ERROR>", error.localizedDescription)
                    return
                case .finished:
                    break
                }
            } receiveValue: { sectionItems in
                
                guard let categories = sectionItems.0.drinks else { return }
                guard let drinks = sectionItems.1.drinks else { return }
                self.currentItems.send(
                    [
                        0: categories,
                        1: drinks
                    ]
                )
            }
            .store(in: &GlobalCancellable.cancellable)

    }
    
    func makeApiRequestItem(at sectionIndex: Int) -> apiRequestItem? {
        switch sectionIndex {
        case 0:
            return apiRequestItem(url: APIManger.shared.listURLString, header: nil, parameter: nil, queryItems: [URLQueryItem(name: "c", value: "list")], method: "GET")
        case 1:
            return apiRequestItem(url: APIManger.shared.baseURLString, header: nil, parameter: nil, queryItems: [URLQueryItem(name: "s", value: "")], method: "GET")
        default:
            return nil
        }
    }
    
    func request(apiItem: apiRequestItem, item: AnyHashable) {
        switch item {
        case is DrinkList:
            ViewModel<DrinkList>().request(apiItem: apiItem)
                .sink { completion in
                    switch completion{
                    case let .failure(error):
                        print("<ERROR>", error.localizedDescription)
                        return
                    case .finished:
                        break
                    }
                } receiveValue: { drinkList in
                    self.currentItems.value[0] = drinkList.drinks
                }
                .store(in: &GlobalCancellable.cancellable)
        case is Drinks:
                ViewModel<Drinks>().request(apiItem: apiItem)
                    .sink { completion in
                        switch completion{
                        case let .failure(error):
                            print("<ERROR>", error.localizedDescription)
                            return
                        case .finished:
                            break
                        }
                    } receiveValue: { drinks in
                        self.currentItems.value[1] = drinks.drinks
                    }
                    .store(in: &GlobalCancellable.cancellable)
        default:
            return
        }
    }
    
    func selectCell(_ viewController: UIViewController, collectionView: UICollectionView, at selectedItemAt: IndexPath) {
        print("IndexPath",selectedItemAt)
        guard selectedItemAt.section == 0 else { return }
        let index = selectedItemAt.item
        guard let selectedItem = self.currentItems.value[0]?[index] else { return }
        let selectedCategory = selectedItem as! DrinkCategory
        
        let apiItem = apiRequestItem(url: APIManger.shared.filterURLString, header: nil, parameter: nil, queryItems: [URLQueryItem(name: "c", value: selectedCategory.strCategory)], method: "GET")
        self.request(apiItem: apiItem, item: Drinks())
    }
    
    func cellForItemAt(_ collectionView: UICollectionView, at indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let identifier = self.cellIndentifier[indexPath.section]?[0] else { return cell }
        switch indexPath.section {
        case 0:
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCell
            guard let cellItem = (item as! DrinkCategory).strCategory else { return cell }
            categoryCell.configure(buttonTitle: cellItem)
            cell = categoryCell
        case 1:
            let thumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ThumbnailCell
            guard let title = (item as! Drink).strDrink, let thumbnail = (item as! Drink).strDrinkThumb else { return cell }
            thumbnailCell.configure(title: title, imageURL: thumbnail)
            cell = thumbnailCell
        default:
            break
        }
        return cell
    }
    
    func viewForSupplementary(_ collectionView: UICollectionView, elementKind: String, indexPath: NSIndexPath) -> UICollectionReusableView? {
        return nil
    }
    
    func bindingNavigationItem(navigationItem: UINavigationItem?) { }
    
    
}
