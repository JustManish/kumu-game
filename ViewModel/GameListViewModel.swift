//
//  GameListViewModel.swift
//  KumuApp
//
//  Created by Jyoti on 18/05/21.
//

import Foundation

struct GameListViewModel {
    
    var games: [Games]! {
        get {
            return self.mocGames()
        }
    }
    
    private func mocGames() -> [Games]{
        
        return [Games(title: "Drawing", icon: "drawing_game_icon", type: .draw), Games(title: "Pictionary", icon: "pictionary", type: .pictionary), Games(title: "Spinewheel", icon: "spine_game_icon", type: .spin)]
        
    }
}

