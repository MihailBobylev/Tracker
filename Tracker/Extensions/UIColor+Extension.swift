//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Михаил Бобылев on 16.08.2025.
//

import UIKit

extension UIColor {
    var hexString: String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "000000"
        }

        let r = components[0]
        let g = components[1]
        let b = components[2]

        return String(format: "%02lX%02lX%02lX",
                      lroundf(Float(r * 255)),
                      lroundf(Float(g * 255)),
                      lroundf(Float(b * 255)))
    }

    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
