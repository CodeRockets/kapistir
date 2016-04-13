//
//  UserStore.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation

class UserStore{
    
    typealias callback = (loggedUser: User)-> Void
    
    static var _user: User!
    
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
        self._user = user
        self.publishUpdate()
    }
    
    private static func save(user: User) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(user.facebookId, forKey: "facebookId")
        defaults.setValue(user.userName, forKey: "userName")
        defaults.setValue(user.profileImageUrl, forKey: "profileImageUrl")
    }
}