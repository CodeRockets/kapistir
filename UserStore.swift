//
//  UserStore.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import Kingfisher
import Crashlytics

class UserStore{
    
    typealias callback = (loggedUser: User)-> Void
    
    private static var _user: User?
    static var user: User? {
        return _user
    }
    
    private static var _callbacks = [callback]()
    
    static func registerUpdateCallback(block: callback) {
        self._callbacks.append(block)
    }
    
    private static func publishUpdate(){
        // notify changes to subscribers
        for block in self._callbacks {
            block(loggedUser: self.user!)
        }
    }

    
    static func updateUser(user: User?){
        print("user will be updated")
        
        self._user = user
        
        if let userData = user {
            KingfisherManager.sharedManager.retrieveImageWithURL(
                NSURL(string: userData.profileImageUrl)!,
                optionsInfo: nil,
                progressBlock: nil,
                completionHandler: { (image, error, cacheType, imageURL) -> () in
                    print("image downloaded \(imageURL)")
                    
                    if error == nil {
                        self._user!.profileImage = image
                        self.saveUserLocal(self._user!)
                        self.publishUpdate()
                    }
                    else{
                        // profile image download error
                        print("profile image download error")
                    }
            })
        }
        else{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(nil, forKey: "userName")
        }
    }
    
    private static func saveUserLocal(user: User) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(user.userId, forKey: "userId")
        defaults.setValue(user.facebookId, forKey: "facebookId")
        defaults.setValue(user.userName, forKey: "userName")
        defaults.setValue(user.profileImageUrl, forKey: "profileImageUrl")
        
        if let userImage = self.user!.profileImage {
            print("save user local with image")
            saveProfileImageLocal(userImage)
        }
    }
    
    static func loadUserLocal() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // localde kayıtlı kullanıcı var mı?
        if let userName = defaults.valueForKey("userName") {

            let profileImage = loadProfileImageLocal()
            
            self._user = User(
                userName: userName as! String,
                userId: defaults.valueForKey("userId") as! String,
                profileImageUrl: defaults.valueForKey("profileImageUrl") as! String,
                facebookId: defaults.valueForKey("facebookId") as! String,
                profileImage: profileImage,
                questions: [Question]()
            )
            
            print("loading user local \(self._user)")
            
            self.publishUpdate()
            
            // Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
            Crashlytics.sharedInstance().setUserIdentifier(self._user!.facebookId)
            Crashlytics.sharedInstance().setUserName(self._user!.userName)
        }
    }
    
    private static func saveProfileImageLocal(image: UIImage) -> Bool {
        print("saving image to local")
        let imagePath = fileInDocumentsDirectory("userProfileImage.jpeg")
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = jpgImageData!.writeToFile(imagePath, atomically: true)
        
        return result
    }
    
    private static func loadProfileImageLocal() -> UIImage? {
        print("loading image form local")
        
        let imagePath = fileInDocumentsDirectory("userProfileImage.jpeg")
        let image = loadImageFromPath(imagePath)

        print("\(image)")
        
        return image
    }

}

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(path)
    }
}

// Documents directory
func documentsDirectory() -> String {
    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    return documentsFolderPath
}

// File in Documents directory
func fileInDocumentsDirectory(filename: String) -> String {
    return documentsDirectory().stringByAppendingPathComponent(filename)
}

func loadImageFromPath(path: String) -> UIImage? {
    let data = NSData(contentsOfFile: path)
    let image = UIImage(data: data!)
    return image
}