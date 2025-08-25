//
//  MainCollectionViewManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 27.07.2025.
//

import UIKit

protocol MainCollectionViewManagerDelegate: AnyObject {
    func didSelectItem(at type: NewTrackerSection, indexPath: IndexPath)
    func updateEnteredText(newText: String)
    func updateSelectedEmoji(emoji: String)
    func updateSelectedColor(color: UIColor)
}

protocol MainCollectionViewManagerProtocol: UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: MainCollectionViewManagerDelegate? { get set }
    func createLayout() -> UICollectionViewCompositionalLayout
    func setupCollectionView()
    func updateSelectedWeekday(with text: String?)
    func updateSelectedCategory(with text: String?)
}

final class MainCollectionViewManager: NSObject, MainCollectionViewManagerProtocol {
    private let trackersDataProvider: TrackersDataProvider
    private let collectionView: UICollectionView
    private let maxNumberOfCharacters = 38
    private var sections: [NewTrackerSection]
    private var selectedIndexPathsBySection: [Int: IndexPath] = [:]
    
    weak var delegate: MainCollectionViewManagerDelegate?
    
    init(trackersDataProvider: TrackersDataProvider, collectionView: UICollectionView, sections: [NewTrackerSection]) {
        self.trackersDataProvider = trackersDataProvider
        self.collectionView = collectionView
        self.sections = sections
        super.init()
    }
    
    func setupCollectionView() {
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self, let sectionType = sections[safe: sectionIndex] else { return nil }
            
            var section: NSCollectionLayoutSection = makeEmptySection()
            switch sectionType {
            case is TextFieldSection:
                section = makeTitleTextFieldSection()
                
            case is DetailsSection:
                section = makeCategoryAndScheduleSection()
                
            case is EmojiSection:
                let headerItem = makeHeader()
                section = makeEmojiAndColorSection()
                section.boundarySupplementaryItems = [headerItem]
                
            case is ColorsSection:
                let headerItem = makeHeader()
                section = makeEmojiAndColorSection()
                section.boundarySupplementaryItems = [headerItem]
                
            default:
                break
            }
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24.dvs
        layout.configuration = config
        layout.register(DetailsBackgroundDecorationView.self, forDecorationViewOfKind: DetailsBackgroundDecorationView.identifier)
        
        return layout
    }
    
    func updateSelectedCategory(with text: String?) {
        guard let sectionIndex = sections.firstIndex(where: { $0 is DetailsSection }),
              var detailsSection = sections[sectionIndex] as? DetailsSection
        else { return }
        
        guard let itemIndex = detailsSection.models.firstIndex(where: {
            if case .category = $0 { return true }
            return false
        }) else { return }
        
        detailsSection.models[itemIndex] = .category(subtitle: text)
        
        sections[sectionIndex] = detailsSection
        
        let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func updateSelectedWeekday(with text: String?) {
        guard let sectionIndex = sections.firstIndex(where: { $0 is DetailsSection }),
              var detailsSection = sections[sectionIndex] as? DetailsSection
        else { return }
        
        guard let itemIndex = detailsSection.models.firstIndex(where: {
            if case .schedule = $0 { return true }
            return false
        }) else { return }
        
        detailsSection.models[itemIndex] = .schedule(subtitle: text)

        sections[sectionIndex] = detailsSection
        
        let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
        collectionView.reloadItems(at: [indexPath])
    }
}

extension MainCollectionViewManager {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SimpleTitleHeaderView.reuseID,
                for: indexPath
            ) as? SimpleTitleHeaderView else { return UICollectionReusableView() }
            let sectionType = sections[indexPath.section]
            
            header.configure(title: sectionType.sectionTitle ?? "")
            return header
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case is TextFieldSection:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TitleTextFieldCell.reuseID,
                for: indexPath
            ) as? TitleTextFieldCell else {
                return UICollectionViewCell()
            }
            cell.onTextChanged = { [weak self] text in
                guard let self else { return }
                let isError = text.count >= maxNumberOfCharacters
                if cell.errorLabelIsVisible != isError {
                    cell.changeErrorState(isError: isError)
                    collectionView.performBatchUpdates(nil)
                }
            }
            cell.onEditingEnded = { [weak self] text in
                self?.delegate?.updateEnteredText(newText: text)
            }
            return cell
            
        case let sectionType as DetailsSection:
            let subsection = sectionType.models[indexPath.item]
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailsCell.reuseID,
                for: indexPath
            ) as? DetailsCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(title: subsection.title, subtitle: subsection.subtitle, accessory: .chevron)
            let isLastRow = indexPath.row == sections[indexPath.section].numberOfItems - 1
            cell.setSeparatorHidden(isLastRow)
            return cell
            
        case let sectionType as EmojiSection:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCell.reuseID,
                for: indexPath
            ) as? EmojiCell else {
                return UICollectionViewCell()
            }
            
            let subitem = sectionType.models[indexPath.item]
            cell.configure(emoji: subitem.emoji)
            return cell
         
        case let sectionType as ColorsSection:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCell.reuseID,
                for: indexPath
            ) as? ColorCell else {
                return UICollectionViewCell()
            }
            
            let subitem = sectionType.models[indexPath.item]
            cell.configure(color: subitem.color)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.section]
        let oldIndexPath = selectedIndexPathsBySection[indexPath.section]
        
        selectedIndexPathsBySection[indexPath.section] = indexPath
        updateSelected(oldIndexPath: oldIndexPath, newIndexPath: indexPath)

        switch sectionType {
        case let emojiSection as EmojiSection:
            let subitem = emojiSection.models[indexPath.item]
            delegate?.updateSelectedEmoji(emoji: subitem.emoji)
            
        case let colorsSection as ColorsSection:
            let subitem = colorsSection.models[indexPath.item]
            delegate?.updateSelectedColor(color: subitem.color)
            
        default:
            delegate?.didSelectItem(at: sectionType, indexPath: indexPath)
        }
    }
}

private extension MainCollectionViewManager {
    func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(54.dvs)
        )
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return headerItem
    }
    
    func makeTitleTextFieldSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(75.dvs)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(75.dvs)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16.dhs, bottom: 0, trailing: 16.dhs)
        
        return section
    }
    
    func makeCategoryAndScheduleSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(75.dvs)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(75.dvs)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16.dhs, bottom: 0, trailing: 16.dhs)
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: DetailsBackgroundDecorationView.identifier)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16.dhs, bottom: 0, trailing: 16.dhs)
        section.decorationItems = [backgroundItem]
        
        return section
    }
    
    func makeEmojiAndColorSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(52.dvs),
                heightDimension: .absolute(52.dvs)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(52.dvs)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 18.dhs, bottom: 0, trailing: 18.dhs)
        
        return section
    }
        
    func makeEmptySection() -> NSCollectionLayoutSection {
        let fallbackItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(1),
            heightDimension: .absolute(1)
        )
        let fallbackItem = NSCollectionLayoutItem(layoutSize: fallbackItemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: fallbackItemSize,
            subitems: [fallbackItem]
        )
        
        return NSCollectionLayoutSection(group: group)
    }
    
    func updateSelected(oldIndexPath: IndexPath?, newIndexPath: IndexPath?) {
        
        func setupBorder(for indexPath: IndexPath?, isNeeded: Bool) {
            guard let indexPath,
                  let cell = collectionView.cellForItem(at: indexPath) as? SelectableCellProtocol else { return }
            cell.changeSelectedState(isSelected: isNeeded)
        }
        
        guard oldIndexPath != newIndexPath else { return }
        
        setupBorder(for: oldIndexPath, isNeeded: false)
        setupBorder(for: newIndexPath, isNeeded: true)
    }
}
