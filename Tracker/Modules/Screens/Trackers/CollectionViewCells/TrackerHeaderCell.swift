//
//  TrackerHeaderCell.swift
//  Tracker
//
//  Created by Михаил Бобылев on 30.07.2025.
//

import UIKit
import SnapKit

final class TrackerHeaderCell: UICollectionReusableView {
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .veryDark
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

private extension TrackerHeaderCell {
    func setupUI() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
