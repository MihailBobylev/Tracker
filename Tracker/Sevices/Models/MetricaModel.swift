//
//  MetricaModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 05.09.2025.
//

import Foundation

struct MetricaModel {
    enum EventType: String {
        case open
        case close
        case click
    }
    
    enum ActionType: String {
        case addTrack = "add_track"
        case track
        case filter
        case edit
        case delete
        case none
    }
    
    let event: EventType
    let screen: String
    let item: ActionType
}
