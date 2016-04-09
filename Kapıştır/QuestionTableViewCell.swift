//
//  QuestionTableViewCell.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import ChameleonFramework

class QuestionTableViewCell: UITableViewCell {
    
    var question: Question!
    
    @IBOutlet weak var ratioLeftBottom: NSLayoutConstraint!
    
    @IBOutlet weak var ratioRightBottom: NSLayoutConstraint!
    
    @IBOutlet weak var ratioLeft: UILabel!
    
    @IBOutlet weak var ratioRight: UILabel!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var viewLeft: UIView!
    
    @IBOutlet weak var viewRight: UIView!
    
    @IBOutlet weak var imgLeft: UIImageView!
    
    @IBOutlet weak var imgRight: UIImageView!
    
    @IBOutlet weak var imgProfileImage: UIImageView!
    
    @IBOutlet weak var lblStats: UILabel!
    
    @IBOutlet weak var viewVotesLeft: UIVisualEffectView!
    
    @IBOutlet weak var viewVotesRight: UIVisualEffectView!
    
    @IBOutlet weak var viewVotesLeftHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var viewVotesRightHeightConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
          
            /*let colorsLeft = ColorsFromImage(self.imgLeft.image!, withFlatScheme: true)
            
            let colorsRight = ColorsFromImage(self.imgRight.image!, withFlatScheme: true)
            
            //print(colorsLeft)
            
            self.viewLeft.backgroundColor = colorsLeft.first
            
            self.viewRight.backgroundColor = colorsRight.first*/
            
            // profile image
            self.imgProfileImage.layer.cornerRadius = self.imgProfileImage.frame.size.width / 2
            self.imgProfileImage.layer.masksToBounds = true
            
            let tapGestureRecoginzerLeft = UITapGestureRecognizer(target:self, action:Selector("tappedLeft"))
            let tapGestureRecoginzerRight = UITapGestureRecognizer(target:self, action:Selector("tappedRight"))

            self.imgLeft.addGestureRecognizer(tapGestureRecoginzerLeft)
            self.imgRight.addGestureRecognizer(tapGestureRecoginzerRight)
        }
    }
    
    func tappedLeft() {
        self.question.optionACount += 1
        showVotes()
    }
    
    func tappedRight() {
        self.question.optionBCount += 1
        showVotes()
    }
    
    func showVotes() {
    
        if question.isAnswered == true {
            return
        }
        
        self.question.isAnswered = true
        
        // label oluştur
        
        let heightA = 40 + (self.viewLeft.frame.size.height-40-88) * CGFloat(question.ratioA)
        let heightB = 40 + (self.viewRight.frame.size.height-40-88) * CGFloat(question.ratioB)
        
        print("A: \(self.question.optionACount), B: \(self.question.optionBCount), Tot: \(question.totalAnswerCount), RatA: \(question.ratioA), RatB: \(question.ratioB), HA: \(heightA), HB: \(heightB)")
        
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.viewVotesLeftHeightConst.constant = heightA
            self.viewVotesLeft.layoutIfNeeded()
        }), completion: nil)
        
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.viewVotesRightHeightConst.constant = heightB
            self.viewVotesRight.layoutIfNeeded()
        }), completion: nil)
        
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.ratioLeftBottom.constant = heightA - 30
            self.viewLeft.layoutIfNeeded()
        }), completion: nil)

        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.ratioRightBottom.constant = heightB - 30
            self.viewRight.layoutIfNeeded()
        }), completion: nil)
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { () -> Void in
            for i in 1...100 {
                print("in loop")
                usleep(5000)
                dispatch_async(dispatch_get_main_queue()) { ()-> Void in
                    self.ratioLeft.text = "% \(Int(self.question.ratioA * 100.0)*i/100 )"
                    self.ratioRight.text = "% \(Int(self.question.ratioB * 100.0)*i/100 )"
                    
                    print(self.ratioLeft.text)
                    print(self.ratioRight.text)
                }
            }
        }
    }
    
    static func configureTableCell(question: Question, inout cell: QuestionTableViewCell)  {
        if question.isAnswered == true {
            cell.viewVotesLeftHeightConst.constant = cell.viewLeft.frame.size.height * CGFloat(question.ratioA)
            cell.viewVotesRightHeightConst.constant = cell.viewRight.frame.size.height * CGFloat(question.ratioB)
            
            cell.ratioLeftBottom.constant = cell.viewLeft.frame.size.height * CGFloat(question.ratioA) - 30
            cell.ratioRightBottom.constant = cell.viewRight.frame.size.height * CGFloat(question.ratioB) - 30
            
            cell.ratioLeft.text = "% \( Int(question.ratioA * 100) )"
            cell.ratioRight.text = "% \( Int(question.ratioB * 100) )"
        }
        else{
            cell.viewVotesRightHeightConst.constant = 0
            cell.viewVotesLeftHeightConst.constant = 0
            
            cell.ratioLeftBottom.constant = 0
            cell.ratioRightBottom.constant = 0
            
            cell.ratioLeft.text = "% 0"
            cell.ratioRight.text = "% 0"
        }
        
        cell.lblStats.text = "☆ " + String(question.totalAnswerCount) + "   ◎ " + String(question.skipCount)
        
        cell.imgLeft.kf_setImageWithURL(NSURL(string: question.optionA)!)
        cell.imgRight.kf_setImageWithURL(NSURL(string: question.optionB)!)
    }
}
