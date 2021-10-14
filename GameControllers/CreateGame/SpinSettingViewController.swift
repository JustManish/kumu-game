//
//  SpinSettingViewController.swift
//  KumuApp
//
//  Created by Jyoti on 14/06/21.
//

import UIKit
protocol SpinSettingDelegate {
    func onSettingChange(setting: SpinSetting,needToUpdate : Bool)
}

class SpinSetting: Codable {
    var limit: Int? = 0
    var cost: Int? = 0
    var canViewerSpin = false
}
class SpinSettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewSpinLimitDisable: UIView!
    @IBOutlet weak var viewDisable: UIView!
    var delegate: SpinSettingDelegate?
    private var setting  = SpinSetting()
    @IBOutlet weak var txtFieldCost: UITextField!
    @IBOutlet weak var txtFieldLimit: UITextField!
    @IBOutlet weak var switchViewer: UISwitch!
    @IBOutlet weak var btnEndGame: UIButton! {
        didSet {
            btnEndGame.layer.cornerRadius = self.btnEndGame.frame.size.height / 2
            btnEndGame.layer.borderColor = UIColor.red.cgColor
            btnEndGame.layer.borderWidth = 1
            btnEndGame.layer.masksToBounds = true
            btnEndGame.isHidden = true
        }
    }
    
    var isEditSetting = false
    var canViewerSpin = false
    
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblLimit: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        //self.viewDisable.isHidden = !isEditSetting

        // Do any additional setup after loading the view.
        self.addToolBar(textField: self.txtFieldCost)
        self.addToolBar(textField: self.txtFieldLimit)
        self.txtFieldCost.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.txtFieldLimit.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.btnEndGame.isHidden = !isEditSetting
        
        self.switchViewer.setOn(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedUserData = UserDefaults.standard.object(forKey: "temp_spinItem_setting") as? Data {
            let decoder = JSONDecoder()
            if let prevSetting = try? decoder.decode(SpinSetting.self, from: savedUserData)  {
                
               // if txtFieldLimit.text?.isEmpty ?? false || txtFieldCost.text?.isEmpty ?? false {
                    
                self.txtFieldCost.text = "\(prevSetting.cost ?? 0)"
                self.txtFieldLimit.text = "\(prevSetting.limit ?? 0)"
                self.switchViewer.setOn(prevSetting.canViewerSpin, animated: true)
                self.viewDisable.isHidden = switchViewer.isOn
                self.canViewerSpin = prevSetting.canViewerSpin
                //}
                print("setting : \(prevSetting.canViewerSpin) and switch : \(switchViewer.isOn)")
                
            }
        }
        
        if gameId > 0 && gameId != nil {
            self.viewSpinLimitDisable.isHidden = false
            self.viewDisable.isHidden = false
        }else{
            self.viewSpinLimitDisable.isHidden = true
            //self.viewDisable.isHidden = true
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let limit = self.txtFieldLimit.text, !limit.isEmpty {
            setting.limit = Int(limit)
        }
        
        if let cost = self.txtFieldCost.text, !cost.isEmpty {
            
            if Int(cost)! > MAX_COST_PER_SPIN {
                self.txtFieldCost.text = "0"
                self.switchViewer.isOn = false
                self.viewDisable.isHidden = false
                self.showAlert(message: MessageConstant.maxCostPerSpinExceed)
            }else{
                setting.cost = Int(cost)
            }
        }
        setting.canViewerSpin = self.switchViewer.isOn
        
        self.delegate?.onSettingChange(setting: self.setting, needToUpdate: false)
    }
    
    @IBAction func actionSwitch(_ sender: UISwitch){
        
        if !self.viewSpinLimitDisable.isHidden {
            self.viewDisable.isHidden = false
            setting.canViewerSpin = sender.isOn
        }else{
            setting.canViewerSpin = sender.isOn
            self.viewDisable.isHidden = sender.isOn
        }
        if !sender.isOn {
            //self.txtFieldCost.text = "0"
            self.txtFieldCost.resignFirstResponder()
        }
        if let limit = self.txtFieldLimit.text, !limit.isEmpty {
            setting.limit = Int(limit)
        }
        
        if let cost = self.txtFieldCost.text, !cost.isEmpty {
            setting.cost = Int(cost)
        }
        self.delegate?.onSettingChange(setting: self.setting, needToUpdate: true)
    }

    @IBAction func actionEndGame(_ sender: UIButton) {
        
        let gameId = UserDefaults.standard.integer(forKey: "gameId")
        let params : [String : Any] = [
         
            "game_id": gameId
        
        ]
        
        NetworkClient.shared.endgame(params: params, vc: self) { (success, message, result) -> (Void) in
            if success ?? false{
                print("End Game Result : \(result)")
                UserDefaults.standard.setValue(nil, forKey: "canSettingEditable")
                UserDefaults.standard.setValue(nil, forKey: "gameId")
                UserDefaults.standard.setValue(nil, forKey: "temp_spinItem")
                UserDefaults.standard.setValue(nil, forKey: "temp_spinItem_setting")
                UserDefaults.standard.setValue(nil, forKey: "temp_items_list")
                UserDefaults.standard.synchronize();
                self.resetSetting()
            }
        }
        
    }
    
    
    func resetSetting() {
        self.txtFieldCost.text = "0"
        self.txtFieldLimit.text = "0"
        self.switchViewer.setOn(false, animated: true)
        self.viewDisable.isHidden = !switchViewer.isOn
        
        //print("setting : \(prevSetting.canViewerSpin)")
    }
    
    
    @objc func doneWithNumberPad(){
        self.txtFieldCost.resignFirstResponder()
        self.txtFieldLimit.resignFirstResponder()
        if let limit = self.txtFieldLimit.text, !limit.isEmpty {
            setting.limit = Int(limit)
        }
        
        if let cost = self.txtFieldCost.text, !cost.isEmpty {
            
            if Int(cost)! > MAX_COST_PER_SPIN {
                self.txtFieldCost.text = "0"
                self.switchViewer.isOn = false
                self.viewDisable.isHidden = false
                self.showAlert(message: MessageConstant.maxCostPerSpinExceed)
            }else{
                setting.cost = Int(cost)
            }
        }
      
        setting.canViewerSpin = self.switchViewer.isOn
        
        self.delegate?.onSettingChange(setting: self.setting, needToUpdate: true)

    }
    
    let gameId = UserDefaults.standard.integer(forKey: "gameId")
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if gameId > 0 && gameId != nil {
            self.showAlert(message: MessageConstant.settingCantChange)
            return false
        }
        return true
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.txtFieldLimit {
            
            if let limit = self.txtFieldLimit.text, !limit.isEmpty {
                setting.limit = Int(limit)
            }
            lblLimit.textColor = (textField.text?.isEmpty ?? true) ? .black : UIColor.hexStringToUIColor(hex: "#199EEB")

        }
        if textField == self.txtFieldCost {
            if let cost = self.txtFieldCost.text, !cost.isEmpty {
                
                if Int(cost) ?? 0 > MAX_COST_PER_SPIN {
                    self.txtFieldCost.text = "0"
                    self.switchViewer.isOn = false
                    self.viewDisable.isHidden = false
                    txtFieldCost.resignFirstResponder()
                    self.showAlert(message: MessageConstant.maxCostPerSpinExceed)
                }else{
                    setting.cost = Int(cost)
                }
            }
            lblCost.textColor = (textField.text?.isEmpty ?? true) ? .black : UIColor.hexStringToUIColor(hex: "#199EEB")

        }
        
    }
    
    
    func addToolBar(textField: UITextField){
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        textField.inputAccessoryView = numberToolbar
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

}
