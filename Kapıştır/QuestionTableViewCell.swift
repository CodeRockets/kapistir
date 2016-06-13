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
    
    @IBOutlet weak var lblInfo: UILabel!
    
    @IBOutlet weak var viewVotesLeftHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var viewVotesRightHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var imgCheckLeft: UIImageView!
    
    @IBOutlet weak var imgCheckLeftBottomConst: NSLayoutConstraint! {
        didSet{
            self.imgCheckLeftBottomConst.constant = 0
        }
    }
    
    @IBOutlet weak var imgCheckRight: UIImageView!
    
    @IBOutlet weak var imgCheckRightBottomConst: NSLayoutConstraint! {
        didSet{
            self.imgCheckRightBottomConst.constant = 0
        }
    }
    
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
            
            let tapGestureRecoginzerLeft = UITapGestureRecognizer(target:self, action:#selector(QuestionTableViewCell.tappedLeft(_:)))
            let tapGestureRecoginzerRight = UITapGestureRecognizer(target:self, action:#selector(QuestionTableViewCell.tappedRight(_:)))

            self.imgLeft.addGestureRecognizer(tapGestureRecoginzerLeft)
            self.imgRight.addGestureRecognizer(tapGestureRecoginzerRight)
            
            self.lblQuestion.text = self.question.askerName
            self.imgProfileImage.kf_setImageWithURL(NSURL(string: self.question.askerProfileImage!)!)
        }
    }
    
    func tappedLeft(gesture: UITapGestureRecognizer ) {
        if self.question.answer != nil {
            return
        }
        
        self.question.optionACount += 1
        showVotes()
        
        self.question.answer = .Left
        
        // show selection tick
        self.imgCheckLeft.hidden = false
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: [.CurveEaseInOut], animations: ({
            self.imgCheckLeftBottomConst.constant = self.viewLeft.bounds.size.height - gesture.locationInView(self.viewLeft).y - self.imgCheckLeft.bounds.size.height/2
            //self.imgCheckLeft.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.viewLeft.layoutIfNeeded()
        }), completion: nil)

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
        showVotes()
        
        self.question.answer = .Right
        
        // show selection tick
        self.imgCheckRight.hidden = false
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.imgCheckRightBottomConst.constant = self.viewRight.bounds.size.height - gesture.locationInView(self.viewRight).y - self.imgCheckRight.bounds.size.height/2
            self.viewRight.layoutIfNeeded()
        }), completion: nil)
        
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
        
        // label oluştur
        
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
        if question.isAnswered == true {
            
            let heightA = 40 + (cell.viewLeft.frame.size.height-40) * CGFloat(question.ratioA)
            let heightB = 40 + (cell.viewRight.frame.size.height-40) * CGFloat(question.ratioB)
            
            print("cell height: \(cell.viewLeft.frame.size.height-40), ratioA: \(question.ratioA)")
            
            cell.viewVotesLeftHeightConst.constant = heightA
            cell.viewVotesRightHeightConst.constant = heightB
            
            cell.ratioLeftBottom.constant = heightA - 30
            cell.ratioRightBottom.constant = heightB - 30
            
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
            
            cell.imgCheckLeft.hidden = true
            cell.imgCheckRight.hidden = true
        }
        
        cell.lblInfo.text = "☆ " + String(question.totalAnswerCount) + " Oy" //+ "   ◎ " + String(question.skipCount)
        
        cell.imgLeft.kf_setImageWithURL(NSURL(string: question.optionA)!)
        cell.imgRight.kf_setImageWithURL(NSURL(string: question.optionB)!)
        
    }
}
