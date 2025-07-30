//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit
import SnapKit

final class TrackersViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Поиск"
        tf.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        tf.backgroundColor = UIColor(resource: .grayPaleSky)
        tf.layer.cornerRadius = 10
        tf.clearButtonMode = .whileEditing
        tf.autocorrectionType = .no
        tf.leftView = setupTextFieldLeftView()
        tf.leftViewMode = .always
        return tf
    }()
    
    private let mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerHeaderCell.reuseID)
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseID)
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = 24
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private let emptyStateVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .icRing))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    var addNewTracker: (() -> Void)?
    
    private var viewModel: TrackersViewModelProtocol
    private var trackerCollectonViewManager: TrackerCollectonViewManagerProtocol?
    
    init(viewModel: TrackersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupUI()
        setupAppearance()
        view.addKeyboardDismissTap()
    }
}

extension TrackersViewController: TrackersViewModelDelegate {
    func fillManagerWithData(trackersDataProvider: TrackersDataProvider) {
        trackerCollectonViewManager?.configure(trackersDataProvider: trackersDataProvider)
    }
    
    func updateCollectionView() {
        trackerCollectonViewManager?.updateCollectionView()
    }
}

private extension TrackersViewController {
    func configureNavBar() {
        let leftButton = UIBarButtonItem(image: UIImage(resource: .icAddTracker).withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(leftButtonTapped))
        
        navigationItem.leftBarButtonItem = leftButton
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(mainCollectionView)
        view.addSubview(searchTextField)
        view.addSubview(emptyStateVStack)
        emptyStateVStack.addArrangedSubview(emptyStateImageView)
        emptyStateVStack.addArrangedSubview(emptyStateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(-10)
        }
        
        emptyStateImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        emptyStateVStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(220)
        }
    }
    
    func setupTextFieldLeftView() -> UIView {
        let imageView = UIImageView(image: UIImage(resource: .icMangnifyingglass))
        imageView.contentMode = .scaleAspectFit
        
        let container = UIView()
        container.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(16)
        }

        container.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(36)
        }
        
        return container
    }
    
    func setupAppearance() {
        trackerCollectonViewManager = TrackerCollectonViewManager(trackersDataProvider: viewModel.trackersDataProvider,
                                                                  collectionView: mainCollectionView)
        guard let trackerCollectonViewManager else { return }
        //scheduleCollectionViewManager.delegate = self
        let layout = trackerCollectonViewManager.createLayout()
        mainCollectionView.setCollectionViewLayout(layout, animated: false)
        mainCollectionView.delegate = trackerCollectonViewManager
        mainCollectionView.dataSource = trackerCollectonViewManager
    }
    
//    func updateEmptyStateVisibility() {
//        let isEmpty = dataSource.isEmpty
//        emptyStateVStack.isHidden = !isEmpty
//        mainCollectionView.isHidden = isEmpty
//    }
}

// MARK: Actions
private extension TrackersViewController {
    @objc private func leftButtonTapped() {
        addNewTracker?()
    }
}
