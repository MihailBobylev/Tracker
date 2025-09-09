//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Михаил Бобылев on 05.09.2025.
//

import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    static func report(model: MetricaModel) {
        var params: [AnyHashable : Any] = [
            "screen": model.screen
        ]
        
        switch model.item {
        case .none:
            break
        default:
            params["item"] = model.item.rawValue
        }
        
        YMMYandexMetrica.reportEvent(model.event.rawValue, parameters: params) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
}
