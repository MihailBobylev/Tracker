//
//  SimpleTitleHeader.swift
//  Tracker
//
//  Created by Михаил Бобылев on 09.08.2025.
//

import UIKit
import SnapKit

final class SimpleTitleHeaderView: UICollectionReusableView {
    static var reuseID: String {
        String(describing: Self.self)
    }
   
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19.dfs, weight: .bold)
        label.textColor = .veryDark
        label.textAlignment = .left
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

private extension SimpleTitleHeaderView {
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.dvs)
            make.leading.equalToSuperview().offset(10.dhs)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(24.dvs)
        }
    }
}

