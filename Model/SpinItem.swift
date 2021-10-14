//
//  SpinItem.swift
//  KumuApp
//
//  Created by Jyoti on 20/05/21.
//

import Foundation
import UIKit
struct SpinItem: Codable {
    var id : Int?
    var section : String?
    var position: String?
    var emojiName: String? = "addEmoji"
    var colorHex: String? = "#000000"
    var name: String? = ""
   // let colors = []
    
    static func mock(numberOfItem: Int, colors: [String]) -> [SpinItem] {
        var slices = [SpinItem]()
        let arrayIndex = Array(0...(numberOfItem - 1))
        for index in arrayIndex {
            var item = SpinItem()
            
            item.colorHex = colors[index]
            slices.append(item)
        }
        
        return slices
    }
    
    static func mock(numberOfItem: Int) -> [SpinItem] {
        var slices = [SpinItem]()
        let colors = SpinItem.getEnableColor()
        let arrayIndex = Array(0...(numberOfItem - 1))
        for index in arrayIndex {
            var item = SpinItem()
            
            item.colorHex = colors[index]
            slices.append(item)
        }
        
        return slices
    }
}

extension SpinItem {
  

   static func getEnableColor() -> [String]{
        
        return ["#D200BE", "#773EE4", "#00C7FF", "#199EEB", "#773EE4", "#00C7FF", "#199EEB", "#773EE4", "#00C7FF"]
    }
    
   static func getDisableColor() -> [String]{
        
        return ["#D200BE", "#773EE4", "#00C7FF", "#199EEB", "#773EE4", "#D200BE", "#00C7FF", "#00C7FF", "#199EEB"]
    }
    
    func sliceContentTypes(withLine: Bool = false) -> [Slice.ContentType] {
        //&& (name?.isEmpty ?? true)
        let preferences = ImagePreferences(preferredSize: CGSize(width: 45, height: 45),
                                           verticalOffset: 10)
        let contentType = (emojiName == "addEmoji") ? Slice.ContentType.assetImage(name: emojiName ?? "", preferences: preferences) : Slice.ContentType.image(image: SFWImage(data: emojiName?.textToImage()?.pngData() ?? Data()) ?? SFWImage(), preferences: preferences)
        
        let sliceContentTypes = [Slice.ContentType.text(text: name ?? "", preferences: textPreferences()),
                                 contentType]
        //image(image: <#T##SFWImage#>, preferences: preferences)]
        //assetImage(name: emojiName ?? "", preferences: preferences)
        //let colorType = SFWConfiguration.ColorType.customPatternColors(colors: [UIColor.hexStringToUIColor(hex: "#6C66A2")], defaultColor: .red)
      //  let preferencesColor = LinePreferences(colorType: colorType, height: 2, verticalOffset: 10)
//        if withLine {
           // sliceContentTypes.append(Slice.ContentType.line(preferences: preferencesColor))
//        }
        return sliceContentTypes
    }
    
    func sliceContentTypes(imgSize: CGSize, fontSize: CGFloat, verticalOffset: CGFloat? = 10) -> [Slice.ContentType] {
        let preferences = ImagePreferences(preferredSize: imgSize,
                                           verticalOffset: verticalOffset ?? 0)
        let sliceContentTypes = [Slice.ContentType.text(text: name ?? "", preferences: textPreferences(fontSize: fontSize, verticalOffset: verticalOffset ?? 0)),
        Slice.ContentType.assetImage(name: emojiName ?? "", preferences: preferences)]
      //  let colorType = SFWConfiguration.ColorType.customPatternColors(colors: [UIColor.hexStringToUIColor(hex: "#6C66A2")], defaultColor: .red)
      //  let preferencesColor = LinePreferences(colorType: colorType, height: 2, verticalOffset: 10)
//        if withLine {
           // sliceContentTypes.append(Slice.ContentType.line(preferences: preferencesColor))
//        }
        return sliceContentTypes
    }
    
     func textPreferences() -> TextPreferences {
        let textColorType = SFWConfiguration.ColorType.customPatternColors(colors: [.white], defaultColor: .white)
        let font = UIFont.systemFont(ofSize: 13, weight: .bold)
        let prefenreces = TextPreferences(textColorType: textColorType,
                                          font: font,
                                          verticalOffset: 10)
        return prefenreces
    }
    func textPreferences(fontSize: CGFloat, verticalOffset: CGFloat? = 10) -> TextPreferences {
       let textColorType = SFWConfiguration.ColorType.customPatternColors(colors: [.white], defaultColor: .white)
       let font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
       let prefenreces = TextPreferences(textColorType: textColorType,
                                         font: font,
                                         verticalOffset: verticalOffset ?? 0)
       return prefenreces
   }
}

extension UIColor {
    
    static func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
       // print(hexString)
        return hexString
     }
   static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
