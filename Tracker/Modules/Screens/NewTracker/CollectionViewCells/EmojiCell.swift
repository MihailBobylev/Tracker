//
//  EmojiCell.swift
//  Tracker
//
//  Created by Михаил Бобылев on 09.08.2025.
//

import UIKit
import SnapKit

final class EmojiCell: UICollectionViewCell, SelectableCellProtocol {
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32.dfs, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        changeSelectedState(isSelected: false)
        emojiLabel.text = nil
    }
}

extension EmojiCell {
    func configure(emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        changeSelectedState(isSelected: isSelected)
    }
    
    func changeSelectedState(isSelected: Bool) {
        backgroundColor = isSelected ? .backLightGray : .backgroundWhite
    }
}

private extension EmojiCell {
    func setupUI() {
        contentView.addSubview(emojiLabel)
        
        emojiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupAppearance() {
        backgroundColor = .backgroundWhite
        layer.cornerRadius = 18
        layer.masksToBounds = true
    }
}
