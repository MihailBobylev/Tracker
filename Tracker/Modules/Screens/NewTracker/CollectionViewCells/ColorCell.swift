//
//  ColorCell.swift
//  Tracker
//
//  Created by Михаил Бобылев on 09.08.2025.
//

import UIKit
import SnapKit

final class ColorCell: UICollectionViewCell, SelectableCellProtocol {
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private var mainColor: UIColor?
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        return view
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
        backgroundColor = .white
        colorView.layer.borderWidth = 0
    }
}

extension ColorCell {
    func configure(color: UIColor) {
        mainColor = color
        colorView.backgroundColor = color
    }
    
    func changeSelectedState(isSelected: Bool) {
        backgroundColor = isSelected ? mainColor?.withAlphaComponent(0.3) : .white
        colorView.layer.borderWidth = isSelected ? 3 : 0
    }
}

private extension ColorCell {
    func setupUI() {
        contentView.addSubview(colorView)
        
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
    }
    
    func setupAppearance() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
}
