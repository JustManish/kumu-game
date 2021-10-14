//
//  CreateSpinGamePreviewViewController.swift
//  KumuApp
//
//  Created by Jyoti on 21/06/21.
//

import UIKit

class CreateSpinGamePreviewViewController: UIViewController {

    @IBOutlet weak var spinWheel: SwiftFortuneWheel!
    @IBOutlet weak var btnBack: UIButton! {
        didSet {
            btnBack.layer.cornerRadius = btnBack.frame.size.height / 2
            btnBack.layer.masksToBounds = true
            btnBack.layer.borderWidth = 1
            btnBack.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    @IBOutlet weak var btnLaunch: UIButton! {
        didSet {
            btnLaunch.layer.cornerRadius = btnLaunch.frame.size.height / 2
            btnLaunch.layer.masksToBounds = true

        }
    }
    var slices: [Slice] = []
    
    var isFromEditItems = false
    var selectedItem : ItemsHistory?

    @IBOutlet weak var lblSpinCost: UILabel!
    @IBOutlet weak var lblSpinLimit: UILabel!
    var setting: SpinSetting!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        spinWheel.configuration = blackCyanColorsConfiguration(spinButtonFontSize: 14, spinButtonSize: CGSize(width: 80, height: 80))

        if let setting = self.setting {
            if let cost = setting.cost, cost > 0 {
                self.lblSpinCost.text = "\(cost)"
            }else {
                self.lblSpinCost.text = "0"
            }
            if let limit = setting.limit {
                self.lblSpinLimit.text = "\(limit)"
            }else {
                self.lblSpinCost.text = "0"
            }

        }

        self.updateSlices()
    }
    
    
    
    func getWheelType(sectionCount : Int) -> WheelType {
        
        switch sectionCount {
        case 2:
            return .twoWheel
        case 4:
            return .fourWheel
        case 6:
            return .sixWheel
        case 8:
            return .eight
        case 10:
            return .tenwheel
        case 12:
            return .twelveWheel
        default:
            return .twoWheel
        }
    }
    
    @IBAction func actionLaunchGame(_ sender: Any) {
        
        var items = [[String: Any]]()
        
        if self.isFromEditItems {
            if let savedUserData = UserDefaults.standard.object(forKey: "temp_spinItem") as? Data {
                let decoder = JSONDecoder()
                if let itemSections = try? decoder.decode([SpinItem].self, from: savedUserData) {
                    print("Saved user: \(itemSections)")
                    var index = 0
                    itemSections.forEach { spinItem in
                        let id = spinItem.id!
                        let section = spinItem.section!
                        let position = spinItem.position!
                        let name = spinItem.name ?? ""
                        let color = spinItem.colorHex ?? ""
                        let emoji = spinItem.emojiName ?? ""
                        index = index + 1
                        let dict = [
                            "id" : id,
                            "section": "\(section)",
                            "position": "\(position)",
                            "section_text": name,
                            "section_color": color,
                            "emoji": emoji
                        ] as [String : Any]
                        items.append(dict)
                    }
                    
                }
            }
            
            let gameDataParams : [String : Any] = [

                "item_section" : items
            ]
            
            //let gameId = UserDefaults.standard.integer(forKey: "gameId")
            
            let gameId = (self.selectedItem?.game_id)!
            
            let parms: [String : Any] =    [
                "game_id" : Int(gameId)!,
                "game_data"  : gameDataParams
            ]
            
            NetworkClient.shared.updateItems(params: parms, vc: self) { (success, message, data) -> (Void) in
                print("\(success) \(message) \(data)")
                
                if success ?? false{
                    UserDefaults.standard.setValue(gameId, forKey: "gameId")
                    
                    let settingParams : [String : Any] = [
                        
                        "isViewerSpin": (self.setting.canViewerSpin == true) ? 1 : 0,
                        "spinLimit": self.setting.limit ?? 0,
                        "coins": "\(self.setting.cost ?? 0)",
                        "game_id": "\(gameId)"
                    ]
                    
                    NetworkClient.shared.updateSetting(showAlert: false, params: settingParams, vc: self) { (success, message, result) -> (Void) in
                        if success ?? false{
                            self.dismiss(animated: true,completion: {
                                ViewController.getInstance().getSavedGame()
                            })
                        }
                    }
                }
            }
            
        }else{
        if let savedUserData = UserDefaults.standard.object(forKey: "temp_spinItem") as? Data {
            let decoder = JSONDecoder()
            if let itemSections = try? decoder.decode([SpinItem].self, from: savedUserData) {
                print("Saved user: \(itemSections)")
                var index = 0
                itemSections.forEach { spinItem in
                    let name = spinItem.name ?? ""
                    let color = spinItem.colorHex ?? ""
                    let emoji = spinItem.emojiName ?? ""
                    index = index + 1
                    let dict = [
                        "section": "\(index)",
                        "position": "\(index)",
                        "section_text": name,
                        "section_color": color,
                        "emoji": emoji
                    ]
                    items.append(dict)
                }
                
            }
        }
            
            let gameDataParams : [String : Any] = [
                
                "coins": "\(self.setting.cost ?? 0)",
                "wheel_slot": "\(items.count)",
                "rules": "2",
                "spinLimit":"\(self.setting.limit ?? 0)",
                "isViewerSpin": "\((self.setting.canViewerSpin == true) ? 1 : 0)",
                "time": "2",
                "item_section" : items
            ]
            
            
            
            let parms: [String : Any] =    [
                "channel_id" : channelId,
                "game_data"  : gameDataParams
            ]
            
            NetworkClient.shared.createNewGame(params: parms,vc: self) { (message, data) -> (Void) in
                print("Result of create game API : \(message),\(data)")
                if let id = data?.game_id {
                    UserDefaults.standard.setValue(id, forKey: "gameId")
                    UserDefaults.standard.setValue(0, forKey: "canSettingEditable")
                    UserDefaults.standard.setValue(nil, forKey: "temp_spinItem")
                    UserDefaults.standard.setValue(nil, forKey: "temp_spinItem_setting")
                    UserDefaults.standard.set(try? JSONEncoder().encode(self.setting), forKey: "temp_spinItem_setting")
                    UserDefaults.standard.setValue(nil, forKey: "temp_items_list")
                    
                    self.dismiss(animated: true,completion: {
                        ViewController.getInstance().getSavedGame()
                    })
                }
            }
            
            
            
      }
        
        
            
      

    }
    @IBAction func actionBack(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "temp_spinItem")

        self.navigationController?.popViewController(animated: true)
    }
    
    func updateSlices() {
        
        spinWheel.slices = slices
        
    }

}
