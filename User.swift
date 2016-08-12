//
//  User.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 16/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import Kingfisher

struct User {
    var userName: String
    var userId: String
    
    var profileImageUrl: String
    var facebookId: String
    
    var profileImage: UIImage?
    
    var questions = [Question]()
    
    var userVotedOption: Answer?
    
    //var facebookToken: String
    // var score: Int = 0
}