//
//  UserQuestionTableViewCell.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 22/04/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class UserQuestionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgLeft: UIImageView!
    
    
    @IBOutlet weak var imgRight: UIImageView!
    
    @IBOutlet weak var lblLeft: UILabel!
    
    
    @IBOutlet weak var lblRight: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
