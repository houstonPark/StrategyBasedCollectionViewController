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
    private var dataSource: UICollectionViewDiffableDataSource<SectionCase, DiffableData>?
    private var currentItems: [SectionCase: [DiffableData]] = [:]
    private var selectedItemInSection: CurrentValueSubject<[SectionCase: IndexPath], Never> = .init([:])
    private var editedText: [IndexPath: String] = [:]

    // Key: IndexPath.Section, Value: IndexPath.Item (selected Item)
    private var cancellabel = Set<AnyCancellable>()
    
    // MARK: - Override func
    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.setupDateSource()

        self.selectedItemInSection
            .sink { paths in
                self.collectionView.indexPathsForVisibleItems.forEach { indexPath in
                    guard let selectedIndexPath = paths[self.strategy.sections[indexPath.section]] else { return }
                    if self.strategy.sections[indexPath.section] == .button(indexPath.section) {
                        let cell = self.collectionView.cellForItem(at: indexPath) as! EditProfileButtonCollectionCell
                        cell.configure(text: cell.buttonLabel.text, isSelected: indexPath == selectedIndexPath)
                    }
                }
            }
            .store(in: &self.cancellabel)


        self.strategy.fetchDataSource()
            .sink { completion in
                self.completionHandler(completion: completion)
            } receiveValue: { newItems in
                self.applySnapshot(items: newItems)
            }
            .store(in: &self.cancellabel)
        
        self.strategy.sections.forEach { sectionCase in
            switch sectionCase {
            case .button:
                self.collectionView.allowsMultipleSelection = true
            default :
                break
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cancellabel.removeAll()
    }

    private func completionHandler(completion: Subscribers.Completion<Error>) {
        switch completion {
        case let .failure(error):
            print("<ERROR>", error.localizedDescription)
            return
        case .finished:
            return
        }
    }

    private func applySnapshot(items: [SectionCase: [DiffableData]]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionCase, DiffableData>()
        snapshot.appendSections(self.strategy.sections)

        guard items.isEmpty == false else { return }

        self.strategy.sections.forEach { section in
            guard let items = items[section] else { return }
            snapshot.appendItems(items, toSection: section)
        }

        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot)
        }
        self.currentItems = items
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
                        guard let newText = text else { return }
                        self.editedText[indexPath] = text
                        self.strategy.didValueChanged(self.currentItems, newValue: newText)
                            .sink { completion in
                                self.completionHandler(completion: completion)
                            } receiveValue: { newItems in
                                guard let newItems = newItems else { return }
                                self.applySnapshot(items: newItems)
                            }
                            .store(in: &self.cancellabel)
                    }
                    .store(in: &self.cancellabel)
                cell = textFieldCell

            case let .textView(placeholder):
                let textViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath) as! EditProfileTextViewCell
                textViewCell.placeholder = placeholder
                textViewCell.textView.text = self.editedText[indexPath]
                textViewCell.textView.textPublisher
                    .sink { text in
                        guard let newText = text else { return }
                        self.editedText[indexPath] = text
                        self.strategy.didValueChanged(self.currentItems, newValue: newText)
                            .sink { completion in
                                self.completionHandler(completion: completion)
                            } receiveValue: { newItems in
                                guard let newItems = newItems else { return }
                                self.applySnapshot(items: newItems)
                            }
                            .store(in: &self.cancellabel)
                    }
                    .store(in: &self.cancellabel)
                cell = textViewCell

            case .button:
                let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath) as! EditProfileButtonCollectionCell
                let isSelected: Bool = self.selectedItemInSection.value[self.strategy.sections[indexPath.section]] == indexPath
                buttonCell.configure(text: itemIdentifier.text, isSelected: isSelected)
                cell = buttonCell

            case .seperator:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath)

            case let .custom(status):
                switch status {
                case .loading, .none, .emptyList:
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionCase.cellIdentifier, for: indexPath)
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
        guard let items = self.currentItems[self.strategy.sections[indexPath.section]], items.count > indexPath.item else { return .zero }
        let value = items[indexPath.item]
        return self.strategy.cellSize(collectionViewSize: self.collectionView.frame.size, value: value.text ?? "", sizeForItemAt: indexPath)
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
        case .button:
            guard let items = self.currentItems[self.strategy.sections[indexPath.section]], items.count > indexPath.item else { return }
            let item = items[indexPath.item]
            guard let text = item.text else { return }
            self.selectedItemInSection.value[self.strategy.sections[indexPath.section]] = indexPath
            self.strategy.didSelect(self.currentItems, value: text, at: indexPath)
                .sink { completion in
                    self.completionHandler(completion: completion)
                } receiveValue: { newItems in
                    guard let newItems = newItems else { return }
                    self.applySnapshot(items: newItems)
                }
                .store(in: &self.cancellabel)

        case let .custom(status):
            guard let item = self.currentItems[self.strategy.sections[indexPath.section]]?[indexPath.item] else { return }
            guard let text = item.text else { return }
            if status == .showList {
                self.strategy.didSelect(self.currentItems, value: text, at: indexPath)
                    .sink { completion in
                        self.completionHandler(completion: completion)
                    } receiveValue: { newItems in
                        guard let newItems = newItems else { return }
                        self.applySnapshot(items: newItems)
                    }
                    .store(in: &self.cancellabel)
            }
        default:
            return
        }
    }
}
