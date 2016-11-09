//
//  Question.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import UIKit

class Question {
    
    var id: String
    var optionA: String
    var optionB: String
    var optionACount: Int
    var optionBCount: Int
    var skipCount: Int
    
    var askerName: String?
    var askerUserId: String?
    var askerProfileImage: String?
    
    var answer: Answer?
    
    var isAnswered: Bool = false
    
    var isFollowed: Bool = false
    
    var friends: [User]?
    
    var totalAnswerCount: Int {
        return optionACount + optionBCount
    }
    
    var ratioA: Double {
        return totalAnswerCount > 0 ? Double(optionACount) / Double(totalAnswerCount) : 0
    }
    
    var ratioB: Double {
        return totalAnswerCount > 0 ? Double(optionBCount) / Double(totalAnswerCount) : 0
    }

    var ratioSkip: Double {
        return totalAnswerCount > 0 ? Double(skipCount) / Double(totalAnswerCount) : 0
    }
    
    init(id: String, optionA: String, optionB: String,
         optionACount:Int, optionBCount:Int, skipCount: Int,
         askerName: String?, askerUserId: String?, askerProfileImage: String?, friends: [User]?)
    {
        self.id = id
        self.optionA = optionA
        self.optionB = optionB
        self.optionACount = optionACount
        self.optionBCount = optionBCount
        self.skipCount = skipCount
        self.askerName = askerName
        self.askerUserId = askerUserId
        self.askerProfileImage = askerProfileImage
        self.friends = friends
    }
}

extension Question {
    static func fromApiResponse(response: NSDictionary) -> Question {
        // api reponse'dan gelen json ile instance oluştur
        
        let id = response["id"] as! String
        let optionA = response["option_a"] as! String
        let optionB = response["option_b"] as! String
        
        let optionACount = response["option_a_count"] as! Int
        let optionBCount = response["option_b_count"] as! Int
        let skipCount = response["skip_count"] as! Int
        
        let askerName = response["asker_name"] as? String
        let askerProfileImage = response["asker_profile_img"] as? String
        let askerUserId = response["user_id"] as? String
        
        var friends = [User]()
        
        if let friendsJson = response["friends"] as? [AnyObject] {
            for j in friendsJson {
            
                let userName = j["name"] as! String
                let userId = j["facebook_id"] as! String
                let profileImage = j["profile_img"] as! String
                let option = Answer(rawValue: j["option"] as! String)
            
                friends.append(User(userName: userName, userId: userId, profileImageUrl: profileImage, facebookId: userId, profileImage: nil, questions: [], userVotedOption: option))
            }
        }

        let question = Question(
            id: id, optionA: optionA, optionB: optionB, optionACount: optionACount, optionBCount: optionBCount, skipCount: skipCount,
            askerName: askerName, askerUserId: askerUserId, askerProfileImage: askerProfileImage, friends: friends
        )
        
        return question
    }
}