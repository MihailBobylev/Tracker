//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 08.09.2025.
//

import UIKit
import SnapKit

final class FiltersViewController: UIViewController {
    private struct Constants {
        static var titleText = NSLocalizedString("filters", comment: "category section title text")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont.systemFont(ofSize: 16.dfs, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let filtersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.reuseID)
        collectionView.contentInset.top = 16.dvs
        collectionView.contentInset.bottom = 16.dvs
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var viewModel: FiltersViewModelProtocol
    
    init(viewModel: FiltersViewModelProtocol) {
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
        viewModel.viewDidLoad(collectionView: filtersCollectionView)
    }
}

extension FiltersViewController: FiltersViewModelDelegate {
    func closeController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

private extension FiltersViewController {
    func setupUI() {
        view.backgroundColor = .backgroundWhite
        
        view.addSubview(titleLabel)
        view.addSubview(filtersCollectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27.dvs)
            make.leading.trailing.equalToSuperview()
        }
        
        filtersCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.dvs)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(-16.dvs)
        }
    }
}
