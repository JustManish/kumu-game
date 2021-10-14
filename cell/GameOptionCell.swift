//
//  GameOptionCell.swift
//  KumuApp
//
//  Created by Jyoti on 18/05/21.
//

import UIKit

class GameOptionCell: UICollectionViewCell {
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var lblGameTitle: UILabel! {
        didSet {
            lblGameTitle.layer.cornerRadius = 16
            lblGameTitle.layer.masksToBounds = true
        }
    }

    var game: Games! {
        didSet {
//            self.imageViewIcon.layer.cornerRadius = 10
//            self.imageViewIcon.layer.borderWidth = 1
//            self.imageViewIcon.layer.borderColor = UIColor.gray.cgColor
//            self.imageViewIcon.layer.masksToBounds = true
            self.imageViewIcon.image = UIImage(named: game.icon ?? "")
            self.lblGameTitle.text = game.title

        }
    }
}
