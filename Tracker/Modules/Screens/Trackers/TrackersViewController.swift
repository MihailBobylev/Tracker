//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit
import SnapKit

final class TrackersViewController: UIViewController {
    private struct Constants {
        static var titleText = NSLocalizedString("trackers", comment: "Text displayed on title")
        static var textFieldPlaceholderText = NSLocalizedString("search", comment: "Text displayed on search field")
        static var emptyStateLabelText = NSLocalizedString("what_are_we_going_to_track", comment: "Text displayed on empty state label")
        static var locale = NSLocalizedString("locale", comment: "locale")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont.systemFont(ofSize: 34.dfs, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: Constants.locale)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    
    private let searchHeaderView: SearchHeaderView = {
        let view = SearchHeaderView()
        return view
    }()
    
    private let mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerHeaderCell.reuseID)
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseID)
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = 24.dvs
        collectionView.contentInset.bottom = 24.dvs
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private let emptyStateVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8.dvs
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
        label.text = Constants.emptyStateLabelText
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12.dfs, weight: .medium)
        return label
    }()
    
    private var viewModel: TrackersViewModelProtocol
    
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
        setupActions()
        setupUI()
        viewModel.configureTrackerCollectionViewManager(with: mainCollectionView)
        viewModel.selectedDate = datePicker.date
        view.addKeyboardDismissTap()
    }
}

extension TrackersViewController: TrackersViewModelDelegate {
    func updateEmptyState(to type: EmptyStateType) {
        switch type {
        case .empty, .notFound:
            emptyStateImageView.image = type.image
            emptyStateLabel.text = type.text
            emptyStateVStack.isHidden = false
            mainCollectionView.isHidden = true
        case .none:
            emptyStateVStack.isHidden = true
            mainCollectionView.isHidden = false
        }
    }
}

private extension TrackersViewController {
    func configureNavBar() {
        let plusButton = UIImage(resource: .icAddTracker).withTintColor(.veryDark, renderingMode: .alwaysOriginal)
        let leftButton = UIBarButtonItem(image: plusButton,
                                         style: .plain,
                                         target: self,
                                         action: #selector(leftButtonTapped))
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    func setupActions() {
        searchHeaderView.onTextChanged = { [weak self] text in
            self?.viewModel.searchedText = text
        }
    }
    
    func setupUI() {
        view.backgroundColor = .backgroundWhite
        view.addSubview(titleLabel)
        view.addSubview(searchHeaderView)
        view.addSubview(mainCollectionView)
        view.addSubview(emptyStateVStack)
        emptyStateVStack.addArrangedSubview(emptyStateImageView)
        emptyStateVStack.addArrangedSubview(emptyStateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16.dhs)
        }
        
        searchHeaderView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7.dvs)
            make.leading.trailing.equalToSuperview().inset(16.dhs)
            make.height.equalTo(36.dhs)
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchHeaderView.snp.bottom).offset(10.dhs)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(-10.dvs)
        }
        
        emptyStateImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        emptyStateVStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(220.dvs)
        }
    }
    
    func setupTextFieldLeftView() -> UIView {
        let imageView = UIImageView(image: UIImage(resource: .icMangnifyingglass))
        imageView.contentMode = .scaleAspectFit
        
        let container = UIView()
        container.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(16.dhs)
        }

        container.snp.makeConstraints { make in
            make.width.equalTo(30.dhs)
            make.height.equalTo(36.dvs)
        }
        
        return container
    }
}

// MARK: Actions
private extension TrackersViewController {
    @objc func dateChanged() {
        viewModel.selectedDate = datePicker.date
    }
    
    @objc func leftButtonTapped() {
        viewModel.goToAddNewTrackerScreen()
    }
}
