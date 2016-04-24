//
//  UserProfileViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var imProfileTop: NSLayoutConstraint!
    
    @IBOutlet weak var imgProfile: RoundedImageButton!
    
    @IBOutlet weak var imgProfileBack: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBAction func logOut(sender: AnyObject) {
        UserStore.updateUser(nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
