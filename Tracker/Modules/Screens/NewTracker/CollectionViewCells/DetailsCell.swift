//
//  DetailsCell.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit
import SnapKit

final class DetailsCell: UICollectionViewCell {
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private let mainHStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let textVStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .veryDark)
        label.font = UIFont.systemFont(ofSize: 17.dfs, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .grayishBlue)
        label.font = UIFont.systemFont(ofSize: 17.dfs, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var accessorySwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = false
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchView.onTintColor = .primaryBlue
        switchView.isHidden = true
        return switchView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayishBlue
        return view
    }()
    
    var didToggleDaySelection: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainHStack.removeFromSuperview()
        accessorySwitch.isHidden = true
        accessoryImageView.image = nil
        accessoryImageView.isHidden = true
        subtitleLabel.isHidden = true
    }
    
    func configure(title: String, subtitle: String? = nil, accessory: AccessoryType) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        setupUI(accessory: accessory)
        setupAppearance(subtitle: subtitle, accessory: accessory)
    }
    
    func setSeparatorHidden(_ hidden: Bool) {
        separatorView.isHidden = hidden
    }
    
    func changeSelectedState(to isSelected: Bool) {
        accessoryImageView.isHidden = !isSelected
    }
}

private extension DetailsCell {
    @objc private func switchChanged() {
        didToggleDaySelection?()
    }
    
    func setupAppearance(subtitle: String?, accessory: AccessoryType) {
        subtitleLabel.isHidden = subtitle == nil
        
        switch accessory {
        case .chevron:
            accessoryImageView.image = accessory.image
            accessoryImageView.isHidden = false
        case .checkmark(let isSelected):
            accessoryImageView.image = accessory.image
            accessoryImageView.isHidden = !isSelected
        case .switcher(let isOn):
            accessorySwitch.isOn = isOn
            accessorySwitch.isHidden = false
        case .none:
            accessoryImageView.isHidden = true
            accessorySwitch.isHidden = true
        }
    }
    
    func setupUI(accessory: AccessoryType) {
        mainHStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(mainHStack)
        contentView.addSubview(separatorView)
        mainHStack.addArrangedSubview(textVStack)
        textVStack.addArrangedSubview(titleLabel)
        textVStack.addArrangedSubview(subtitleLabel)
        
        mainHStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16.dhs)
        }
        
        switch accessory {
        case .chevron, .checkmark:
            mainHStack.addArrangedSubview(accessoryImageView)
            accessoryImageView.snp.makeConstraints { make in
                make.width.height.equalTo(24.dhs)
            }
        case .switcher:
            mainHStack.addArrangedSubview(accessorySwitch)
        case .none:
            break
        }

        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(16.dhs)
            make.bottom.equalToSuperview()
        }
    }
}
