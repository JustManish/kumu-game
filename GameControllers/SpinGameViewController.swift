//
//  SpinGameViewController.swift
//  KumuApp
//
//  Created by Jyoti on 21/05/21.
//

import UIKit

protocol SpinGameDelegate: ControllerDelegate {
    func onResult()
    func onSetting()
}

class SpinGameViewController: UIViewController {
    
    var finishIndex: Int!
    
    
    @IBOutlet weak var lblSpinLeft: UILabel! {
        didSet {
            lblSpinLeft.layer.cornerRadius  = 10
            lblSpinLeft.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var btnSetting: UIButton! {
        didSet {
            btnSetting.layer.cornerRadius  = btnSetting.frame.size.height / 2
            btnSetting.layer.borderWidth = 1
            btnSetting.layer.borderColor = UIColor.hexStringToUIColor(hex: "#773EE4").cgColor

            
            btnSetting.layer.masksToBounds = true
        }

    }
    
    var setting : SpinSetting?
    var itemsList : Items?
    var item : Items?
    var delegate: SpinGameDelegate?
    @IBOutlet weak var viewSpin: UIView!
    @IBOutlet weak var viewBg: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
            tapGesture.numberOfTapsRequired = 1
            viewBg.addGestureRecognizer(tapGesture)
        }
    }
    var spinItem: [Slice] = []
    @IBOutlet weak var btnMenu: UIButton! {
        didSet {
            btnMenu.layer.cornerRadius = btnMenu.frame.size.height / 2
            btnMenu.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var spinWheel: SwiftFortuneWheel! {
        didSet {
            spinWheel.onSpinButtonTap = { [weak self] in
                //generating random index for game
                self?.finishIndex = self?.generateRandomIndexForWheel()
                self?.startAnimating()
            }
            self.updateSlices()
        }
    }
    
    @objc func tapToDismiss() {
          print("tapToDimiss")
        
          self.dismiss(animated: true, completion: nil)
        delegate?.onDismiss()
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        spinWheel.configuration = blackCyanColorsConfiguration(spinButtonFontSize: 13, spinButtonSize: CGSize(width: 80, height: 80))
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblSpinLeft.text = "\(item?.spin_limit ?? "unlimited") spin left"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateSlices()
    }
    
    @IBAction func actionResult(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        delegate?.onResult()
        
    }
    
    @IBAction func actionSetting(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        delegate?.onSetting()
        
    }
    
    func generateRandomIndexForWheel() -> Int {
        return Int.random(in: 0..<spinWheel.slices.count)
    }
    
    func saveResult() {
        let gameId = UserDefaults.standard.integer(forKey: "gameId")
        
        //getting existing setting
        if let savedUserData = UserDefaults.standard.object(forKey: "temp_spinItem_setting") as? Data {
            let decoder = JSONDecoder()
            if let setting = try? decoder.decode(SpinSetting.self, from: savedUserData)  {
                self.setting = setting
            }
        }
        
        
        let params : [String : Any] = [
            "item_id": "\(self.item?.item_list?[self.finishIndex].id ?? "")",
            "game_id": gameId,
            "spent_coin": "\(self.setting?.cost ?? 0)"
        ]
        
        print("params : \(params)")
        
        NetworkClient.shared.saveGameResult(params: params, vc: self) { (success,message, result) -> (Void) in
            
            if success ?? false{
               print("Response of saveGameResult API : \(result)")
            }
        }
    }
    
    
    
    func startAnimating() {
        spinWheel.startRotationAnimation(finishIndex: finishIndex, continuousRotationTime: 1) { (finished) in
            print(finished)
            self.saveResult()
        }
    }
    func updateSlices() {

        spinWheel.slices = spinItem
    }

}
