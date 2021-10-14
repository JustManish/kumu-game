//
//  WheelTypeViewCell.swift
//  KumuApp
//
//  Created by Jyoti on 20/05/21.
//

import UIKit

class WheelTypeViewCell: UICollectionViewCell {
    @IBOutlet weak var wheelImage: UIImageView!
    var spinWheel: SpinWheel! {
        didSet {
            
            self.wheelImage.image = UIImage(named: spinWheel.imageWheel )
            
        }
    }
}
