//
//  MainViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    
    @IBOutlet weak var btnProfile: RoundedImageButton!
    
    @IBAction func create() {
        
        if let _ = FBSDKAccessToken.currentAccessToken()?.userID {
            self.performSegueWithIdentifier("gotoCreate", sender: self)
        }
        else{
            
            askFacebookLogin()
            
            //self.performSegueWithIdentifier("gotoLogin", sender: self)
        }
    }
    
    @IBAction func gotoProfile(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoProfile", sender: self)
    }
    
    
    func askFacebookLogin() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Swiftly Now! Choose an option!", preferredStyle: .Alert)
        
        let iptalAction: UIAlertAction = UIAlertAction(title: "İptal", style: .Cancel) { action -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        actionSheetController.addAction(iptalAction)
        let evetAction: UIAlertAction = UIAlertAction(title: "Evet", style: .Default) { action -> Void in
            //Do some other stuff
            //
        }
        actionSheetController.addAction(evetAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.viewUserLogin.layer.cornerRadius = 10
        //self.viewUserLogin.clipsToBounds = true
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userLogIn:"), name: "onUserLogIn", object: nil)
        
        let token = FBSDKAccessToken.currentAccessToken()?.tokenString
        print(token)
    }
    
    func userLogIn(loggedUser: User){
        
        KingfisherManager.sharedManager.retrieveImageWithURL(
            NSURL(string: loggedUser.profileImageUrl)!,
            optionsInfo: nil,
            progressBlock: nil,
            completionHandler: { (image, error, cacheType, imageURL) -> () in
                self.btnProfile.setBackgroundImage(image, forState: .Normal)
            })
        
        self.performSegueWithIdentifier("gotoCreate", sender: self)
    }
}
