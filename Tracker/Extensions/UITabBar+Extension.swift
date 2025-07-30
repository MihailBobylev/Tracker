//
//  UITabBar+Extension.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit.UITabBar

extension UITabBar {
    func addTopBorder(color: UIColor, height: CGFloat = 1.0) {
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: height))
        topBorder.backgroundColor = color
        topBorder.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        self.addSubview(topBorder)
    }
}
