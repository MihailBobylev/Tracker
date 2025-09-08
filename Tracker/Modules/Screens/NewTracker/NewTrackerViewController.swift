//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 27.07.2025.
//

import UIKit
import SnapKit

final class NewTrackerViewController: UIViewController {
    private struct Constants {
        static var cancelButtonText = NSLocalizedString("cancel", comment: "cancel button text")
        static var doneButtonText = NSLocalizedString("create", comment: "create button text")
    }
    
    private let mainVStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 38.dvs
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.dfs, weight: .medium)
        label.textAlignment = .center
        label.textColor = .veryDark
        return label
    }()
    
    private lazy var countOfCompletedDaysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32.dfs, weight: .bold)
        label.textAlignment = .center
        label.textColor = .veryDark
        label.isHidden = true
        return label
    }()
    
    private let mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(TitleTextFieldCell.self, forCellWithReuseIdentifier: TitleTextFieldCell.reuseID)
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.reuseID)
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseID)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseID)
        collectionView.register(SimpleTitleHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SimpleTitleHeaderView.reuseID)
        collectionView.contentInset.top = 24.dvs
        collectionView.contentInset.bottom = 24.dvs
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private let buttonsHStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8.dhs
        return stackView
    }()
    
    private lazy var cancelButton: TrackerCustomButton = {
        let button = TrackerCustomButton(style: .outline)
        button.setTitle(Constants.cancelButtonText, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: TrackerCustomButton = {
        let button = TrackerCustomButton(style: .primary)
        button.setTitle(Constants.doneButtonText, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var viewModel: NewTrackerViewModelProtocol
    
    init(viewModel: NewTrackerViewModelProtocol) {
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
        viewModel.configureTrackerCollectionViewManager(with: mainCollectionView)
        view.addKeyboardDismissTap()
    }
}

extension NewTrackerViewController: NewTrackerViewModelDelegate {
    func changeButtonState(to isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }
}

private extension NewTrackerViewController {
    func setupUI() {
        view.backgroundColor = .backgroundWhite
        
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.addArrangedSubview(countOfCompletedDaysLabel)
        view.addSubview(mainCollectionView)
        view.addSubview(buttonsHStack)
        buttonsHStack.addArrangedSubview(cancelButton)
        buttonsHStack.addArrangedSubview(doneButton)
        
        mainVStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27.dvs)
            make.leading.trailing.equalToSuperview()
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainVStack.snp.bottom).offset(14.dvs)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonsHStack.snp.top).inset(-16.dvs)
        }
        
        buttonsHStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.dvs)
            make.leading.trailing.equalToSuperview().inset(20.dhs)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(60.dvs)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(60.dvs)
        }
    }
    
    func setupAppearance() {
        let trackerEditMode = viewModel.trackerEditMode
        titleLabel.text = trackerEditMode.title
        
        if case .edit(let tracker) = trackerEditMode {
            let tasksString = String.localizedStringWithFormat(
                NSLocalizedString("numberOfDays", comment: "Number of completed tasks"),
                viewModel.completedDaysCountForTracker(tracker)
            )
            countOfCompletedDaysLabel.text = tasksString
            countOfCompletedDaysLabel.isHidden = false
            changeButtonState(to: true)
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        viewModel.doneButtonTapped()
    }
}
