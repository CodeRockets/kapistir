//
//  ShareManager.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 02/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookShare
import Social

class ShareManager: NSObject {
    
    private var kapistirImage: UIImage!
    
    init(kapistirImage: UIImage) {
        self.kapistirImage = kapistirImage
    }
    
    func facebookNative() {
        
        do{
            let photo = Photo(image: self.kapistirImage, userGenerated: true)
            var content = PhotoShareContent(photos: [photo])
            let shareDialog = ShareDialog(content: content)
            content.hashtag = Hashtag("kapıştır")
            shareDialog.mode = .Native
            shareDialog.failsOnInvalidData = true
            shareDialog.completion = { result in
                // Handle share results
                print("bitti")
            }
            
            try shareDialog.show()
        }
        catch(let error){
            print("hata: \(error)")
        }
    }
    
    func facebook() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc.setInitialText("#kapıştır")
        vc.addImage(self.kapistirImage)
        // vc.addURL(NSURL(string: "http://www.google.com"))
        App.UI.getTopMostViewController().presentViewController(vc, animated: true, completion: nil)
    }
    
    func twitter() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.setInitialText("#kapıştır")
        vc.addImage(self.kapistirImage)
        // vc.addURL(NSURL(string: "http://www.google.com"))
        App.UI.getTopMostViewController().presentViewController(vc, animated: true, completion: nil)
    }
}