//
//  TrackerCell.swift
//  Tracker
//
//  Created by Михаил Бобылев on 30.07.2025.
//

import UIKit
import SnapKit

final class TrackerCell: UICollectionViewCell {
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private let backgroundCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.dfs, weight: .medium)
        return label
    }()
    
    private let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12.dfs, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private let bottomHStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8.dhs
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.textColor = .veryDark
        label.font = .systemFont(ofSize: 12.dfs, weight: .medium)
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .icButtonPlus).withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(resource: .icButtonDone).withRenderingMode(.alwaysTemplate), for: .selected)
        button.addTarget(self, action: #selector(trackAction), for: .primaryActionTriggered)
        button.backgroundColor = .clear

        return button
    }()
    
    var completeTracker: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        emojiView.layoutIfNeeded()
        emojiView.layer.cornerRadius = emojiView.frame.height / 2
        emojiView.layer.masksToBounds = true
        emojiView.clipsToBounds = true
    }

    func configure(with tracker: Tracker, days: Int, isCompleted: Bool) {
        backgroundCardView.backgroundColor = tracker.color
        plusButton.isSelected = isCompleted
        plusButton.tintColor = tracker.color
        emojiLabel.text = tracker.emoji
        taskLabel.text = tracker.title
        daysLabel.text = "\(days) " + days.daySuffix()
    }
    
    func setCompleted(isCompleted: Bool) {
        plusButton.isSelected = isCompleted
    }
}

private extension TrackerCell {
    @objc func trackAction() {
        completeTracker?()
    }
    
    func setupViews() {
        contentView.addSubview(backgroundCardView)
        backgroundCardView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
        backgroundCardView.addSubview(taskLabel)
        contentView.addSubview(bottomHStack)
        bottomHStack.addArrangedSubview(daysLabel)
        bottomHStack.addArrangedSubview(plusButton)
        
        backgroundCardView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(90.dvs)
        }
        
        emojiView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12.dhs)
            make.height.width.equalTo(28.dvs)
        }
        
        emojiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        taskLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12.dhs)
            make.bottom.equalToSuperview().inset(12.dvs)
        }
        
        bottomHStack.snp.makeConstraints { make in
            make.top.equalTo(backgroundCardView.snp.bottom).offset(8.dvs)
            make.leading.trailing.equalToSuperview().inset(12.dhs)
            make.bottom.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(34.dvs)
        }
    }
}
