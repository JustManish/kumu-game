//
//  AddGamePriceViewController.swift
//  KumuApp
//
//  Created by Jyoti on 24/05/21.
//

import UIKit

class AddGamePriceViewController: UIViewController {

    @IBOutlet weak var btnSave: UIButton! {
        didSet {
            btnSave.layer.cornerRadius = 10
            btnSave.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var txtEditPrice: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addTool()
    }
    
    @IBAction func actionSavePrice(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    private func addTool(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.actionDone))

        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        txtEditPrice?.inputAccessoryView = toolBar
    }
    
    @IBAction func actionDone(_ sender: Any){
        self.txtEditPrice.resignFirstResponder()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
