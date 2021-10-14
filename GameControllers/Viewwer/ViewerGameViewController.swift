//
//  ViewerGameViewController.swift
//  KumuApp
//
//  Created by Jyoti on 24/06/21.
//

import UIKit

class ViewerGameViewController: UIViewController {
    var finishIndex: Int!
    
    var items : Items?
    var setting : SpinSetting?
    
    var coinsLeft = 500
    
    @IBOutlet weak var hiddenView: UIView!
    var spinItem: [Slice] = []
    @IBOutlet weak var spinWheel: SwiftFortuneWheel!{
        didSet {
            spinWheel.onSpinButtonTap = { [weak self] in
                if self?.setting?.canViewerSpin == false {
                    self?.showAlert(message: MessageConstant.viewersNotAllowedToSpin)
                }else{
                    self?.finishIndex = self?.generateRandomIndexForWheel()
                    self?.startAnimating()
                }
            }
            self.updateSlices()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getting existing setting
        if let savedUserData = UserDefaults.standard.object(forKey: "temp_spinItem_setting") as? Data {
            let decoder = JSONDecoder()
            if let setting = try? decoder.decode(SpinSetting.self, from: savedUserData)  {
                self.setting = setting
                spinWheel.spinTitle = "\(self.setting?.cost ?? 0)\nTO SPIN"
                
                if self.setting?.canViewerSpin == false{
                    //self.spinWheel.spinBackgroundImage = "create_game"
                    //self.spinWheel.isSpinHidden = true
                    //self.spinWheel.isPinHidden = true
                    //self.spinWheel.isSpinEnabled = false
                    self.hiddenView.isHidden = false
                }else{
                    self.hiddenView.isHidden = true
                }
            
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateSlices()
    }
    
    func generateRandomIndexForWheel() -> Int {
        return Int.random(in: 0..<spinWheel.slices.count)
    }
    
    @IBOutlet weak var viewBg: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
            tapGesture.numberOfTapsRequired = 1
            viewBg.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func tapToDismiss() {
          print("tapToDimiss")
        
          self.dismiss(animated: true, completion: nil)
       // delegate?.onDismiss()
      }
    
    func saveResult() {
        let gameId = UserDefaults.standard.integer(forKey: "gameId")
        
        //getting existing setting
        if let savedUserData = UserDefaults.standard.object(forKey: "temp_spinItem_setting") as? Data {
            let decoder = JSONDecoder()
            if let setting = try? decoder.decode(SpinSetting.self, from: savedUserData)  {
                //self.setting = setting
            }
        }
        
        //getting saved items list.
        //temp_items_list
        if let savedItemsList = UserDefaults.standard.object(forKey: "temp_spinItem") as? Data {
            let decoder = JSONDecoder()
            if let itemsList = try? decoder.decode(Items.self, from: savedItemsList)  {
                //self.itemsList = itemsList
                print("Items inside api : \(itemsList)")
            }
        }
        
        let params : [String : Any] = [
            "item_id": "\(self.items?.item_list?[self.finishIndex].id ?? "")",
            "game_id": gameId,
            "spent_coin": "\(self.items?.coins ?? "0")"
        ]
        
        NetworkClient.shared.saveGameResult(params: params, vc: self) { (success, message, result) -> (Void) in
            
            if success ?? false{
               print("Response of saveGameResult API : \(result)")
            }
        }
    }
    
    func startAnimating() {
        if self.coinsLeft >= self.setting?.cost ?? 0{
            spinWheel.startRotationAnimation(finishIndex: finishIndex, continuousRotationTime: 1) { (finished) in
                print(finished)
                
                let gameId = UserDefaults.standard.integer(forKey: "gameId")
                
                let params : [String : Any] = [
                    
                    "channel_id": channelId,
                    "game_id": "\(gameId)",
                    //"coin": "\(self.items?.coins ?? "")"
                    "coin" : "\(self.setting?.cost ?? 0)"
                ]
                NetworkClient.shared.spentCoin(params: params, vc: self) { (success ,message, remainCoins) -> (Void) in
                    if(success ?? false){
                        self.saveResult()
                    }
                    print("Remain Coins are : \(String(describing: remainCoins)) and Message :\(String(describing: message))")
                }
            }
        }else{
            self.showAlert(message: MessageConstant.insufficientCoins)
        }
    }
    func updateSlices() {
        spinWheel.slices = spinItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        spinWheel.configuration = blackCyanColorsConfiguration(spinButtonFontSize: 18, spinButtonSize: CGSize(width: 120, height: 120), spinButtonImage: "img_kumucoin_small", spinButtonTitleColor: .black)
        self.hiddenView.layer.cornerRadius = CGFloat(60)
        
    }
}
