//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit
import SnapKit

final class ScheduleViewController: UIViewController {
    private struct Constants {
        static var titleText = NSLocalizedString("schedule", comment: "Text displayed on title")
        static var doneButtonText = NSLocalizedString("done", comment: "Text displayed on done button")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont.systemFont(ofSize: 16.dfs, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let scheduleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.reuseID)
        collectionView.contentInset.top = 16.dvs
        collectionView.contentInset.bottom = 16.dvs
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var doneButton: TrackerCustomButton = {
        let button = TrackerCustomButton(style: .primary)
        button.setTitle(Constants.doneButtonText, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: ScheduleViewModelProtocol
    private var scheduleCollectionViewManager: ScheduleCollectionViewManagerProtocol?
    
    init(viewModel: ScheduleViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAppearance()
    }
}

extension ScheduleViewController: ScheduleViewModelDelegate {
    func closeController() {
        dismiss(animated: true)
    }
}

private extension ScheduleViewController {
    func setupUI() {
        view.backgroundColor = .backgroundWhite
        
        view.addSubview(titleLabel)
        view.addSubview(scheduleCollectionView)
        view.addSubview(doneButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27.dvs)
            make.leading.trailing.equalToSuperview()
        }
        
        scheduleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.dvs)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(doneButton.snp.top).inset(-16.dvs)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(60.dvs)
            make.leading.trailing.equalToSuperview().inset(20.dhs)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.dvs)
        }
    }
    
    func setupAppearance() {
        scheduleCollectionViewManager = ScheduleCollectionViewManager(sections: viewModel.getSections())
        guard let scheduleCollectionViewManager else { return }
        scheduleCollectionViewManager.configure(selectedWeekdays: viewModel.getSelectedWeekdays())
        scheduleCollectionViewManager.didToggleDaySelection = { [weak self] weekdayType in
            self?.viewModel.didSelectItem(weekdayType: weekdayType)
        }
        
        let layout = scheduleCollectionViewManager.createLayout()
        scheduleCollectionView.setCollectionViewLayout(layout, animated: false)
        scheduleCollectionView.delegate = scheduleCollectionViewManager
        scheduleCollectionView.dataSource = scheduleCollectionViewManager
    }
    
    @objc private func doneButtonTapped() {
        viewModel.doneButtonTapped()
    }
}
