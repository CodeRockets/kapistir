//
//  MainViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBAction func create() {
        
        if let _ = FBSDKAccessToken.currentAccessToken()?.userID {
            self.performSegueWithIdentifier("gotoCreate", sender: self)
        }
        else{
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.viewUserLogin.layer.cornerRadius = 10
        //self.viewUserLogin.clipsToBounds = true
    }
}
