//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 05.09.2025.
//

import UIKit
import SnapKit

final class StatisticsViewController: UIViewController {
    private struct Constants {
        static var titleText = NSLocalizedString("statistics", comment: "Text displayed on title")
        static var emptyStateLabelText = NSLocalizedString("there_is_nothing_to_analyze_yet", comment: "Text displayed on empty state label")
        static var trackersCompletedText = NSLocalizedString("trackers_completed", comment: "Text displayed on statistic card label")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont.systemFont(ofSize: 34.dfs, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let statisticCardView = StatisticCardView()
    
    private let emptyStateVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8.dvs
        stack.alignment = .center
        return stack
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .icError))
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
    
    private var viewModel: StatisticsViewModelProtocol
    
    init(viewModel: StatisticsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        viewModel.viewDidLoad()
    }
}

private extension StatisticsViewController {
    func setupUI() {
        view.backgroundColor = .backgroundWhite
        
        view.addSubview(titleLabel)
        view.addSubview(statisticCardView)
        view.addSubview(emptyStateVStack)
        emptyStateVStack.addArrangedSubview(emptyStateImageView)
        emptyStateVStack.addArrangedSubview(emptyStateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16.dhs)
        }
        
        statisticCardView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(77.dvs)
            make.leading.trailing.equalToSuperview().inset(16.dhs)
        }
        
        emptyStateImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        emptyStateVStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(246.dvs)
        }
    }
    
    func setupActions() {
        viewModel.updateCompletedTrackersCount = { [weak self] count in
            guard let self else { return }
            updateEmptyState(isShown: count == 0)
            statisticCardView.configure(info: "\(count)",
                                        description: Constants.trackersCompletedText)
        }
    }
    
    func updateEmptyState(isShown: Bool) {
        emptyStateVStack.isHidden = !isShown
        statisticCardView.isHidden = isShown
    }
}
