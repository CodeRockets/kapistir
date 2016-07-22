//
//  ModalCreateOnboarding.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 23/07/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class ModalCreateOnboarding: UIView {
   
    var bottomButtonHandler: (() -> Void)?
    var closeButtonHandler: (() -> Void)?
    
    @IBAction func closeButton(sender: AnyObject) {
        self.closeButtonHandler!()
    }
    
    //@IBOutlet weak var contentView: UIView!
    
    //@IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    private func configure() {
        //self.contentView.layer.cornerRadius = 5.0
    }
    
    class func instantiateFromNib() -> ModalCreateOnboarding {
        let view = UINib(nibName: "ModalCreateOnboarding", bundle: nil).instantiateWithOwner(nil, options: nil).first as! ModalCreateOnboarding
        
        return view
    }

}
