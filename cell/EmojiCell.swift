//
//  EmojiCell.swift
//  KumuApp
//
//  Created by Jyoti on 20/05/21.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    @IBOutlet weak var emojiImage: UIImageView!
    @IBOutlet weak var lableEmoji: UILabel!

    @IBOutlet weak var viewSelectBg: UIView!
    override func layoutSubviews() {
//        self.emojiImage.layer.cornerRadius = self.frame.size.width / 2
//        self.emojiImage.layer.masksToBounds = true
    }
    
    
}
