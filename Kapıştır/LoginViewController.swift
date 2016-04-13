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
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func cancelLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xPos = (self.view.bounds.size.width - 200)/2
        loginView.frame = CGRectMake(xPos, 210, 200, 40)
        
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
    
    func returnUserData() {
        let token = FBSDKAccessToken.currentAccessToken()?.tokenString
        
        lblTitle.text = "Başarılı!"
        lblText.text = "Kayıt tamamlanıyor!"
        
        Api.saveUser(token!,
            errorCallback: { () -> Void in
                // hata
                print("user save error")
            },
            successCallback: { (loggedUser) -> Void in
                
                UserStore.updateUser(loggedUser)
                
                print("user saved")
                
                self.dismissViewControllerAnimated(false, completion:  {
                    Publisher.publish("user/loggedin", data: nil)
                })
            })
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        self.loginView.hidden = true
        self.btnCancel.hidden = true
        
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //
    }
    
    
}
