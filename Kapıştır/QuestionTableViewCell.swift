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
        print("tapped left")
        
        self.question.optionACount += 1
        
        showVotes()
    }
    
    func tappedRight() {
        print("tapped right")
        
        self.question.optionBCount += 1
        
        showVotes()
    }
    
    func showVotes() {
    
        if question.isAnswered == true {
            return
        }
        
        self.question.isAnswered = true
        
        // label oluştur
        
        let heightA = self.viewLeft.frame.size.height * CGFloat(question.ratioA)
        let heightB = self.viewRight.frame.size.height * CGFloat(question.ratioB)

        print("A: \(self.question.optionACount), B: \(self.question.optionBCount), Tot: \(question.totalAnswerCount), RatA: \(question.ratioA), RatB: \(question.ratioB), HA: \(heightA), HB: \(heightB)")
        
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.viewVotesLeftHeightConst.constant = heightA
            self.viewVotesLeft.layoutIfNeeded()
        }), completion: nil)
        
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.viewVotesRightHeightConst.constant = heightB
            self.viewVotesRight.layoutIfNeeded()
        }), completion: nil)

    }
    
    static func configureTableCell(question: Question, inout cell: QuestionTableViewCell)  {
        if question.isAnswered == true {
            cell.viewVotesLeftHeightConst.constant = cell.viewLeft.frame.size.height * CGFloat(question.ratioA)
            cell.viewVotesRightHeightConst.constant = cell.viewRight.frame.size.height * CGFloat(question.ratioB)
        }
        else{
            cell.viewVotesRightHeightConst.constant = 0
            cell.viewVotesLeftHeightConst.constant = 0
        }
        
        cell.lblStats.text = "☆ " + String(question.totalAnswerCount) + "   ◎ " + String(question.skipCount)
        
        cell.imgLeft.kf_setImageWithURL(NSURL(string: question.optionA)!)
        cell.imgRight.kf_setImageWithURL(NSURL(string: question.optionB)!)
    }
}
