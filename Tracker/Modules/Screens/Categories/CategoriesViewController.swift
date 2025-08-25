//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 23.08.2025.
//

import UIKit
import SnapKit

final class CategoriesViewController: UIViewController {
    private struct Constants {
        static var titleText = "Категория"
        static var mainButtonText = "Добавить категорию"
        static var emptyStateLabelText = "Привычки и события можно \nобъединить по смыслу"
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont.systemFont(ofSize: 16.dfs, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let categoriesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.reuseID)
        collectionView.contentInset.top = 16.dvs
        collectionView.contentInset.bottom = 16.dvs
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var addCategoryButton: TrackerCustomButton = {
        let button = TrackerCustomButton(style: .primary)
        button.setTitle(Constants.mainButtonText, for: .normal)
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
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
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12.dfs, weight: .medium)
        return label
    }()
    
    private var viewModel: CategoriesViewModelProtocol
    
    init(viewModel: CategoriesViewModelProtocol) {
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
        viewModel.viewDidLoad(collectionView: categoriesCollectionView)
    }
}

extension CategoriesViewController: CategoriesViewModelDelegate {
    func updateEmptyState(to isShow: Bool) {
        emptyStateVStack.isHidden = !isShow
        categoriesCollectionView.isHidden = isShow
    }
    
    func closeController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

private extension CategoriesViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(emptyStateVStack)
        emptyStateVStack.addArrangedSubview(emptyStateImageView)
        emptyStateVStack.addArrangedSubview(emptyStateLabel)
        view.addSubview(categoriesCollectionView)
        view.addSubview(addCategoryButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27.dvs)
            make.leading.trailing.equalToSuperview()
        }
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.dvs)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addCategoryButton.snp.top).inset(-16.dvs)
        }
        
        addCategoryButton.snp.makeConstraints { make in
            make.height.equalTo(60.dvs)
            make.leading.trailing.equalToSuperview().inset(20.dhs)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.dvs)
        }
        
        emptyStateImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        emptyStateVStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(addCategoryButton.snp.top).inset(-232.dvs)
        }
    }
    
    @objc private func addCategoryButtonTapped() {
        viewModel.addCategoryButtonTapped()
    }
}
