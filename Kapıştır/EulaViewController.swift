//
//  EulaViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 09/09/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class EulaViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
}
