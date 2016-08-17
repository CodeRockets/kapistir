//
//  UserListTableViewCell.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 17/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
