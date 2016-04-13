//
//  LoginViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import Pulsator

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    var loginView : FBSDKLoginButton = FBSDKLoginButton()
    
    @IBAction func cancelLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xPos = (self.view.bounds.size.width - 200)/2
        loginView.frame = CGRectMake(xPos, 210, 200, 40)
        loginView.titleLabel?.text = "Facebook ile giriş yap!"
        
        self.view.addSubview(loginView)
        loginView.readPermissions = ["public_profile", "email", "user_friends","user_birthday"]
        
        loginView.delegate = self
        
        // UserStore.registerUpdateCallback(userSaved)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        
        print("Login button result: \(result)")
        
        if error != nil {
            //handle error
        } else {
            returnUserData()
        }
    }
    
    func userSaved(loggedUser: User) {
    }
    
    func returnUserData()
    {
        let token = FBSDKAccessToken.currentAccessToken()?.tokenString
        
        print("user will be save \(token)")
        
        Api.saveUser(token!,
            errorCallback: { () -> Void in
                // hata
                print("user save error")
                
            },
            successCallback: { (loggedUser) -> Void in
                
                UserStore.updateUser(loggedUser)
                
                print("user saved, will unwind")
                
                dispatch_async(dispatch_get_main_queue()){
                   self.dismissViewControllerAnimated(true, completion: {
                        self.performSegueWithIdentifier("userDidLogin", sender: self)
                   })
                    //self.performSegueWithIdentifier("userDidLogin", sender: self)
                }
            })
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        //
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //
    }
    
    
}
