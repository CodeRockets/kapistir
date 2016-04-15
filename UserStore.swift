//
//  UserStore.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import Kingfisher

class UserStore{
    
    typealias callback = (loggedUser: User)-> Void
    
    /*private*/ static var _user: User!
    
    private static var _callbacks = [callback]()
    
    private static var _userImage: UIImage!
    
    static func registerUpdateCallback(block: callback) {
        self._callbacks.append(block)
    }
    
    private static func publishUpdate(){
        for block in self._callbacks {
            block(loggedUser: self._user)
        }
    }
    
    static func updateUser(user: User){
        print("user will be updated \(user)")
        self._user = user
        self.publishUpdate()
        self.donwloadProfileImage()
    }
    
    private static func donwloadProfileImage() {
        print("image url \(UserStore._user.profileImageUrl)")
        
        KingfisherManager.sharedManager.retrieveImageWithURL(
            NSURL(string: self._user.profileImageUrl)!,
            optionsInfo: nil,
            progressBlock: nil,
            completionHandler: { (image, error, cacheType, imageURL) -> () in
                print("image downloaded \(error)  \(imageURL)")
                
                if error == nil {
                    self._user.profileImage = image
                    self.publishUpdate()
                }
                else{
                    // profile image download error
                }
            })
    }
    
    private static func saveUserLocal(user: User) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(user.userId, forKey: "userId")
        defaults.setValue(user.facebookId, forKey: "facebookId")
        defaults.setValue(user.userName, forKey: "userName")
        defaults.setValue(user.profileImageUrl, forKey: "profileImageUrl")
    }
    
    private static func getUserLocal() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        self._user = User(
            userName: defaults.valueForKey("userName") as! String,
            userId: defaults.valueForKey("userId") as! String,
            profileImageUrl: defaults.valueForKey("profileImageUrl") as! String,
            facebookId: defaults.valueForKey("facebookId") as! String,
            profileImage: nil
        )
    }
    
    private func saveImageLocal(image: UIImage, path: String ) -> Bool {
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = jpgImageData!.writeToFile(path, atomically: true)
        
        return result
    }
    
    private func loadImageLocal(filename:String) -> UIImage {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let filePath = documentsURL.URLByAppendingPathComponent(filename).path!
        let image = UIImage(contentsOfFile: filePath)
        
        return image!
    }
}