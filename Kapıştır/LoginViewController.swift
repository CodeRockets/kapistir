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
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController, UITextFieldDelegate, LoginButtonDelegate {
    
    var loginView: LoginButton!
    
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
        let loginFrame = CGRectMake(xPos, 210, 200, 40)
        
        self.loginView = LoginButton(frame: loginFrame, readPermissions: [.PublicProfile, .Email, .UserFriends])

        loginView.delegate = self
        
        self.view.addSubview(loginView)
        
        // UserStore.registerUpdateCallback(userSaved)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func loginButton(loginButton: LoginButton!, didCompleteWithResult result: LoginResult!, error: NSError!) {
            //
    }
    
    func returnUserData() {
        let token = AccessToken.current!.authenticationToken
        
        lblTitle.text = "Başarılı!"
        lblText.text = "Kayıt tamamlanıyor!"
        
        Api.saveUser(token,
            errorCallback: { () -> Void in
                // hata
                print("user save error")
            },
            successCallback: { (loggedUser) -> Void in
                
                UserStore.updateUser(loggedUser)
                
                print("user saved \(loggedUser)")
                
                self.dismissViewControllerAnimated(false, completion:  {
                    Publisher.publish("user/loggedin", data: nil)
                })
            })
    }
    
    func loginButtonWillLogin(loginButton: LoginButton!) -> Bool {
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        self.loginView.hidden = true
        self.btnCancel.hidden = true
        
        return true
    }
    
    func loginButtonDidCompleteLogin(loginButton: LoginButton, result: LoginResult) {
        print("Login button result: \(result)")
        
        self.view.layoutIfNeeded()
        
        switch result {
        case .Cancelled:
            print("fb login error")
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.loginView.hidden = false
            self.btnCancel.hidden = false
            
            break
        case .Failed(let error):
            print("fb login error \(error)")

            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.loginView.hidden = false
            self.btnCancel.hidden = false
            
            break
        case .Success(let grantedPermissions, let declinedPermissions, let token):
            
            self.activityIndicator.hidden = false
            self.loginView.hidden = true
            self.btnCancel.hidden = true
            
            returnUserData()
            
            break
        }
    }
    
    func loginButtonDidLogOut(loginButton: LoginButton) {
        //
    }
}
