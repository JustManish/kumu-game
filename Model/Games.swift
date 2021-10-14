//
//  Games.swift
//  KumuApp
//
//  Created by Jyoti on 18/05/21.
//

import Foundation

enum GameType: Int {
    case spin = 1
    case quiz = 2
    case pictionary = 3
    case draw = 4
    case guess = 5
    case draft = 6
    case stack = 7
    case cup = 8
}
struct Games {
    var title: String?
    var icon: String?
    var type: GameType?
}
