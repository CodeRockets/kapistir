//
//  CreateSuccessViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 20/04/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class ModalSaveQuestionSuccess: UIView {
    
    var image: UIImage? {
        set {
            self.imageView.image = newValue
        }
        get {
            return self.imageView.image
        }
    }
    
    var bottomButtonHandler: (() -> Void)?
    var closeButtonHandler: (() -> Void)?
    
    @IBAction func closeButton(sender: AnyObject) {
        self.closeButtonHandler!()
    }
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    private func configure() {
        self.contentView.layer.cornerRadius = 5.0
    }
    
    class func instantiateFromNib() -> ModalSaveQuestionSuccess {
        let view = UINib(nibName: "ModalSaveQuestionSuccess", bundle: nil).instantiateWithOwner(nil, options: nil).first as! ModalSaveQuestionSuccess
        
        return view
    }
    
}