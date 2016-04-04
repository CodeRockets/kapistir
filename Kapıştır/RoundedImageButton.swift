//
//  RoundedImageButton.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageButton: UIButton {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   /* override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }*/
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }

}
