//
//  SpineWheelCreaterViewController.swift
//  KumuApp
//
//  Created by Jyoti on 20/05/21.
//

import UIKit



protocol SpinWheelCreatorSelectItemDelegate {
    func onItemSelection(item: SpinItem)
    func onDone(item: [Slice])
}
class SpinWheelCreatorViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var btnLaunch: UIButton! {
        didSet {
            btnLaunch.layer.cornerRadius = btnLaunch.frame.size.height / 2
            btnLaunch.layer.masksToBounds = true
            
        }
    }
    var selectedIndex = 0
    var delegate: SpinWheelCreatorSelectItemDelegate?
    
    @IBOutlet weak var txtFieldLimitSpin: UITextField!
    @IBOutlet weak var btnDone: UIButton! {
        didSet {
            btnDone.layer.cornerRadius = 10
            btnDone.layer.masksToBounds = true
        }
    }
    
    func updateItem(item: SpinItem){
        self.spinItem[selectedIndex] = item
        updateSlices()
    }
    
    @IBOutlet weak var spinWheelCreator: SwiftFortuneWheel! {
        didSet {
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var btnDecrease: UIButton!

    var drawCurvedLine: Bool = false {
        didSet {
            updateSlices()
        }
    }
    private let max = 8
    private let min = 2
    private var currentSlot = 8
    var spinWheel: SpinWheel!
    var spinItem: [SpinItem] = []
    var slices: [Slice] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setWheel()
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
      //  self.txtFieldLimitSpin.inputAccessoryView = numberToolbar
    }
    
     func setWheel(){
        if let savedUserData = UserDefaults.standard.object(forKey: "temp_spinItem") as? Data
        {
            let decoder = JSONDecoder()
            if let itemSections = try? decoder.decode([SpinItem].self, from: savedUserData) {
                currentSlot = itemSections.count
                spinItem = itemSections
            }else {
                spinItem = SpinItem.mock(numberOfItem: currentSlot)
            }
        }else {
            spinItem = SpinItem.mock(numberOfItem: currentSlot)

        }
        self.btnIncrease.isEnabled = !(spinItem.count == 8)
        self.btnDecrease.isEnabled = !(spinItem.count == 2)

        spinWheelCreator.wheelTapGestureOn = true
        self.navigationController?.navigationBar.isHidden = true
        updateSlices()
        
        spinWheelCreator.configuration = blackCyanColorsConfiguration(spinButtonFontSize: 14, spinButtonSize: CGSize(width: 80, height: 80))
        spinWheelCreator.onWheelTap = { [weak self] index in
            print("index \(index)")
            self?.selectedIndex = index
            self?.delegate?.onItemSelection(item: self?.spinItem[index] ?? SpinItem())
           // self?.performSegue(withIdentifier: "EditGame", sender: self?.spinItem[index]
        }
        
    }
    @IBAction func actionIncrease(_ sender: UIButton){
        if spinItem.count == 8 { self.btnIncrease.isEnabled = false; return}
        currentSlot = currentSlot >= 8 ? 8 : currentSlot + 1
     
        let colors = SpinItem.getEnableColor()
        let items = SpinItem.mock(numberOfItem: 1, colors: [colors[currentSlot - 1]])
        
        var index = 0
        spinItem =  (spinItem + items)
        self.btnIncrease.isEnabled = !(currentSlot == 8)
        self.btnDecrease.isEnabled = true
        //spinItem = spinItem.map
       // spinItem = SpinItem.mock(numberOfItem: currentSlot)
      
        updateSlices()
        
    }
    
    @IBAction func actionDecrease(_ sender: UIButton){
        if spinItem.count == 2 { self.btnDecrease.isEnabled = false; return}
        currentSlot = currentSlot <= 2 ? 2 : currentSlot - 1
        self.btnDecrease.isEnabled = !(currentSlot == 2)
        self.btnIncrease.isEnabled = true
     
        var items = spinItem.filter { item in
            return item.emojiName == "addEmoji"
        }
        var existingEmoji  = spinItem.filter({ item in
            return item.emojiName != "addEmoji"
        })
        
        if (existingEmoji.count > 0 && spinItem.count > 1)
        {
            if (items.count > 1) {
                items.removeLast()
                //items.removeLast()
            }else if items.count > 0 {
                items.removeAll()
                if existingEmoji.count > 0 {
                    //existingEmoji.removeLast()
                }
            }else if existingEmoji.count > 1 {
                existingEmoji.removeLast()
                //existingEmoji.removeLast()
            }else if existingEmoji.count > 0 {
                existingEmoji.removeAll()
            }
            spinItem = existingEmoji + items
        }else if existingEmoji.count == 0 {
            spinItem = SpinItem.mock(numberOfItem: currentSlot)
        }
        
        
        //spinItem = SpinItem.mock(numberOfItem: currentSlot)
        updateSlices()
        

    }
    
    @IBAction func doneWithNumberPad(){
        self.txtFieldLimitSpin.resignFirstResponder()
    }
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateSlices() {
         slices = spinItem.map { spinItem in
            let colors = spinItem.colorHex?.components(separatedBy: ",")
            if colors?.count ?? 0 > 1 {
                var gradientColors = [UIColor]()
                colors?.forEach({ color in
                    gradientColors.append(UIColor.hexStringToUIColor(hex: String(color)))
                })
                return Slice(contents: spinItem.sliceContentTypes(withLine: true), backgroundColor: nil, backgroundColors: gradientColors)
            }else {
                return Slice(contents: spinItem.sliceContentTypes(withLine: true), backgroundColor: UIColor.hexStringToUIColor(hex: spinItem.colorHex!))
            }
          
        }
        let existingEmoji  = spinItem.filter({ item in
            
            return (item.emojiName != "addEmoji") || !(item.name?.isEmpty ?? true)
        })
        
        self.btnLaunch.isHidden = !(existingEmoji.count == slices.count)
        spinWheelCreator.slices = slices
        
        UserDefaults.standard.set(try? JSONEncoder().encode(self.spinItem), forKey: "temp_spinItem")
        
    }
    
    
    @IBAction func actionDone(_ sender: Any) {
//        if txtFieldLimitSpin.text?.isEmpty ?? true {
//            self.showAlert(message: localizedMessage(key: "spin_limit"))
//            return
//        }
        let emptySlice = self.spinItem.filter { item in
            return item.name == "" && item.emojiName == "addEmoji"
        }
        if emptySlice.count > 0 {
            self.showAlert(message: localizedMessage(key: "spin_wheel_incomplete"))
            return
        }
        
        UserDefaults.standard.set(try? JSONEncoder().encode(self.spinItem), forKey: "temp_spinItem")
        
        self.delegate?.onDone(item: self.slices)
        //ViewController.getInstance().updateSpin(spinItems: self.spinItem)
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? AddEditItemViewController {
            controller.delegate = self
            controller.spinItem = sender as? SpinItem
        }
    }
    

}

extension SpinWheelCreatorViewController: EditItemDelegate {
    func onEditItem(item: SpinItem) {
        self.spinItem[selectedIndex] = item
        updateSlices()

    }
}


