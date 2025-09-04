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
        static var titleText = NSLocalizedString("new_habit", comment: "title text")
        static var cancelButtonText = NSLocalizedString("cancel", comment: "cancel button text")
        static var doneButtonText = NSLocalizedString("create", comment: "create button text")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont.systemFont(ofSize: 16.dfs, weight: .medium)
        label.textAlignment = .center
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
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(mainCollectionView)
        view.addSubview(buttonsHStack)
        buttonsHStack.addArrangedSubview(cancelButton)
        buttonsHStack.addArrangedSubview(doneButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27.dvs)
            make.leading.trailing.equalToSuperview()
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.dvs)
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
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        viewModel.doneButtonTapped()
    }
}
