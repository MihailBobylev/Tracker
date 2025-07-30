//
//  ScheduleCollectionViewManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

protocol ScheduleCollectionViewManagerProtocol: UICollectionViewDelegate, UICollectionViewDataSource {
    //var delegate: MainCollectionViewManagerDelegate? { get set }
    var didToggleDaySelection: ((WeekdayType) -> Void)? { get set }
    func createLayout() -> UICollectionViewCompositionalLayout
    func configure(selectedWeekdays: Set<WeekdayType>)
}

final class ScheduleCollectionViewManager: NSObject, ScheduleCollectionViewManagerProtocol {
    private let sections: [WeekdayType]
    private var selectedWeekdays: Set<WeekdayType> = []
    
    //weak var delegate: MainCollectionViewManagerDelegate?
    var didToggleDaySelection: ((WeekdayType) -> Void)?
    
    init(sections: [WeekdayType]) {
        self.sections = sections
        super.init()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            let section = makeDayOfWeekSection()
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        //config.interSectionSpacing = 24
        layout.configuration = config
        layout.register(DetailsBackgroundDecorationView.self, forDecorationViewOfKind: DetailsBackgroundDecorationView.identifier)
        
        return layout
    }
    
    func configure(selectedWeekdays: Set<WeekdayType>) {
        self.selectedWeekdays = selectedWeekdays
    }
}

extension ScheduleCollectionViewManager {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailsCell.reuseID,
            for: indexPath
        ) as? DetailsCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(title: sectionType.title, accessory: .switcher(isOn: selectedWeekdays.contains(sectionType)))
        cell.didToggleDaySelection = { [weak self] in
            self?.didToggleDaySelection?(sectionType)
        }
        let isLastRow = indexPath.row == sections.count - 1
        cell.setSeparatorHidden(isLastRow)
        
        return cell
    }
}

private extension ScheduleCollectionViewManager {
    func makeDayOfWeekSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(75)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(75)
            ),
            subitems: [item, item, item, item, item, item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: DetailsBackgroundDecorationView.identifier)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.decorationItems = [backgroundItem]
        
        return section
    }
}
