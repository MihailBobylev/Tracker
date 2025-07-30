//
//  CGFloat+Extension.swift
//  Tracker
//
//  Created by Михаил Бобылев on 30.07.2025.
//

import UIKit

private enum DeviceMetrics {
    static let baseHeight: CGFloat = 812
    static let baseWidth: CGFloat = 375
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
}

extension Int {
    var dfs: CGFloat { CGFloat(self).dfs }
    var dvs: CGFloat { CGFloat(self).dvs }
    var dhs: CGFloat { CGFloat(self).dhs }
}

extension Double {
    var dfs: CGFloat { CGFloat(self).dfs }
    var dvs: CGFloat { CGFloat(self).dvs }
    var dhs: CGFloat { CGFloat(self).dhs }
}

extension CGFloat {
    
    /// Dynamic Font Size scaled based on screen height.
    var dfs: CGFloat {
        Swift.max(10, self * DeviceMetrics.screenHeight / DeviceMetrics.baseHeight)
    }

    /// Dynamic Vertical Size scaled based on screen height.
    var dvs: CGFloat {
        self * DeviceMetrics.screenHeight / DeviceMetrics.baseHeight
    }

    /// Dynamic Horizontal Size scaled based on screen width.
    var dhs: CGFloat {
        self * DeviceMetrics.screenWidth / DeviceMetrics.baseWidth
    }
}
