//
//  ItemSection.swift
//  KumuApp
//
//  Created by mac on 30/06/21.
//


import Foundation
struct ItemSection : Codable {
    let section : String?
    let position : String?
    let section_text : String?
    let section_color : String?
    let emoji : String?

    enum CodingKeys: String, CodingKey {

        case section = "section"
        case position = "position"
        case section_text = "section_text"
        case section_color = "section_color"
        case emoji = "emoji"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        position = try values.decodeIfPresent(String.self, forKey: .position)
        section_text = try values.decodeIfPresent(String.self, forKey: .section_text)
        section_color = try values.decodeIfPresent(String.self, forKey: .section_color)
        emoji = try values.decodeIfPresent(String.self, forKey: .emoji)
    }

}
