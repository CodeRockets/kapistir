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
    
    @IBOutlet weak var viewToolbar: UIVisualEffectView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewToolbar.hidden = !App.UI.onboarded
        
        //self.activityIndicator.startAnimating()
        
        UserStore.registerUpdateCallback(userUpdate)
        
        // QuestionStore.registerUpdateCallback(questionsUpdate)
        
        Publisher.subscibe("user/loggedin", callback: userLoggedIn)
        
        Publisher.subscibe("user/didFinishOnboarding", callback: userFinishedOnboarding)
    }
    
    private func userUpdate(user: User) {
        print("user updated callback image: \(user.profileImage)")
        dispatch_async(dispatch_get_main_queue()) {
            self.btnProfile.setImage(user.profileImage, forState: .Normal)
        }
    }
    
    private func questionsUpdate(questions: [Question]) {
        //self.activityIndicator.stopAnimating()
    }
    
    func userFinishedOnboarding(data: AnyObject?) {
        self.viewToolbar.hidden = false
        App.Store.saveUserOnboarded()
    }
    
    func userLoggedIn(data: AnyObject?) {
        print("user did login callback")
        
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("gotoCreate", sender: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {        
        if let _ = UserStore.user {
            print("user logged in")
            self.btnProfile.hidden = false
            let profileImage = UserStore.user!.profileImage
            self.btnProfile.setImage(profileImage, forState: .Normal)
        } else {
            print("no user")
            self.btnProfile.hidden = true
        }
        
        // self.viewToolbar.hidden = !App.UI.onboarded
    }
    
    @IBAction func create() {
        if let _ = UserStore.user {
            self.performSegueWithIdentifier("gotoCreate", sender: self)
        }
        else{
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        }
    }
    
    @IBAction func gotoProfile(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoProfile", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        print("memory warning!!!")
        
        
        
        super.didReceiveMemoryWarning()
    }
}
