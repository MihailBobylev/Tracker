//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 27.07.2025.
//

import UIKit
import SnapKit

final class NewTrackerViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(TitleTextFieldCell.self, forCellWithReuseIdentifier: TitleTextFieldCell.reuseID)
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.reuseID)
        collectionView.contentInset.top = 24
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private let buttonsHStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var cancelButton: TrackerCustomButton = {
        let button = TrackerCustomButton(style: .outline)
        button.setTitle("Отменить", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: TrackerCustomButton = {
        let button = TrackerCustomButton(style: .primary)
        button.setTitle("Создать", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var viewModel: NewTrackerViewModelProtocol
    private var mainCollectionViewManager: MainCollectionViewManagerProtocol?
    
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
        setupResponsibilities()
        view.addKeyboardDismissTap()
    }
}

extension NewTrackerViewController: NewTrackerViewModelDelegate {
    func updateScheduleInfo(with text: String?) {
        mainCollectionViewManager?.updateSelectedWeekday(with: text)
    }
}

extension NewTrackerViewController: MainCollectionViewManagerDelegate {
    func reloadItems(at indexPath: [IndexPath]) {
        mainCollectionView.reloadItems(at: indexPath)
    }
    
    func didSelectItem(at type: NewTrackerSectionType.Details) {
        viewModel.didSelectItem(at: type)
    }
    
    func updateEnteredText(newText: String) {
        viewModel.updateEnteredText(newText: newText)
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
            make.top.equalToSuperview().offset(27)
            make.leading.trailing.equalToSuperview()
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonsHStack.snp.top).inset(-16)
        }
        
        buttonsHStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    func setupAppearance() {
        mainCollectionViewManager = MainCollectionViewManager(sections: viewModel.getSections())
        guard let mainCollectionViewManager else { return }
        mainCollectionViewManager.delegate = self
        let layout = mainCollectionViewManager.createLayout()
        mainCollectionView.setCollectionViewLayout(layout, animated: false)
        mainCollectionView.delegate = mainCollectionViewManager
        mainCollectionView.dataSource = mainCollectionViewManager
    }
    
    func setupResponsibilities() {
        viewModel.onButtonStateChange = { [weak self] isEnabled in
            self?.doneButton.isEnabled = isEnabled
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        viewModel.doneButtonTapped()
    }
}
