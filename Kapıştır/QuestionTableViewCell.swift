//
//  QuestionTableViewCell.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import M13Checkbox
import AZExpandableIconListView
import Kingfisher

class QuestionTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {
    
    var question: Question!
    
    private var actionDetails: UIAlertController!
    
    private var actionReportAbuse: UIAlertController!
    
    private var actionBan: UIAlertController!

    @IBOutlet weak var btnFollow: UIButton! {
        didSet{
            let img = UIImage(named: "heart")?.imageWithRenderingMode(.AlwaysTemplate)
            self.btnFollow.setImage(img, forState: .Normal)
            self.btnFollow.tintColor = App.UI.colorButtonFollow
        }
    }
    
    @IBAction func btnFollow(sender: AnyObject) {
        print("follow question")
        

        self.question.isFollowed = !self.question.isFollowed
        Api.updateFollowQuestion(self.question, errorCallback: {
                //
            }, successCallback: {
                //
            })
        
        UIView.animateWithDuration(0.1,
            animations: {
                let transformScale = CGAffineTransformMakeScale(0.6, 0.6)
                //let transformShake = CGAffineTransformMakeRotation(CGFloat(0.3))
                self.btnFollow.transform = transformScale //CGAffineTransformConcat(transformScale, transformShake)
            },
            completion: { finish in
                self.btnFollow.tintColor = self.question.isFollowed ?
                    UIColor.redColor() : App.UI.colorButtonFollow
                
                
                UIView.animateWithDuration(0.3,
                    delay: 0.0,
                    usingSpringWithDamping: 0.2,
                    initialSpringVelocity: 10.0,
                    options: [.CurveEaseInOut, .AllowUserInteraction],
                    animations: ({
                        self.btnFollow.transform = CGAffineTransformIdentity
                    }),
                    completion: nil)
            })
    }
    
    
    @IBOutlet weak var btnDetails: UIButton! {
        didSet{
            let img = UIImage(named: "details")?.imageWithRenderingMode(.AlwaysTemplate)
            self.btnDetails.setImage(img, forState: .Normal)
            self.btnDetails.tintColor = App.UI.colorButtonFollow
        }
    }
    
    
    @IBAction func showDetails(sender: AnyObject) {
        print("show details")
        
        self.setupDetailsActionsheet()
        
        App.UI.getTopMostViewController()
              .presentViewController(self.actionDetails, animated: true, completion: nil)
    }
    
    @IBOutlet weak var ratioLeftBottom: NSLayoutConstraint!
    
    @IBOutlet weak var ratioRightBottom: NSLayoutConstraint!
    
    @IBOutlet weak var ratioLeft: UILabel!
    
    @IBOutlet weak var ratioRight: UILabel!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var viewFooter: UIView!
    
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
    
    @IBOutlet weak var avatarViewLeft: MDGroupAvatarView!
    
    @IBOutlet weak var avatarViewRight: MDGroupAvatarView!
    
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
        
        // show friend list on avatar view tap
        let avatarViewLeftGR = UITapGestureRecognizer(target: self, action: #selector(self.showFriendListLeft))
        let avatarViewRightGR = UITapGestureRecognizer(target: self, action: #selector(self.showFriendListRight))
        
        self.avatarViewLeft.addGestureRecognizer(avatarViewLeftGR)
        self.avatarViewRight.addGestureRecognizer(avatarViewRightGR)
    }
    
    func showFriendListLeft() {
        Publisher.publish("question/showFriendsListLeft", data: self)
    }
    
    func showFriendListRight() {
        Publisher.publish("question/showFriendsListRight", data: self)
    }
    
    func setupReportAbuseActionsheet() {
        self.actionReportAbuse = UIAlertController(
            title: "Şikayet",
            message: "Bu kapıştır'ı uygunsuz içerik sebebiyle şikayet etmek istediğinize emin misiniz?",
            preferredStyle: .Alert)
        
        self.actionReportAbuse.addAction(UIAlertAction(title: "Evet", style: .Default, handler: { (action: UIAlertAction!) in
            
            //report abuse
            Api.reportQuestion(self.question, errorCallback: {
                //
                }, successCallback: {
                    //
                    let successAlert = UIAlertController(title: "Başarılı", message: "Şikayetiniz alınmıştır. Teşekkür ederiz.", preferredStyle: .Alert)
                    
                    successAlert.addAction(UIAlertAction(title: "Tamam", style: .Default, handler: nil))
                    
                    App.UI.getTopMostViewController().presentViewController(successAlert, animated: true, completion: nil)
                })
        }))
        
        self.actionReportAbuse.addAction(UIAlertAction(title: "İptal", style: .Cancel, handler: { (action: UIAlertAction!) in
            
            // cancel
        }))
    }
    
    func setupBanActionsheet() {
        self.actionBan = UIAlertController(
            title: "Kullanıcıyı Engelle",
            message: self.question.askerName! + " kullanıcısını engellemek istediğinize emin misiniz?",
            preferredStyle: .Alert)
        
        self.actionBan.addAction(UIAlertAction(title: "Evet", style: .Default, handler: { (action: UIAlertAction!) in
            
            // ban user
            Api.banUser(self.question, errorCallback: {

                }, successCallback: {
                    //
                    let successAlert = UIAlertController(title: "Başarılı", message: "Kullanıcı engellendi. Bundan sonra bu kullanıcının kapıştırlarını görmeyeceksiniz.", preferredStyle: .Alert)
                    
                    successAlert.addAction(UIAlertAction(title: "Tamam", style: .Default, handler: nil))
                    
                    App.UI.getTopMostViewController().presentViewController(successAlert, animated: true, completion: nil)
            })
        }))
        
        self.actionBan.addAction(UIAlertAction(title: "İptal", style: .Cancel, handler: { (action: UIAlertAction!) in
            // cancel
        }))
    }
    
    func setupDetailsActionsheet() {
        self.actionDetails = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let actionReport = UIAlertAction(title: "Şikayet Et", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            print("şikayet et")
            App.UI.getTopMostViewController().presentViewController(self.actionReportAbuse, animated: true, completion: nil)

        })
        
        
        let actionBan = UIAlertAction(title: "Kullanıcıyı Engelle", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            print("engelle")
            App.UI.getTopMostViewController().presentViewController(self.actionBan, animated: true, completion: nil)
            
        })
        
        let actionShareFb = UIAlertAction(title: "Facebook'ta paylaş", style: .Default) { (alert: UIAlertAction!) -> Void in
            print("fb paylaş")
            
            let generator = KapistirImageGenerator(
                leftRect: self.imgLeft.bounds,
                rightRect: self.imgRight.bounds,
                leftImage: self.imgLeft.image!,
                rightImage: self.imgRight.image!,
                answer: self.question.answer)
            
            let kapistirImage = generator.generateImage()
            
            let share = ShareManager(kapistirImage: kapistirImage)
            //share.facebook()
            share.facebook()
        }
        
        let actionShareTwitter = UIAlertAction(title: "Tweet gönder", style: .Default) { (alert: UIAlertAction!) -> Void in
            
            print("Twit gönder")
            
            let generator = KapistirImageGenerator(
                leftRect: self.imgLeft.bounds,
                rightRect: self.imgRight.bounds,
                leftImage: self.imgLeft.image!,
                rightImage: self.imgRight.image!,
                answer: self.question.answer)
            
            let kapistirImage = generator.generateImage()
            
            let share = ShareManager(kapistirImage: kapistirImage)
            //share.facebook()
            share.twitter()
        }
        
        let actionDissmiss = UIAlertAction(title: "İptal", style: .Cancel, handler: nil)
        
        self.actionDetails.addAction(actionShareFb)
        self.actionDetails.addAction(actionShareTwitter)
        
        self.actionDetails.addAction(actionReport)
        self.actionDetails.addAction(actionBan)
        self.actionDetails.addAction(actionDissmiss)
        
        self.setupReportAbuseActionsheet()
        self.setupBanActionsheet()
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
        self.avatarViewRight.hidden = false
        self.avatarViewLeft.hidden = false
        
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
        
        QuestionTableViewCell.loadFriends(cell)
        
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
        
            cell.avatarViewLeft.hidden = false
            cell.avatarViewRight.hidden = false
            
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
            
            cell.avatarViewLeft.hidden = true
            cell.avatarViewRight.hidden = true
        }
        
        cell.btnFollow.tintColor = question.isFollowed ? UIColor.redColor() : App.UI.colorButtonFollow
        
        cell.lblInfo.text = "☆ " + String(question.totalAnswerCount) + " Oy" //+ "   ◎ " + String(question.skipCount)
        cell.imgLeft.kf_setImageWithURL(NSURL(string: question.optionA)!)
        cell.imgRight.kf_setImageWithURL(NSURL(string: question.optionB)!)
    }
    
    static func loadFriends(cell: QuestionTableViewCell) {
        
        // left friends
        let urlsLeft = cell.question.friends?
            .filter({ (friend) -> Bool in
                return friend.userVotedOption == .Left
            })
            .map({ (friend) -> NSURL in
                return NSURL(string: friend.profileImageUrl)!
            })
    
        let urlsRight = cell.question.friends?
            .filter({ (friend) -> Bool in
                return friend.userVotedOption == .Right
            })
            .map({ (friend) -> NSURL in
                return NSURL(string: friend.profileImageUrl)!
            })
        
        print("urlsLeft \(urlsLeft)")
        print("urlsRight \(urlsRight)")

        let resourcesLeft = urlsLeft!.map ({ (url) -> Resource in
            return Resource(downloadURL: url)
        })
        
        let resourcesRight = urlsRight!.map({ (url) -> Resource in
            return Resource(downloadURL: url)
        })
        
        print("resourcesLeft \(resourcesLeft)")
        print("resourcesRight \(resourcesRight)")
        
        if resourcesLeft.count > 0 {
            getFriendImagesFromCache(resourcesLeft, index: 0, images: []) { (images) in
                print("left images getted from cache \(images)")

                cell.avatarViewLeft.setAvatarImages(images, realTotal: images.count)
            }
        }else{
            cell.avatarViewLeft.setAvatarImages([], realTotal: 0)
        }
        
        if resourcesRight.count > 0 {
            getFriendImagesFromCache(resourcesRight, index: 0, images: []) { (images) in
                print("right images getted from cache \(images)")
            
                cell.avatarViewRight.setAvatarImages(images, realTotal: images.count)
            }
        }else{
            cell.avatarViewRight.setAvatarImages([], realTotal: 0)
        }
    }
    
    static func getFriendImagesFromCache(resources: [Resource], index: Int=0, images: [UIImage]=[], callback: ( [UIImage] )-> Void) {
        
        var collectedImages = images
        let currentResource = resources[index]
        
        ImageCache.defaultCache.retrieveImageForKey(currentResource.cacheKey, options: nil, completionHandler: { (image, _) in
            collectedImages.append(image!)
            
            if resources.count == index + 1 {
                callback(collectedImages)
            }
            else{
                self.getFriendImagesFromCache(resources, index: index+1, images: collectedImages, callback: callback)
            }
        })
    }
}
