//
//  UserProfileViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBOutlet weak var imProfileTop: NSLayoutConstraint!
    
    @IBOutlet weak var imgProfile: RoundedImageButton!
    
    @IBOutlet weak var imgProfileBack: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!

    @IBAction func segmentChanged(sender: UISegmentedControl) {
        let tabIndex = sender.selectedSegmentIndex
        print("\(tabIndex)")
        self.setFeedState(tabIndex)
    }
    
    @IBOutlet weak var containerViewMyKapistirs: UIView!
    
    var tabIndex = 0
    
    var myKapistirsTableViewController: UserQuestionsTableViewController!
    
    @IBOutlet weak var containerViewFollows: UIView!
    
    var followedKapistirsTableViewController: UserQuestionsTableViewController!
    
    @IBAction func logOut(sender: AnyObject) {
        UserStore.updateUser(nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var btnToggleEditFeed: UIButton! {
        didSet{
            let img = UIImage(named: "pen-15-128")?.imageWithRenderingMode(.AlwaysTemplate)
            self.btnToggleEditFeed.setImage(img, forState: .Normal)
            self.btnToggleEditFeed.tintColor = UIColor.blackColor()
        }
    }
    
    @IBAction func toggleEditFeed(sender: AnyObject) {
        if tabIndex == 0 {
            let editing = self.myKapistirsTableViewController.editing
            self.myKapistirsTableViewController.setEditing(!editing, animated: true)
            self.btnToggleEditFeed.tintColor = !editing ? UIColor.redColor() : UIColor.blackColor()
        }
        else if tabIndex == 1 {
            let editing = self.followedKapistirsTableViewController.editing
            self.followedKapistirsTableViewController.setEditing(!editing, animated: true)
            self.btnToggleEditFeed.tintColor = !editing ? UIColor.redColor() : UIColor.blackColor()
        }
    }
    
    func setFeedState(tabIndex: Int) {
        
        self.tabIndex = tabIndex
        
        self.lblNoKapistir.hidden = true
        
        // user questions
        if tabIndex == 0 {
            self.containerViewMyKapistirs.hidden = false
            self.containerViewFollows.hidden = true
            self.myKapistirsTableViewController.loadFeed()
            
            self.btnToggleEditFeed.tintColor = self.myKapistirsTableViewController.editing ? UIColor.redColor() : UIColor.blackColor()
        }
        
        // followed questions
        if tabIndex == 1 {
            self.containerViewFollows.hidden = false
            self.containerViewMyKapistirs.hidden = true
            self.followedKapistirsTableViewController.loadFeed()
            
            self.btnToggleEditFeed.tintColor = self.followedKapistirsTableViewController.editing ? UIColor.redColor() : UIColor.blackColor()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Publisher.subscibe("user/userQuestionsLoaded", callback: userQuestionsLoaded)
        Publisher.subscibe("user/followedQuestionsLoaded", callback: followedQuestionsLoaded)

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // user kapistirs tab
        let userKapistirs = storyBoard.instantiateViewControllerWithIdentifier("UserQuestionsTableViewController") as! UserQuestionsTableViewController
        
        self.addChildViewController(userKapistirs)
        userKapistirs.view.frame = CGRectMake(0, 0, self.containerViewMyKapistirs.frame.size.width, self.containerViewMyKapistirs.frame.size.height);
        
        self.containerViewMyKapistirs.addSubview(userKapistirs.view)
        userKapistirs.didMoveToParentViewController(self)
        
        self.myKapistirsTableViewController = userKapistirs
        
        // followed kapistirs
        let followedKapistirs = storyBoard.instantiateViewControllerWithIdentifier("UserQuestionsTableViewController") as! UserQuestionsTableViewController
        
        followedKapistirs.type = "followed"
        
        self.addChildViewController(followedKapistirs)
        followedKapistirs.view.frame = CGRectMake(0, 0, self.containerViewFollows.frame.size.width, self.containerViewFollows.frame.size.height);
        
        self.containerViewFollows.addSubview(followedKapistirs.view)
        followedKapistirs.didMoveToParentViewController(self)
        
        self.followedKapistirsTableViewController = followedKapistirs
        
        self.setFeedState(0)
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var lblNoKapistir: UILabel!
    
    func userQuestionsLoaded(userQuestionsCount: AnyObject?)  {
        print("userQuestionsCount \( userQuestionsCount as! Int )")
        
        let count = userQuestionsCount as! Int
        
        if count == 0 {
            self.lblNoKapistir.text = "Eklenmiş kapıştır yok!"
            self.lblNoKapistir.hidden = false
        }
        else{
            self.lblNoKapistir.hidden = true
        }
    }
    
    func followedQuestionsLoaded(followedQuestionsCount: AnyObject?) {
                
        let count = followedQuestionsCount as! Int
        
        print("followed questions count \(count)")

        if count == 0 {
            self.lblNoKapistir.text = "Takipte kapıştır yok. ♥︎'e tıklayarak takip edebilirsin."
            self.lblNoKapistir.hidden = false
        }
        else{
            self.lblNoKapistir.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imgProfile.setImage(UserStore.user?.profileImage, forState: .Normal)
        self.imgProfileBack.image = UserStore.user?.profileImage
        self.lblUserName.text = UserStore.user?.userName
    }
    
    override func viewDidLayoutSubviews() {
        /*UIView.animateWithDuration(
            2.0,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: .CurveLinear,
            animations: { () -> Void in
                
                self.imProfileTop.constant = 30
                self.view.layoutIfNeeded()
                
            }, completion: nil)*/
    }
}
