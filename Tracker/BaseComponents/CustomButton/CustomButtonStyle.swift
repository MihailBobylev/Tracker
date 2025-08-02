//
//  CustomButtonStyle.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

enum CustomButtonStyle {
    struct StyleState {
        let backgroundColor: UIColor
        let borderColor: UIColor
        let titleColor: UIColor
        let font: UIFont
    }

    case primary
    case secondary
    case outline

    func style(for isEnabled: Bool) -> StyleState {
        switch self {
        case .primary:
            return isEnabled
            ? StyleState(backgroundColor: .veryDark,
                         borderColor: .clear,
                         titleColor: .white,
                         font: UIFont.systemFont(ofSize: 16.dfs, weight: .medium))
            : StyleState(backgroundColor: .grayishBlue,
                         borderColor: .clear,
                         titleColor: .white,
                         font: UIFont.systemFont(ofSize: 16.dfs, weight: .medium))
            
        case .secondary:
            return StyleState(backgroundColor: .primaryBlue,
                              borderColor: .clear,
                              titleColor: .white,
                              font: UIFont.systemFont(ofSize: 17.dfs, weight: .regular))
            
        case .outline:
            return StyleState(backgroundColor: .white,
                              borderColor: .redSoft,
                              titleColor: .redSoft,
                              font: UIFont.systemFont(ofSize: 16.dfs, weight: .medium))
        }
    }
}
