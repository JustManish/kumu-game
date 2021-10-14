//
//  GameResult.swift
//  KumuApp
//
//  Created by Jyoti on 02/07/21.
//

import Foundation
struct GameResults: Decodable {
    let results: [UserList]
    enum CodingKeys: String, CodingKey {
        case results = "score_list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([UserList].self, forKey: .results) ?? []
    }
}

struct UserList: Decodable {
    let id: String?
    let user_id: String?
    let username: String?
    let avatar: String?
    let spent_coin: String?
    let is_active: String?
    let section: String?
    let position: String?
    let section_text: String?
    let section_color: String?
    let emoji: String?
}
