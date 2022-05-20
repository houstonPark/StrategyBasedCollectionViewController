//
//  EditProfileStrategyViewController.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/20.
//

import UIKit
import Combine

class EditProfileStrategyViewController: UIViewController {
    
    //MARK: - Create UIViewController
    static func create(strategy: EditProfileStrategy) -> EditProfileStrategyViewController {
        let vc = UIStoryboard(name: "EditProfileStrategyViewController", bundle: .main).instantiateViewController(withIdentifier: "EditProfileStrategyViewController") as! EditProfileStrategyViewController
        vc.strategy = strategy
        return vc
    }
    
    // MARK: - Variables
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var strategy: EditProfileStrategy!
    private var isEditable: Bool?
    private var dataSource: UICollectionViewDiffableDataSource<Int, DiffableData>?
    private var cancellabel = Set<AnyCancellable>()
    
    // MARK: - Override func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isEditable = self.strategy.editableCheckIfNeeded()
        self.registerCells()
        self.setupDateSource()
        self.subscribeAndUpdateSnapshot()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cancellabel.removeAll()
    }
    
    // MARK: - Strategy Apply
    private func registerCells() {
        self.strategy.sections.forEach { sectionCase in
            let section = sectionCase
            switch section {
            case .textField:
                self.collectionView.register(UINib(nibName: "EditProfileTextFieldCell", bundle: .main), forCellWithReuseIdentifier: "EditProfileTextFieldCell")
            case .textView:
                self.collectionView.register(UINib(nibName: "EditProfileTextViewCell", bundle: .main), forCellWithReuseIdentifier: "EditProfileTextViewCell")
            case .buttonCollection:
                self.collectionView.register(UINib(nibName: "EditProfileButtonCollectionCell", bundle: .main), forCellWithReuseIdentifier: "EditProfileButtonCollectionCell")
            case .seperator:
                break
            case .asyncList:
                break
            }
        }
    }
    
    private func setupDateSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            var cell = UICollectionViewCell()
            let sectionCase = self.strategy.sections[indexPath.section]
            switch sectionCase {
            case let .textField(placeholder):
                let textFieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileTextFieldCell", for: indexPath) as! EditProfileTextFieldCell
                textFieldCell.configure(placeholder: placeholder, data: itemIdentifier)
                textFieldCell.textField.textPublisher
                    .sink { text in
                        
                    }
                    .store(in: &self.cancellabel)
                cell = textFieldCell
            case .textView(let placeholder):
                let textViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileTextViewCell", for: indexPath) as! EditProfileTextViewCell
                textViewCell.placeholder = placeholder
                textViewCell.textView.text = itemIdentifier.text
                textViewCell.textView.textPublisher
                    .sink { text in
                        
                    }
                    .store(in: &self.cancellabel)
                cell = textViewCell
            case .buttonCollection:
                let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileButtonCollectionCell", for: indexPath) as! EditProfileButtonCollectionCell
                let isSelected: Bool = self.collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
                buttonCell.configure(text: itemIdentifier.text, isSelected: isSelected)
                cell = buttonCell
            case .seperator:
                let seperatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileSperatorCell", for: indexPath)
                cell = seperatorCell
            case .asyncList(status: let status):
                switch status {
                case .loading:
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileActivityIndicatorCell", for: indexPath)
                case .none:
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileEmptyCell", for: indexPath)
                case .emptyList:
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileEmptyListCell", for: indexPath)
                case .showList:
                    break
                }
            }
            return cell
        })
    }
    
    private func subscribeAndUpdateSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, DiffableData>()
        snapshot.appendSections(Array(0..<self.strategy.sections.count))
        if strategy.items.value.isEmpty { return }
        self.strategy.sections.enumerated().forEach { (index, _) in
            guard let items = self.strategy.items.value[index] else { return }
            snapshot.appendItems(items, toSection: index)
        }
        self.dataSource?.apply(snapshot)
    }
}

extension EditProfileStrategyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.strategy.cellSize(collectionViewSize: self.collectionView.frame.size, sectionIndex: indexPath.section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionCase = self.strategy.sections[section]
        switch sectionCase {
        case .seperator:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        default:
            return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        }
    }
}

extension EditProfileStrategyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionCase = self.strategy.sections[indexPath.section]
        switch sectionCase {
        case .buttonCollection:
            break
        default:
            return
        }
    }
}
