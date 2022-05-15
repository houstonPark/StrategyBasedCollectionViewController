//
//  FirstStrategyViewController.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//

import UIKit
import Combine

class FirstStrategyViewController: UIViewController, UICollectionViewDelegate {
    
    var strategy: FirstStrategyProtocol!
    var viewModel: FirstStrategyViewModel!
    private var cancellable = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<FirstStrategySection, Drink>?
    
    static func create(strategy: FirstStrategyProtocol) -> FirstStrategyViewController {
        let vc = UIStoryboard(name: "FirstStrategyViewController", bundle: .main).instantiateViewController(withIdentifier: "FirstStrategyViewController") as! FirstStrategyViewController
        vc.strategy = strategy
        vc.viewModel = FirstStrategyViewModel(strategy: strategy)
        return vc
    }
    
    
    @IBOutlet weak var containerVStackView: UIStackView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTopView()
        self.registerCells()
        self.setupCollectionViewLayout()
        self.setupCollectionViewDiffableDataSource()
        self.collectionView.keyboardDismissMode = .onDrag
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = true
//        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.strategy.createSnapshotItem.isEmpty {
            self.requestForInit()
        }
        else {
            if let dataSource = dataSource {
                let snapshot = self.strategy.createSnapshot()
                dataSource.apply(snapshot)
            }
        }
        self.requestForSearch()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(0)
        self.strategy.selectCell(self.navigationController, collectionView: collectionView, at: indexPath)
    }

    private func setupTopView() {
        switch strategy.topViewType {
        case .stackView, .unknown:
            self.topTextView.isHidden = true
            self.topTextField.isHidden = true
        case .textField:
            self.topTextView.isHidden = true
        case .textView:
            self.topTextField.isHidden = true
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func registerCells() {
        strategy.cellReuseIdentifiers.forEach { identifiers in
            self.collectionView.register(UINib(nibName: identifiers, bundle: .main), forCellWithReuseIdentifier: identifiers)
        }
    }
    
    private func setupCollectionViewLayout() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in

            let itemSize = self.strategy.sectionItemLayoutSize(self.collectionView, at: sectionIndex)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = self.strategy.sectionGroupLayoutSize(self.collectionView, at: sectionIndex)

            let itemCount = self.strategy.numberOfItems(self.collectionView, section: sectionIndex)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: itemCount)

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        self.collectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionViewDiffableDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<FirstStrategySection, Drink>(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            return self.strategy.configureCell(self.collectionView, cellItendifier: self.strategy.cellReuseIdentifiers[indexPath.section], indexPath: indexPath, item: itemIdentifier)
        }
    }
    
    private func requestForInit() {
        guard let item = strategy.requestForInit() else { return }
        let sessionSubscriber = self.viewModel.request(item: item)
        sessionSubscriber
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("ERROR:", error.localizedDescription)
                }
            } receiveValue: { drinks in
                DispatchQueue.main.sync {
                    guard let drinks = drinks.drinks, let dataSource = self.dataSource else { return }
                    let snapshot = self.strategy.createSnapshot(item: drinks)

                    dataSource.apply(snapshot)
                }
            }
            .store(in: &self.cancellable)
    }

    private func requestForSearch() {
        self.topTextField.textPublisher
            .sink { text in
                let item = apiRequestItem(url: APIManger.shared.baseURLString, header: nil, parameter: nil, queryItems: [URLQueryItem(name: "s", value: text)], method: "GET")
                self.viewModel.request(item: item)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case let .failure(error):
                            print("ERROR:", error.localizedDescription)
                        }
                    } receiveValue: { drinks in
                        DispatchQueue.main.async {
                            guard let drinks = drinks.drinks, let dataSource = self.dataSource else { return }
                            let snapshot = self.strategy.createSnapshot(item: drinks)

                            dataSource.apply(snapshot)
                        }
                    }
                    .store(in: &self.cancellable)

            }
            .store(in: &self.cancellable)
    }
}
