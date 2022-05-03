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
    
    static func create(strategy: FirstStrategyProtocol) -> FirstStrategyViewController {
        let vc = UIStoryboard(name: "FirstStrategyViewController", bundle: .main).instantiateViewController(withIdentifier: "FirstStrategyViewController") as! FirstStrategyViewController
        vc.strategy = strategy
        vc.viewModel = FirstStrategyViewModel(strategy: strategy)
        return vc
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var topStackView: UIStackView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet var topTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTopView()
        self.registerCells()
        self.setupCollectionViewLayout()
        self.setupCollectionViewDiffableDataSource()
        self.combineTopViewDataPublisher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestForInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupTopView() {
        switch strategy.topViewType {
        case .stackView:
            topView.isHidden = true
            //strategy.loadTopView(view: self.topView, subView: self.topStackView)
        case .textField:
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: self.textField)
            self.topView = self.textField
            //strategy.loadTopView(view: self.topView, subView: self.textField)
        case .textView:
            topView.isHidden = true
            //strategy.loadTopView(view: self.topView, subView: self.topTextView)
        case .unknown:
            topView.isHidden = true
        }
    }
    
    private func combineTopViewDataPublisher() {
        self.topViewDataPublisher
            .sink { publishedString in
                let updatedSnapshot = self.strategy.updateSnapshot(self.collectionView, searchTarget: publishedString)
                self.strategy.createDiffableDataSource(self.collectionView).apply(updatedSnapshot)
            }
            .store(in: &self.cancellable)
    }
    
    private func registerCells() {
        strategy.cellReuseIdentifiers.forEach { identifiers in
            self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifiers)
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
        layout.configuration.interSectionSpacing = strategy.interSectionSpacing
        
        self.collectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionViewDiffableDataSource() {
        self.collectionView.dataSource = strategy.createDiffableDataSource(self.collectionView)
    }
    
    private func requestForInit() {
        guard let item = strategy.requestForInit() else { return }
        
        let sessionSubscriber = self.viewModel.request(item: item)
        print(sessionSubscriber)
        sessionSubscriber
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("URLError", error)
                    break
                default:
                    break
                }
            } receiveValue: { movies in
                print(movies)
                self.strategy.createDiffableDataSource(self.collectionView).apply(self.strategy.createSnapshot(item: movies.Search), animatingDifferences: true)
            }
            .store(in: &self.cancellable)
    }
}

//MARK: - if topView() is textField

extension FirstStrategyViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(_ notification: Notification) {
        guard let text = self.textField.text else { return }
        self.topViewDataPublisher.send(text)
    }
}
