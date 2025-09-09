//
//  UIView+Extension.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

extension UIView {
    func addKeyboardDismissTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
}

extension UIView {
    func addGradientBorder(colors: [UIColor],
                           lineWidth: CGFloat = 1,
                           cornerRadius: CGFloat = 16,
                           startPoint: CGPoint = CGPoint(x: 1, y: 0.5),
                           endPoint: CGPoint = CGPoint(x: 0, y: 0.5)) {
        layer.sublayers?
            .filter { $0.name == "gradientBorder" }
            .forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientBorder"
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2),
            cornerRadius: cornerRadius
        ).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
    }
}
