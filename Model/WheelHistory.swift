//
//  WheelHistory.swift
//  KumuApp
//
//  Created by Jyoti on 06/07/21.
//

import Foundation
struct WheelHistory: Decodable {
    let items: [ItemsHistory]?
}
struct WheelHistoryList: Decodable {
    let wheel_history: WheelHistory?
}
