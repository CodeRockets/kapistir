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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
       
    }
    
    override func viewWillAppear(animated: Bool) {

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
