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
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        
        print("Login button result: \(result)")
        
        if error != nil {
            //handle error
        } else {
            returnUserData()
        }
    }
    
    func returnUserData()
    {
        /*
        fetched user: {
            "age_range" =     {
                min = 21;
            };
            birthday = "04/28/1984";
            email = "yortucboylu@outlook.com";
            gender = male;
            id = 10153896019412696;
            name = "Evren Yortu\U00e7boylu";
            picture =     {
                data =         {
                    height = 480;
                    "is_silhouette" = 0;
                    url = "https://scontent.xx.fbcdn.net/hprofile-xat1/v/t1.0-1/p480x480/11949472_10153473987572696_3503959071618892326_n.jpg?oh=2429bf184dc01e4d11a5786a3e75d161&oe=57985189";
                    width = 480;
                };
            };
        }
        */
        
        FBSDKGraphRequest(
            graphPath: "me",
            parameters: ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"]
        )
        .startWithCompletionHandler { (connection, result, error) -> Void in
            
            if error != nil {
                print("login error \(error)")
                return
            }
                
            let userInfo = [
                "facebookId" : result.valueForKey("id") as! String,
                "userName" : result.valueForKey("name") as! String,
                "profileImageUrl": result["picture"]!!["data"]!!["url"] as! String
            ]
            
            print("fb login \(userInfo)")
            
            UserStore.facebookLogin(userInfo)
            
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("onUserLogIn", object: nil)
            })
        }
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        //
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //
    }
    
    
}
