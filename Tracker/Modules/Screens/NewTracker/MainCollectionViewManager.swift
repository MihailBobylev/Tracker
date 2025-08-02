//
//  MainCollectionViewManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 27.07.2025.
//

import UIKit

protocol MainCollectionViewManagerDelegate: AnyObject {
    func didSelectItem(at type: NewTrackerSectionType.Details)
    func updateEnteredText(newText: String)
}

protocol MainCollectionViewManagerProtocol: UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: MainCollectionViewManagerDelegate? { get set }
    func createLayout() -> UICollectionViewCompositionalLayout
    func setupCollectionView()
    func updateSelectedWeekday(with text: String?)
}

final class MainCollectionViewManager: NSObject, MainCollectionViewManagerProtocol {
    private let trackersDataProvider: TrackersDataProvider
    private let collectionView: UICollectionView
    private let maxNumberOfCharacters = 38
    private var sections: [NewTrackerSectionType]
    
    weak var delegate: MainCollectionViewManagerDelegate?
    
    init(trackersDataProvider: TrackersDataProvider, collectionView: UICollectionView, sections: [NewTrackerSectionType]) {
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
            var section: NSCollectionLayoutSection
            
            switch sectionType {
            case .titleTextField:
                section = makeTitleTextFieldSection()
            case .details:
                section = makeCategoryAndScheduleSection()
            }
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24.dvs
        layout.configuration = config
        layout.register(DetailsBackgroundDecorationView.self, forDecorationViewOfKind: DetailsBackgroundDecorationView.identifier)
        
        return layout
    }
    
    func updateSelectedWeekday(with text: String?) {
        guard let sectionIndex = sections.firstIndex(where: {
            if case .details = $0 { return true }
            return false
        }) else { return }
        
        if case .details(let details) = sections[sectionIndex] {
            let updatedDetails = details.map { detail -> NewTrackerSectionType.Details in
                switch detail {
                case .schedule:
                    return .schedule(subtitle: text)
                default:
                    return detail
                }
            }
            
            sections[sectionIndex] = .details(updatedDetails)
            
            if let itemIndex = updatedDetails.firstIndex(where: {
                if case .schedule = $0 { return true }
                return false
            }) {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
}

extension MainCollectionViewManager {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .titleTextField:
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
        case let .details(subsections):
            let subsection = subsections[indexPath.item]

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailsCell.reuseID,
                for: indexPath
            ) as? DetailsCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(title: subsection.title, subtitle: subsection.subtitle, accessory: .chevron)
            let isLastRow = indexPath.row == sections[indexPath.section].numberOfItemsInSection - 1
            cell.setSeparatorHidden(isLastRow)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .details(let subsections):
            let subsection = subsections[indexPath.item]
            delegate?.didSelectItem(at: subsection)
        default:
            break
        }
    }
}

private extension MainCollectionViewManager {
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
}
