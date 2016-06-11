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
    
    @IBOutlet weak var lblMid: UILabel!
    
    @IBOutlet weak var lblRight: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func configureTableCell(question: Question, inout cell: UserQuestionTableViewCell)  {
        cell.imgLeft.kf_setImageWithURL(NSURL(string: question.optionA)!)
        cell.imgRight.kf_setImageWithURL(NSURL(string: question.optionB)!)
        
        cell.lblLeft.text = /*"% " + String(question.ratioA) + "(" +*/ String(question.optionACount) + " oy"
        cell.lblRight.text = /*"% " + String(question.ratioB) + "(" + */ String(question.optionBCount) + " oy"
        //cell.lblMid.text = "Boş: " + String(question.skipCount) //+ " (%"+String(question.ratioSkip)+")"
    }
}
