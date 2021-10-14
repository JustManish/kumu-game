//
//  AddEditItemViewController.swift
//  KumuApp
//
//  Created by Jyoti on 20/05/21.
//

import UIKit
import AMColorPicker
protocol EditItemDelegate {
    func onEditItem(item: SpinItem)
}
class AddEditItemViewController: UIViewController, UITextFieldDelegate {
    let allowedCharacters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz ").inverted
    var delegate: EditItemDelegate?
    @IBOutlet weak var btnDone: UIButton! {
        didSet {
            btnDone.layer.cornerRadius =  btnDone.frame.size.height / 2 
            btnDone.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var viewColors: UIView!
    @IBOutlet var btnSaveSlot: UIButton! {
        didSet {
            btnSaveSlot.layer.cornerRadius = btnSaveSlot.frame.size.height / 2
            btnSaveSlot.layer.masksToBounds = true
            btnSaveSlot.isEnabled = true
        }
    }
    @IBOutlet weak var collectionEmoji: UICollectionView! {
        didSet {
            collectionEmoji.layer.cornerRadius = 10
            collectionEmoji.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var editTextName: UITextField!
    var addEditVM = ItemAddEditViewModel()
    var spinItem: SpinItem? = nil
    let colors = ["#00C7FF", "#199EEB", "#773EE4", "#D200BE", "#199EEB, #00C7FF", "#773EE4, #00C7FF", "#773EE4, #D200BE","#D200BE, #00C7FF"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        addEditVM.emojis = Emoji.mock()
        editTextName.text = spinItem?.name
        
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOk(_ sender: Any) {
       
        if !(self.editTextName.text?.isEmpty ?? true) || self.spinItem?.emojiName != "addEmoji" {
        
        if let name = self.editTextName.text{
            if  (name.containsSpecialCharacter || name.count > 16) {
                self.showAlert(message: localizedMessage(key: "spin_item_name"))
            }
            else {
                spinItem?.name = self.editTextName.text
                self.delegate?.onEditItem(item: self.spinItem!)
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        }else{
            
            self.showAlert(message: "Select atleast emoji or text!")
            
        }
        
        

    }
    @IBAction func actionSelectColor(_ sender: UIButton) {
   
        for view in self.viewColors.subviews {
            if view .isKind(of: UIButton.self){
                (view as! UIButton).isSelected = false
            }
        }
        sender.isSelected = true
        let color = colors[sender.tag]
        if color.isEmpty {
            self.performSegue(withIdentifier: "DynamicColors", sender: nil)
        }else {
            spinItem?.colorHex = color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty ?? true) {
            btnSaveSlot.isEnabled = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.text?.isEmpty ?? true) {
            btnSaveSlot.isEnabled = true
        }
        return textField.resignFirstResponder()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let colorController = segue.destination as? ColorViewController {
            colorController.delegate = self
        }
    }
    

}
extension AddEditItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addEditVM.emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as? EmojiCell
        //cell?.emojiImage.image = UIImage (named: addEditVM.emojis[indexPath.row].name ?? "")
        cell?.lableEmoji.text = addEditVM.emojis[indexPath.row].name
        if spinItem?.emojiName == addEditVM.emojis[indexPath.row].name {
            cell?.emojiImage.isHidden = false
        }else {
            cell?.emojiImage.isHidden = true
        }
        return cell!
     }
    
    
}

extension AddEditItemViewController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let emoji = addEditVM.emojis[indexPath.row]
//        emoji.isSelected = !(emoji.isSelected ?? false)
//        addEditVM.emojis[indexPath.row] = emoji
//        collectionView.reloadData()
        spinItem?.emojiName = emoji.name ?? ""
        collectionView.reloadData()
        btnSaveSlot.isEnabled = true
        
    }

}

extension AddEditItemViewController: AMColorPickerDelegate{
    func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {
        spinItem?.colorHex = UIColor.hexStringFromColor(color: color)
    }
    
    
}

extension AddEditItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: 50 , height: 50)
    }
}
