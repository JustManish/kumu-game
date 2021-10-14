//
//  SpinHistoryViewController.swift
//  KumuApp
//
//  Created by Jyoti on 14/06/21.
//

import UIKit

protocol HistoryDelegate {
    func onEdit(setting: SpinSetting,selecteditem : ItemsHistory,isFromEditItems : Bool)
    func onRelaunch(spinItem: [SpinItem], setting: SpinSetting)
}
class SpinHistoryViewController: UIViewController {

    var delegate: HistoryDelegate? = nil
    @IBOutlet weak var btnLaunch: UIButton!
    {
        didSet {
            btnLaunch.layer.cornerRadius = btnLaunch.frame.size.height / 2
            btnLaunch.layer.masksToBounds = true
            
        }
    }
    @IBOutlet weak var btnEdit: UIButton!{
        didSet {
            btnEdit.layer.cornerRadius = btnEdit.frame.size.height / 2
            btnEdit.layer.masksToBounds = true
            
        }
    }
    @IBOutlet weak var spinWheelPreview: SwiftFortuneWheel!
    @IBOutlet weak var collectionHistoryWheel: UICollectionView!
    var historyWheel: [ItemsHistory]? = nil
    var selectedItem: ItemsHistory? = nil
    var setting = SpinSetting()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
        
        spinWheelPreview.configuration = blackCyanColorsConfiguration(spinButtonFontSize: 7, spinButtonSize: CGSize(width: 80, height: 80))

        btnEdit.isEnabled = false
        btnLaunch.isEnabled = false
        selectedItem = nil

        self.getHistory()
    }
    
    private func getHistory(){
        NetworkClient().getItemsHistoryList(vc: self) { message, items in
            if let items = items {
                self.historyWheel = items
                self.collectionHistoryWheel.reloadData()
            }
        }
    }
    
    @IBAction func actionLaunch(_ sender: Any) {
        if let delegate = self.delegate {
            let spinItem = (self.selectedItem?.items_list?.map { items in
                SpinItem(emojiName: items.emoji, colorHex: items.section_color, name: items.section_text)
            })!
            UserDefaults.standard.set(try? JSONEncoder().encode(spinItem), forKey: "temp_spinItem")
            delegate.onRelaunch(spinItem: spinItem, setting: self.setting)
        }
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        if let selectedItem = selectedItem {
            if let delgate = self.delegate {
                let spinItem = (self.selectedItem?.items_list?.map { items in
                    //SpinItem(emojiName: items.emoji, colorHex: items.section_color, name: items.section_text)
                    SpinItem(id : Int(items.id!),section : items.section,position : items.position,emojiName: items.emoji, colorHex: items.section_color, name: items.section_text)
                })!
                UserDefaults.standard.set(try? JSONEncoder().encode(spinItem), forKey: "temp_spinItem")
                delgate.onEdit(setting: self.setting, selecteditem: selectedItem, isFromEditItems: true)
            }
        }
        
        
    }
}
extension SpinHistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyWheel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WheelHistoryCell", for: indexPath) as? WheelHistoryCell
        cell?.items = historyWheel?[indexPath.row]
        cell?.imageViewSelected.isHidden = !(selectedItem?.spin_id == cell?.items?.spin_id)
        cell?.spinWheel.configuration = blackCyanColorsConfiguration(spinButtonFontSize: 7, spinButtonSize: CGSize(width: 30, height: 30))

        return cell!
     }
    
    
}

extension SpinHistoryViewController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        btnEdit.isEnabled = true
        btnLaunch.isEnabled = true
        selectedItem = historyWheel?[indexPath.row]
        collectionView.reloadData()
        self.showLoader()
        DispatchQueue.global(qos: .userInitiated).async {
            if let item = self.selectedItem {
                self.setting.cost = Int(item.coins ?? "0")
                self.setting.limit = Int(item.spin_limit ?? "0")
                self.setting.canViewerSpin = (Int(item.isViewerSpin ?? "0") == 0) ? false : true

            }
            let spinItem = (self.selectedItem?.items_list?.map { items in
                SpinItem(emojiName: items.emoji, colorHex: items.section_color, name: items.section_text)
            })!
            
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
            
            
            DispatchQueue.main.async {
                self.hideLoader()
                self.spinWheelPreview.slices = slices

            }
        }
      
    }


}

extension SpinHistoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            return CGSize(width: 104 , height: 104)
        }
    
}
