//
//  QuestionTableViewCell.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import ChameleonFramework
import M13Checkbox

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
    
    @IBOutlet weak var lblInfo: UILabel!
    
    @IBOutlet weak var viewVotesLeftHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var viewVotesRightHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var chkLeft: M13Checkbox! {
        didSet{
            chkLeft.userInteractionEnabled = false
            chkLeft.stateChangeAnimation = .Dot(.Fill)
        }
    }
    
    @IBOutlet weak var chkRight: M13Checkbox! {
        didSet{
            chkRight.userInteractionEnabled = false
            chkRight.stateChangeAnimation = .Dot(.Fill)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecoginzerLeft = UITapGestureRecognizer(target:self, action:#selector(QuestionTableViewCell.tappedLeft(_:)))
        let tapGestureRecoginzerRight = UITapGestureRecognizer(target:self, action:#selector(QuestionTableViewCell.tappedRight(_:)))
        
        self.imgLeft.addGestureRecognizer(tapGestureRecoginzerLeft)
        self.imgRight.addGestureRecognizer(tapGestureRecoginzerRight)
    }
    
    func tappedLeft(gesture: UITapGestureRecognizer ) {
        if self.question.answer != nil {
            return
        }
        
        self.question.optionACount += 1
        self.question.answer = .Left
        self.chkLeft.hidden = false
        self.chkLeft.setCheckState(.Checked, animated: true)
        
        showVotes()
        
        Api.saveAnswer(self.question, answer: .Left, errorCallback: {
            // hata oluştu
            }, successCallback: {
                // cevap kaydedildi
            })
    }
    
    func tappedRight(gesture: UITapGestureRecognizer) {
        if self.question.answer != nil {
            return
        }
        
        self.question.optionBCount += 1
        self.question.answer = .Right
        self.chkRight.hidden = false
        self.chkRight.setCheckState(.Checked, animated: true)
        
        showVotes()
        
        Api.saveAnswer(self.question, answer: .Right, errorCallback: {
            // hata oluştu
            }, successCallback: {
                // cevap kaydedildi
            })
    }
    
    func showVotes() {
    
        self.lblInfo.text = "☆ " + String(question.totalAnswerCount) + " Oy"
        
        if question.isAnswered == true {
            return
        }
        
        self.question.isAnswered = true
        
        self.ratioLeft.hidden = false
        self.ratioRight.hidden = false
        
        let heightA = 40 + (self.viewLeft.frame.size.height-40) * CGFloat(question.ratioA)
        let heightB = 40 + (self.viewRight.frame.size.height-40) * CGFloat(question.ratioB)
        
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
                usleep(5000)
                dispatch_async(dispatch_get_main_queue()) { ()-> Void in
                    self.ratioLeft.text = "% \(Int(self.question.ratioA * 100.0)*i/100 )"
                    self.ratioRight.text = "% \(Int(self.question.ratioB * 100.0)*i/100 )"
                }
            }
        }
        
        Publisher.publish("question.voted", data: nil)
    }
    
    static func configureTableCell(question: Question, inout cell: QuestionTableViewCell)  {
        
        cell.question = question
        
        // profile image
        cell.imgProfileImage.layer.cornerRadius = cell.imgProfileImage.frame.size.width / 2
        cell.imgProfileImage.layer.masksToBounds = true

        cell.lblQuestion.text = question.askerName
        cell.imgProfileImage.kf_setImageWithURL(NSURL(string: question.askerProfileImage!)!)
        
        if question.isAnswered == true {
            
            let heightA = 40 + (cell.viewLeft.frame.size.height-40) * CGFloat(question.ratioA)
            let heightB = 40 + (cell.viewRight.frame.size.height-40) * CGFloat(question.ratioB)
            
            // print("cell height: \(cell.viewLeft.frame.size.height-40), ratioA: \(question.ratioA)")
            
            cell.viewVotesLeftHeightConst.constant = heightA
            cell.viewVotesRightHeightConst.constant = heightB
            
            cell.ratioLeftBottom.constant = heightA - 30
            cell.ratioRightBottom.constant = heightB - 30
            
            cell.ratioLeft.hidden = false
            cell.ratioRight.hidden = false
            
            cell.ratioLeft.text = "% \( Int(question.ratioA * 100) )"
            cell.ratioRight.text = "% \( Int(question.ratioB * 100) )"
            
            cell.chkLeft.checkState = .Unchecked
            cell.chkRight.checkState = .Unchecked
            
            cell.chkLeft.hidden = true
            cell.chkRight.hidden = true
            
            if question.answer == .Left {
                cell.chkLeft.hidden = false
                cell.chkLeft.checkState = .Checked
            }
            
            if question.answer == .Right {
                cell.chkRight.hidden = false
                cell.chkRight.checkState = .Checked
            }
        
        }
        else{
            cell.viewVotesRightHeightConst.constant = 0
            cell.viewVotesLeftHeightConst.constant = 0
            
            cell.ratioLeftBottom.constant = 0
            cell.ratioRightBottom.constant = 0
            
            cell.ratioLeft.hidden = true
            cell.ratioRight.hidden = true
            
            cell.chkLeft.hidden = true
            cell.chkRight.hidden = true
            
            cell.chkLeft.checkState = .Unchecked
            cell.chkRight.checkState = .Unchecked
        }
        
        cell.lblInfo.text = "☆ " + String(question.totalAnswerCount) + " Oy" //+ "   ◎ " + String(question.skipCount)
        cell.imgLeft.kf_setImageWithURL(NSURL(string: question.optionA)!)
        cell.imgRight.kf_setImageWithURL(NSURL(string: question.optionB)!)
    }
}
