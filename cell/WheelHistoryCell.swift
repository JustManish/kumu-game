//
//  WheelHistoryCellCollectionViewCell.swift
//  KumuApp
//
//  Created by Jyoti on 06/07/21.
//

import UIKit

class WheelHistoryCell: UICollectionViewCell {
 
    @IBOutlet weak var imageViewSelected: UIImageView!
    @IBOutlet weak var spinWheel: SwiftFortuneWheel!
    
    var items: ItemsHistory?{
        didSet {
            updateSlices()
        }
    }
    
    
    func updateSlices() {
        let spinItem = (self.items?.items_list?.map { items in
            SpinItem(emojiName: "", colorHex: items.section_color, name: "")
        })!
        //gradient colors....
        let slices : [Slice] = spinItem.map { spinItem in
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
      // self.btnLaunch.isHidden = !(existingEmoji.count == slices.count)
       spinWheel.slices = slices
        
    }
}
