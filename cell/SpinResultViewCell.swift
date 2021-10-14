//
//  SpinResultViewCell.swift
//  KumuApp
//
//  Created by Jyoti on 24/05/21.
//

import UIKit
import SDWebImage

class SpinResultViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblGameLabel: UILabel!
    @IBOutlet weak var lblRanking: UILabel!
    
    var userScore : UserScore?{
        
        
        didSet{
            self.lblName.text = userScore?.username
            
            if let imgURL = URL(string: (userScore?.avatar)!) {
                self.imgUser.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "dummy_pic"))
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
