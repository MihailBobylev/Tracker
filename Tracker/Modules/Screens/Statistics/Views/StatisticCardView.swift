//
//  StatisticCardView.swift
//  Tracker
//
//  Created by Михаил Бобылев on 05.09.2025.
//

import UIKit
import SnapKit

final class StatisticCardView: UIView {
    private let mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 7.dvs
        stack.alignment = .leading
        return stack
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 34.dfs, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12.dfs, weight: .medium)
        return label
    }()
    
    private var isGradientAdded = false
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isGradientAdded {
            isGradientAdded = true
            addGradientBorder(
                colors: [
                    UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1),
                    UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1),
                    UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1)
                ],
                lineWidth: 1,
                cornerRadius: 16
            )
        }
    }
}

extension StatisticCardView {
    func configure(info: String, description: String) {
        infoLabel.text = info
        descriptionLabel.text = description
    }
}

private extension StatisticCardView {
    func setupUI() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        
        addSubview(mainVStack)
        mainVStack.addArrangedSubview(infoLabel)
        mainVStack.addArrangedSubview(descriptionLabel)
        
        mainVStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12.dvs)
            make.leading.trailing.equalToSuperview().inset(12.dhs)
        }
    }
}
