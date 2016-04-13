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
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        }
    }
    
    @IBAction func gotoProfile(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoProfile", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = FBSDKAccessToken.currentAccessToken()?.tokenString
        print(token)
    }
    
    @IBAction func userDidLogIn(segue:UIStoryboardSegue){
        
        print("unwinded segue")
        
        dispatch_async(dispatch_get_main_queue()){
            
            self.performSegueWithIdentifier("gotoCreate", sender: self)
            
        }
        
        /*KingfisherManager.sharedManager.retrieveImageWithURL(
            NSURL(string: UserStore._user.profileImageUrl)!,
            optionsInfo: nil,
            progressBlock: nil,
            completionHandler: { (image, error, cacheType, imageURL) -> () in
                self.btnProfile.setBackgroundImage(image, forState: .Normal)
            })*/
        
        
    }
}
