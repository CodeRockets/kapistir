//
//  UserProfileViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var imProfileTop: NSLayoutConstraint!
    
    var logoutButton : FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xPos = (self.view.bounds.size.width - 200)/2
        let yPos = self.view.bounds.size.height - 60
        logoutButton.frame = CGRectMake(xPos, yPos, 200, 40)
        self.view.addSubview(logoutButton)
        logoutButton.delegate = self
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user logged out")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        //
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            //handle error
        } else {
            print("button result \(result)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        UIView.animateWithDuration(
            2.0,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: .CurveLinear,
            animations: { () -> Void in
                
                self.imProfileTop.constant = 66
                self.view.layoutIfNeeded()
                
            }, completion: nil)
    }
}
