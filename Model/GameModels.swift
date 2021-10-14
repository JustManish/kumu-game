//
//  GameData.swift
//  KumuApp
//
//  Created by mac on 30/06/21.
//


import Foundation


struct CoinSpent : Codable {
    let coin : Int?

    enum CodingKeys: String, CodingKey {

        case coin = "coin"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coin = try values.decodeIfPresent(Int.self, forKey: .coin)
    }

}

struct GData : Codable {
    let game_id : Int?

    enum CodingKeys: String, CodingKey {

        case game_id = "game_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        game_id = try values.decodeIfPresent(Int.self, forKey: .game_id)
    }

}


struct ItemsHistory : Codable {
    let items_list : [Item]?
    let spin_id : String?
    let game_id : String?
    let wheel_slot : String?
    let spin_limit : String?
    let coins : String?
    let isViewerSpin: String?
    enum CodingKeys: String, CodingKey {
        case spin_id = "spin_id"
        case game_id = "game_id"
        case wheel_slot = "wheel_slot"
        case spin_limit = "spin_limit"
        case coins = "coins"
        case isViewerSpin = "isViewerSpin"
        case items_list = "item-list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items_list = try values.decodeIfPresent([Item].self, forKey: .items_list)
        spin_id = try values.decodeIfPresent(String.self, forKey: .spin_id)
        game_id = try values.decodeIfPresent(String.self, forKey: .game_id)
        wheel_slot = try values.decodeIfPresent(String.self, forKey: .wheel_slot)
        spin_limit = try values.decodeIfPresent(String.self, forKey: .spin_limit)
        coins = try values.decodeIfPresent(String.self, forKey: .coins)
        isViewerSpin = try values.decodeIfPresent(String.self, forKey: .isViewerSpin)

    }

}


struct Items : Codable {
    let item_list : [Item]?
    let spin_id : String?
    let game_id : String?
    let wheel_slot : String?
    let spin_limit : String?
    let coins : String?
    let isViewerSpin: String?
  
    enum CodingKeys: String, CodingKey {
        case item_list = "item-list"
        case spin_id = "spin_id"
        case game_id = "game_id"
        case wheel_slot = "wheel_slot"
        case spin_limit = "spin_limit"
        case coins = "coins"
        case isViewerSpin = "isViewerSpin"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        item_list = try values.decodeIfPresent([Item].self, forKey: .item_list)
        spin_id = try values.decodeIfPresent(String.self, forKey: .spin_id)
        game_id = try values.decodeIfPresent(String.self, forKey: .game_id)
        wheel_slot = try values.decodeIfPresent(String.self, forKey: .wheel_slot)
        spin_limit = try values.decodeIfPresent(String.self, forKey: .spin_limit)
        coins = try values.decodeIfPresent(String.self, forKey: .coins)
        isViewerSpin = try values.decodeIfPresent(String.self, forKey: .isViewerSpin)

    }

}


struct Item : Codable {
   
    let id : String?
    let section : String?
    let position : String?
    let section_text : String?
    let section_color : String?
    let emoji : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case section = "section"
        case position = "position"
        case section_text = "section_text"
        case section_color = "section_color"
        case emoji = "emoji"
    }

    init(id:String,section:String,position : String,section_text:String,section_color:String,emoji:String) {
        
        
        self.id = id
        self.section = section
        self.position = position
        self.section_text = section_text
        self.section_color = section_color
        self.emoji = emoji
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try? values.decodeIfPresent(String.self, forKey: .id)
        section = try? values.decodeIfPresent(String.self, forKey: .section)
        position = try? values.decodeIfPresent(String.self, forKey: .position)
        section_text = try? values.decodeIfPresent(String.self, forKey: .section_text)
        section_color = try? values.decodeIfPresent(String.self, forKey: .section_color)
        emoji = try? values.decodeIfPresent(String.self, forKey: .emoji)
    }

}


//Game Result list....
/*struct GameResultResponse : Codable {
    let code : Int?
    let message : String?
    let data : GameScores?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(GameScores.self, forKey: .data)
    }

}*/


struct GameScores : Codable {
    let score_list : [UserScore]?

    enum CodingKeys: String, CodingKey {

        case score_list = "score_list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        score_list = try values.decodeIfPresent([UserScore].self, forKey: .score_list)
    }

}

struct UserScore : Codable {
    let id : String?
    let user_id : String?
    let username : String?
    let avatar : String?
    let spent_coin : String?
    let is_active : String?
    let section : String?
    let position : String?
    let section_text : String?
    let section_color : String?
    let emoji : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case username = "username"
        case avatar = "avatar"
        case spent_coin = "spent_coin"
        case is_active = "is_active"
        case section = "section"
        case position = "position"
        case section_text = "section_text"
        case section_color = "section_color"
        case emoji = "emoji"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        spent_coin = try values.decodeIfPresent(String.self, forKey: .spent_coin)
        is_active = try values.decodeIfPresent(String.self, forKey: .is_active)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        position = try values.decodeIfPresent(String.self, forKey: .position)
        section_text = try values.decodeIfPresent(String.self, forKey: .section_text)
        section_color = try values.decodeIfPresent(String.self, forKey: .section_color)
        emoji = try values.decodeIfPresent(String.self, forKey: .emoji)
    }

}
