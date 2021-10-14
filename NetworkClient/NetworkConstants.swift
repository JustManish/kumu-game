//
//  NetworkConstants.swift
//  KumuApp
//
//  Created by mac on 30/06/21.
//

import UIKit

let BaseURL = "http://dev-api.kumuapi.com/gamelivestream"

let channelId = "2936832FEE464E3635E654506857EA78"

//let channelId = "AB858DB6C3A2326DD9A49A5561B5CF14"

let MAX_COST_PER_SPIN = 1000

struct ApiName {
    private init() {}
   
    static let create_game = "create-game"
    static let item_list = "item-list"
    static let score_list = "score-list"
    static let saveScore = "save-score"
    static let delete_score = "delete-score"
    static let update_settings = "update-settings"
    static let item_history = "previews-wheel"
    static let coin_spent = "coin-spent"
    static let end_game = "end-game"
    static let update_item = "update-item"
}


struct MessageConstant {
    static let errorMessage = "Something went wrong."
    static let settingUpdateSuccessfully = "Setting updated successfully."
    static let itemUpdatedSuccessfully = "Item updated successfully."
    static let resultSavedSuccessfully = "Result saved successfully."
    static let scoreDeletedSuccessfully = "Score deleted successfully."
    static let coinSpentSuccessfully = "Coin has been spent."
    static let gameEndSuccessfully = "Game end successfully."
    static let viewersNotAllowedToSpin = "Host has not allowed viewers to spin."
    static let insufficientCoins = "Insufficient coins to spent."
    static let maxCostPerSpinExceed = "Maximum cost per spin exceed."
    static let settingCantChange = "Can not edit setting of already launched game!"
}

struct DeviceInfo {
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    static let appId = Bundle.main.bundleIdentifier ?? ""//Bundle.main.infoDictionary?["CFBundleID"] as? String ?? ""
    static let deviceName = UIDevice.current.name
    static let platform = "ios"
    static let version = UIDevice.current.systemVersion
}

//API Logs can be disabled in whole APP by commenting print statement...
func mylog(_ msg : Any){
    print("<<<<<<<<<---------------\n")
    print("LOG = \(msg)")
    print("\n--------------->>>>>>>>>>")
}
