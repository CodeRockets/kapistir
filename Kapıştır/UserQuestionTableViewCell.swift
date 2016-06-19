//
//  UserQuestionTableViewCell.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 22/04/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import ChameleonFramework
import Kingfisher
import DynamicColor

class UserQuestionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgLeft: UIImageView!
    
    @IBOutlet weak var imgRight: UIImageView!
    
    @IBOutlet weak var lblLeft: UILabel!
    
    @IBOutlet weak var lblRight: UILabel!

    @IBOutlet weak var viewBarLeft: UIView!
    
    @IBOutlet weak var viewBarRight: UIView!
    
    @IBOutlet weak var constBarRightHeignt: NSLayoutConstraint!
    
    @IBOutlet weak var constBarLeftHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewLeft: UIView!
    
    @IBOutlet weak var viewRight: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func configureTableCell(question: Question, inout cell: UserQuestionTableViewCell)  {
        cell.imgLeft.kf_setImageWithURL(NSURL(string: question.optionA)!, placeholderImage: nil, optionsInfo: nil) { (image, error, cacheType, imageURL) in
            if error == nil {
                /*dispatch_async(dispatch_get_main_queue()) {
                    if let avgColor = UIColor(averageColorFromImage: cell.imgLeft.image) {
                        cell.viewBarLeft.backgroundColor = avgColor.adjustedHueColor(45/360)
                        cell.lblLeft.textColor = avgColor.invertedColor
                    }
                }*/
            }
        }
        
        cell.imgRight.kf_setImageWithURL(NSURL(string: question.optionB)!, placeholderImage: nil, optionsInfo: nil) { (image, error, cacheType, imageURL) in
            if error == nil {
                /*dispatch_async(dispatch_get_main_queue()) {
                    if let avgColor = UIColor(averageColorFromImage: cell.imgRight.image) {
                        cell.viewBarRight.backgroundColor = avgColor.adjustedHueColor(45/360)
                        cell.lblRight.textColor =  avgColor.invertedColor
                    }
                }*/
            }
        }
        
        cell.lblLeft.text =  String(question.optionACount)
        cell.lblRight.text = String(question.optionBCount)
        
        let barZeroHeight = CGFloat(28)
        let offsetTop = CGFloat(8)
        
        let heightA = barZeroHeight + (cell.imgLeft.frame.size.height-barZeroHeight) * CGFloat(question.ratioA)
        let heightB = barZeroHeight + (cell.imgRight.frame.size.height-barZeroHeight) * CGFloat(question.ratioB)
        
        cell.constBarLeftHeight.constant = heightA - offsetTop
        cell.constBarRightHeignt.constant = heightB - offsetTop
        
        // vote bar styling
        cell.viewBarRight.layer.borderWidth = CGFloat(0.5)
        cell.viewBarLeft.layer.borderWidth = CGFloat(0.5)
        
        let black = UIColor.blackColor()
        let white = UIColor.whiteColor()
        
        cell.viewBarLeft.backgroundColor = black
        cell.viewBarRight.backgroundColor = white
        cell.viewBarLeft.layer.borderColor = white.CGColor
        cell.viewBarRight.layer.borderColor = black.CGColor
        cell.lblLeft.textColor = white
        cell.lblRight.textColor = black
    }
}

extension UIColor {
    var invertedColor: UIColor {
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        UIColor.redColor().getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: 1 - r, green: 1 - g, blue: 1 - b, alpha: a) // Assuming you want the same alpha value.
    }
}
