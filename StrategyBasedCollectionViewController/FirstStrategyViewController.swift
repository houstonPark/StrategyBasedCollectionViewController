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
    private var topViewDataPublisher = PassthroughSubject<String,Never>()
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestForInit()
        self.requestForSearch()
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

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.strategy.cellReuseIdentifiers[indexPath.section], for: indexPath) as! FirstStrategyCollectionViewCell

            guard let alcoholic = itemIdentifier.strDrink, let instructions = itemIdentifier.strInstructions, let date = itemIdentifier.dateModified else { return cell }
            
            cell.configure(drink: alcoholic, instructions: instructions, date: date)
            return cell
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

//MARK: - UITextField textPublisher

extension UITextField {

    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map {
                ($0.object as? UITextField)?.text
            }
            .eraseToAnyPublisher()
    }

}

//MARK: - UITextView textPublisher

extension UITextView {

    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
            .map {
                ($0.object as? UITextView)?.text
            }
            .eraseToAnyPublisher()
    }
}
