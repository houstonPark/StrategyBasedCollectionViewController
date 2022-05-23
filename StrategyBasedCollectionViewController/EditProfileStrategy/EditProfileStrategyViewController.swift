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
    private var dataSource: UICollectionViewDiffableDataSource<Int, DiffableData>?
    private var selectedItemInSection: CurrentValueSubject<[Int: IndexPath], Never> = .init([:])
    private var editedText: [IndexPath: String] = [:]

    // Key: IndexPath.Section, Value: IndexPath.Item (selected Item)
    private var cancellabel = Set<AnyCancellable>()
    
    // MARK: - Override func
    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.strategy.sections.forEach { sectionCase in
            self.collectionView.register(UINib(nibName: sectionCase.cellIdentifier, bundle: .main),
                                         forCellWithReuseIdentifier: sectionCase.cellIdentifier)
        }

        self.setupDateSource()

        self.strategy.items
            .sink { items in
                var snapshot = NSDiffableDataSourceSnapshot<Int, DiffableData>()
                snapshot.appendSections(Array(0..<self.strategy.sections.count))

                guard items.isEmpty == false else { return }

                self.strategy.sections.enumerated().forEach { (index, _) in
                    guard let items = items[index] else { return }
                    snapshot.appendItems(items, toSection: index)
                }
                DispatchQueue.main.async {
                    self.dataSource?.apply(snapshot)
                }
            }
            .store(in: &self.cancellabel)


        self.selectedItemInSection
            .sink { paths in
                self.collectionView.indexPathsForVisibleItems.forEach { indexPath in
                    guard let selectedIndexPath = paths[indexPath.section] else { return }
                    if self.strategy.sections[indexPath.section] == .buttonCollection {
                        let cell = self.collectionView.cellForItem(at: indexPath) as! EditProfileButtonCollectionCell
                        cell.configure(text: cell.buttonLabel.text, isSelected: indexPath == selectedIndexPath)
                    }
                }
            }
            .store(in: &self.cancellabel)


        self.strategy.actionHandler(publishedText: nil, callFrom: .viewDidLoad)
        self.collectionView.allowsMultipleSelection = self.strategy.sections.contains(where: { sectionCase in
            sectionCase == .buttonCollection
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cancellabel.removeAll()
    }

    
    private func setupDateSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            var cell = UICollectionViewCell()
            let sectionCase = self.strategy.sections[indexPath.section]
            switch sectionCase {
            case let .textField(placeholder):
                let textFieldCell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath) as! EditProfileTextFieldCell
                textFieldCell.configure(text: self.editedText[indexPath] ?? "", placeholder: placeholder, data: itemIdentifier)
                textFieldCell.textField.textPublisher
                    .sink { text in
                        self.editedText[indexPath] = text
                        self.strategy.actionHandler(publishedText: text, callFrom: .dequeueReuseCell)
                    }
                    .store(in: &self.cancellabel)
                cell = textFieldCell

            case let .textView(placeholder):
                let textViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath) as! EditProfileTextViewCell
                textViewCell.placeholder = placeholder
                textViewCell.textView.text = self.editedText[indexPath]
                textViewCell.textView.textPublisher
                    .sink { text in
                        self.editedText[indexPath] = text
                        self.strategy.actionHandler(publishedText: text, callFrom: .dequeueReuseCell)
                    }
                    .store(in: &self.cancellabel)
                cell = textViewCell

            case .buttonCollection:
                let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath) as! EditProfileButtonCollectionCell
                let isSelected: Bool = self.selectedItemInSection.value[indexPath.section] == indexPath
                buttonCell.configure(text: itemIdentifier.text, isSelected: isSelected)
                cell = buttonCell

            case .seperator:
                return collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath)

            case let .asyncList(status):
                switch status {
                case .loading, .none, .emptyList:
                    return collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath)
                case .showList:
                    let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath) as! EditProfileListCell
                    listCell.configure(label: itemIdentifier.text ?? "Empty")
                    cell = listCell
                }
            }
            return cell
        })
    }
    
}

extension EditProfileStrategyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.strategy.cellSize(collectionViewSize: self.collectionView.frame.size, sizeForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionCase = self.strategy.sections[section]
        switch sectionCase {
        case .seperator:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case .textField:
            return UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
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
            guard let item = self.strategy.items.value[indexPath.section]?[indexPath.item] else { return }
            let text = item.text
            self.selectedItemInSection.value[indexPath.section] = indexPath
            self.strategy.actionHandler(publishedText: text, callFrom: .selectCell)
        case let .asyncList(status):
            if status == .showList {
                guard let selectText = self.dataSource?.itemIdentifier(for: indexPath)?.text else { return }
                self.strategy.sections.enumerated().forEach { (index, element) in
                    switch element {
                    case .textField:
                        self.editedText[IndexPath(item: 0, section: index)] = selectText
                        self.strategy.items.value[index] = [DiffableData(text: selectText, textStatus: .plain)]
                    default:
                        return
                    }
                }
            }
        default:
            return
        }
    }
}
