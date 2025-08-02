//
//  TrackerCustomButton.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

final class TrackerCustomButton: UIButton {
    private var currentStyle: CustomButtonStyle = .primary
    
    override var isEnabled: Bool {
        didSet {
            applyStyle()
        }
    }
    
    init(style: CustomButtonStyle) {
        super.init(frame: .zero)
        currentStyle = style
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setStyle(_ style: CustomButtonStyle) {
        currentStyle = style
        applyStyle()
    }
}

private extension TrackerCustomButton {
    func setup() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        applyStyle()
    }
    
    func applyStyle() {
        let style = currentStyle.style(for: isEnabled)
        
        backgroundColor = style.backgroundColor
        setTitleColor(style.titleColor, for: .normal)
        titleLabel?.font = style.font
        layer.borderColor = style.borderColor.cgColor
    }
}
