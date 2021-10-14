//
//  SpineWheelTypeCell.swift
//  KumuApp
//
//  Created by Jyoti on 19/05/21.
//

import UIKit

class SpinWheelTypeCell: UICollectionViewCell {
    @IBOutlet weak var wheelImage: UIImageView!
    var spinWheel: SpinWheel! {
        didSet {
            
            self.wheelImage.image = UIImage(named: spinWheel.imageWheel )
            
        }
    }

}
