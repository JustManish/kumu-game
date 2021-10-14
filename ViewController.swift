//
//  ViewController.swift
//  KumuApp
//
//  Created by Jyoti on 17/05/21.
//

import UIKit

protocol ControllerDelegate {
    func onDismiss()
}
class ViewController: UIViewController {
    var spinItem: [SpinItem] = []
    var slices: [Slice] = []
    var setting = SpinSetting()
    var itemsList : Items?
   
    @IBOutlet weak var seagmentUser: UISegmentedControl!
    static var instance: ViewController!
    
    static func getInstance() -> ViewController {
        return instance
    }
    
    @IBOutlet weak var spinWheelWidget: SwiftFortuneWheel! {
        didSet {
            spinWheelWidget.onSpinButtonTap = { [weak self] in
                
            }
        }
    }
    
    @IBAction func actionChangeUser(_ sender: UISegmentedControl) {
        self.getSavedGame()
    }
    @IBAction func actionSpin(_ sender: UIButton){
        if self.seagmentUser.selectedSegmentIndex == 0 {
         self.performSegue(withIdentifier: "MainToSpin", sender: self.slices)
        }else {
            self.performSegue(withIdentifier: "ViewerMainView", sender: self.slices)
        }
    }
    
    @IBOutlet weak var viewSpin: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ViewController.instance = self
        self.seagmentUser.isHidden = true
        self.spinWheelWidget.isHidden = true
        spinWheelWidget.configuration = blackCyanColorsConfiguration(spinButtonFontSize: 13, spinButtonSize: CGSize(width: 20, height: 20))
        
        if let items = UserDefaults.standard.value(forKey: "temp_spinItem") as? Data, let data = try? JSONDecoder().decode([SpinItem].self, from: items) {
            let isCompltedItesm = data.filter { item in
                return item.emojiName != "addEmoji"
            }
            if (isCompltedItesm.count == 0) {
                self.updateSpin(spinItems: data)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //game_id
        self.getSavedGame()
    }

     func getSavedGame(){
        if UserDefaults.standard.integer(forKey: "gameId") > 0 {
            let params : [String : Any] = ["game_id": UserDefaults.standard.integer(forKey: "gameId")]
            //API call getting Items List...
            NetworkClient.shared.getItemsList(params: params, vc: self) { (message, items) -> (Void) in
               // print("Items : \(items)")
                if let items = items{
                    self.itemsList = items
                    UserDefaults.standard.set(try? JSONEncoder().encode(items), forKey: "temp_spinItem")
                    
                    //if let item = items {
                        self.setting.cost = Int(items.coins ?? "0")
                        self.setting.limit = Int(items.spin_limit ?? "0")
                        self.setting.canViewerSpin = Int(items.isViewerSpin ?? "0") == 1 ? true : false
                        
                    //}
                    if let itemsList = items.item_list{
                        self.spinItem = (itemsList.map { items in
                            SpinItem(emojiName: items.emoji, colorHex: items.section_color, name: items.section_text)
                        })
                        self.updateSpin(spinItems: self.spinItem)
                    }
                    
                    
                }
                
                
            }

        }else{
            self.seagmentUser.isHidden = true
            self.spinWheelWidget.isHidden = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToInteractiveGame" {
            if let controller = segue.destination as? InteractiveGameController {
                controller.delegate = self
            }
        }
        
        if segue.identifier == "ViewerMainView" {
            if let controller = segue.destination as? ViewMainViewController {
                //controller.delegate = self
                controller.spinItem = self.slices
                controller.items = self.itemsList
            }
        }
        
        if segue.identifier == "MainToSpin" {
            if let controller = segue.destination as? SpinGameViewController {
                controller.spinItem = self.slices
                controller.delegate = self
                controller.item =  self.itemsList 
                
            }
            self.spinWheelWidget.isHidden = true
        }
        
        if segue.identifier == "EditSetting" {
            if let controller = segue.destination as? CreateSpinViewController {
                controller.isEditSetting = true
                controller.delegate = self
            }
        }
        
        if segue.identifier == "SpinResult" {
            if let controller = segue.destination as? SpinGameResultViewController {
                controller.delegate = self
            }

        }
    }
    
    func updateSpin(spinItems: [SpinItem]){
        self.spinItem = spinItems
        updateSlices()
        self.spinWheelWidget.isHidden = false
        self.seagmentUser.isHidden = false
    }

    func textPreferences(fontSize: CGFloat, verticalOffset: CGFloat? = 10) -> TextPreferences {
       let textColorType = SFWConfiguration.ColorType.customPatternColors(colors: [.white], defaultColor: .white)
       let font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
       let prefenreces = TextPreferences(textColorType: textColorType,
                                         font: font,
                                         verticalOffset: verticalOffset ?? 0)
       return prefenreces
   }
    func updateSpin(spinItems: [Slice]){
        
        self.slices = spinItems
        let items = spinItems.map { slice in
        
            return Slice(contents: [Slice.ContentType.text(text: "", preferences: textPreferences(fontSize: 5, verticalOffset: 5))], backgroundColor: slice.backgroundColor ?? .black)
        }
        spinWheelWidget.slices = items
        self.spinWheelWidget.isHidden = false
        self.seagmentUser.isHidden = false
    }

    func updateSlices() {
        //gradient color...
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
        
        
        let items : [Slice] = spinItem.map { spinItem in
            
            let colors = spinItem.colorHex?.components(separatedBy: ",")
            if colors?.count ?? 0 > 1 {
                var gradientColors = [UIColor]()
                colors?.forEach({ color in
                    gradientColors.append(UIColor.hexStringToUIColor(hex: String(color)))
                })
                return Slice(contents: [Slice.ContentType.text(text: "", preferences: textPreferences(fontSize: 5, verticalOffset: 5))], backgroundColor: nil, backgroundColors: gradientColors)
            }else {
                return Slice(contents: [Slice.ContentType.text(text: "", preferences: textPreferences(fontSize: 5, verticalOffset: 5))], backgroundColor: UIColor.hexStringToUIColor(hex: spinItem.colorHex ?? "#000"))
            }
           
        }

        spinWheelWidget.slices = items
        
    }
}

extension ViewController: SpinGameDelegate, SpinGameResultDelegate, CreateSpinDelegate {
    func onDismiss() {
        let gameId = UserDefaults.standard.integer(forKey: "gameId")
        if gameId > 0 {
            self.spinWheelWidget.isHidden = false
            self.seagmentUser.isHidden = false
        }
    }
    
    func onResult() {
        self.performSegue(withIdentifier: "SpinResult", sender: nil)
    }
    
    func onSetting() {
        self.performSegue(withIdentifier: "EditSetting", sender: nil)
    }
}

extension ViewController: InteractiveGameSelectDelegate {
    func onSelectGame(game: Games) {
        if (game.type == .spin) {
            self.performSegue(withIdentifier: "InteractiveToSpin", sender: nil)
        }
    }
}

extension String {
    func textToImage() -> UIImage? {
           let nsString = (self as NSString)
           let font = UIFont.systemFont(ofSize: 1024) // you can change your font size here
           let stringAttributes = [NSAttributedString.Key.font: font]
           let imageSize = nsString.size(withAttributes: stringAttributes)

           UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
           UIColor.clear.set() // clear background
           UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
           nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
           let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
           UIGraphicsEndImageContext() //  end image context

           return image ?? UIImage()
       }
}
extension UIViewController {
    
    func localizedMessage(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    func showAlert(message: String){
        let alertController = UIAlertController(title: "Kumu", message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { action in
            
        }
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white

            // Accessing buttons tintcolor :
        alertController.view.tintColor = UIColor.black
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func blackCyanColorsConfiguration(spinButtonFontSize: CGFloat, spinButtonSize: CGSize, spinButtonImage: String? = nil, spinButtonTitleColor: UIColor? = .white) -> SFWConfiguration {
        let blackColor = UIColor(white: 51.0 / 255.0, alpha: 1.0)
        // let cyanColor = UIColor.cyan
         let circleStrokeWidth: CGFloat = 0
         let _position: SFWConfiguration.Position = .top
        

        let circlePreferences = SFWConfiguration.CirclePreferences(strokeWidth: circleStrokeWidth,
                                                                           strokeColor: blackColor)
        
        let sliceBackgroundColorType = SFWConfiguration.ColorType.evenOddColors(evenColor: blackColor, oddColor: blackColor)
        
        let slicePreferences = SFWConfiguration.SlicePreferences(backgroundColorType: sliceBackgroundColorType,
                                                                          strokeWidth: 1,
                                                                          strokeColor: UIColor.hexStringToUIColor(hex: "#6C66A2"))
        
        let wheelPreference = SFWConfiguration.WheelPreferences(circlePreferences: circlePreferences,
                                                                          slicePreferences: slicePreferences,
                                                                          startPosition: _position)
        
       // wheelPreference.imageAnchor = imageAnchor
        
        let pinPreferences = SFWConfiguration.PinImageViewPreferences(size: CGSize(width: 50, height: 50),
                                                                                position: _position,
                                                                                 verticalOffset: 30)
        
        var spinButtonPreferences = SFWConfiguration.SpinButtonPreferences(size:spinButtonSize)
        spinButtonPreferences.cornerRadius = spinButtonSize.width / 2

        spinButtonPreferences.font = .systemFont(ofSize: spinButtonFontSize, weight: .bold)
        if let color = spinButtonTitleColor {
            spinButtonPreferences.textColor = color
        }else {
            spinButtonPreferences.textColor = .white

        }
        spinButtonPreferences.backgroundColor = .white
        if let name = spinButtonImage {
            spinButtonPreferences.image = SFWImage(named: name)!
        }
        
        let configuration = SFWConfiguration(wheelPreferences: wheelPreference,
                                             pinPreferences: pinPreferences,
                                             spinButtonPreferences: spinButtonPreferences)
        
        return configuration
    }
}
extension String {
   var containsSpecialCharacter: Bool {
      let regex = ".*[^A-Za-z0-9 ].*"
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
   }
}


extension UIView {
    func addGradientcolor(colors: [UIColor]) {
        let gradient = CAGradientLayer()

        gradient.frame = self.bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
}


// MARK: - JSONDecoder extensions

public extension JSONDecoder {

    /// Decode an object, decoded from a JSON object.
    ///
    /// - Parameter data: JSON object Data
    /// - Returns: Decodable object
    func decode<T: Decodable>(from data: Data?) -> T? {
        guard let data = data else {
            return nil
        }
        return try? self.decode(T.self, from: data)
    }

    /// Decode an object in background thread, decoded from a JSON object.
    ///
    /// - Parameters:
    ///   - data: JSON object Data
    ///   - onDecode: Decodable object
    public func decodeInBackground<T: Decodable>(from data: Data?, onDecode: @escaping (T?) -> Void) {
        DispatchQueue.global().async {
            let decoded: T? = self.decode(from: data)

            DispatchQueue.main.async {
                onDecode(decoded)
            }
        }
    }
}

// MARK: - JSONEncoder extensions

public extension JSONEncoder {

    /// Encodable an object
    ///
    /// - Parameter value: Encodable Object
    /// - Returns: Data encode or nil
    public func encode<T: Encodable>(from value: T?) -> Data? {
        guard let value = value else {
            return nil
        }
        return try? self.encode(value)
    }

    /// Encodable an object in background thread
    ///
    /// - Parameters:
    ///   - encodableObject: Encodable Object
    ///   - onEncode: Data encode or nil
    public func encodeInBackground<T: Encodable>(from encodableObject: T?, onEncode: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            let encode = self.encode(from: encodableObject)

            DispatchQueue.main.async {
                onEncode(encode)
            }
        }
    }
}

// MARK: - NSUserDefaults extensions

public extension UserDefaults {

    /// Set Encodable object in UserDefaults
    ///
    /// - Parameters:
    ///   - type: Encodable object type
    ///   - key: UserDefaults key
    /// - Throws: An error if any value throws an error during encoding.
    func set<T: Encodable>(object type: T, for key: String, onEncode: @escaping (Bool) -> Void) throws {

        JSONEncoder().encodeInBackground(from: type) { [weak self] (data) in
            guard let data = data, let `self` = self else {
                onEncode(false)
                return
            }
            self.set(data, forKey: key)
            onEncode(true)
        }
    }

    /// Get Decodable object in UserDefaults
    ///
    /// - Parameters:
    ///   - objectType: Decodable object type
    ///   - forKey: UserDefaults key
    ///   - onDecode: Codable object
    public func get<T: Decodable>(object type: T.Type, for key: String, onDecode: @escaping (T?) -> Void) {
        let data = value(forKey: key) as? Data
        JSONDecoder().decodeInBackground(from: data, onDecode: onDecode)
    }
}
