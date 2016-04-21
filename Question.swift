//
//  Question.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import UIKit

/*
api response
{
    "id": "4d4e2e20-d8ce-11e5-a366-81d5b1bd3d08",
    "question_text": "Referandum tutacak mı?",
    "question_image": "",
    "user_id": "user_id",
    "app": 0,
    "option_a": "evet",
    "option_b": "hayir",
    "option_a_count": 0,
    "option_b_count": 0,
    "skip_count": 0,
    "created_at": "2016-02-21T19:07:07.000Z",
    "updated_at": "2016-02-21T19:07:07.000Z",
    "is_deleted": true
}

//var questionText: String?
//var questionImageUrl: String?
//var userId: String?
//var app: Int?
//var createdAt: NSDate?
//var updatedAt: NSDate?
//var isDeleted: Bool?
*/

class Question {
    
    var id: String
    var optionA: String
    var optionB: String
    var optionACount: Int
    var optionBCount: Int
    var skipCount: Int
    
    var answer: Answer?
    
    var isAnswered: Bool = false
    
    var imageLeft: UIImage?
    var imageRight: UIImage?
    
    var totalAnswerCount: Int {
        return optionACount + optionBCount
    }
    
    var ratioA: Double {
        return totalAnswerCount > 0 ? Double(optionACount) / Double(totalAnswerCount) : 0
    }
    
    var ratioB: Double {
        return totalAnswerCount > 0 ? Double(optionBCount) / Double(totalAnswerCount) : 0
    }

    init(id: String, optionA: String, optionB: String, optionACount:Int, optionBCount:Int, skipCount: Int){
        self.id = id
        self.optionA = optionA
        self.optionB = optionB
        self.optionACount = optionACount
        self.optionBCount = optionBCount
        self.skipCount = skipCount
    }
}

extension Question {
    static func fromApiResponse(response: NSDictionary) -> Question {
        // api reponse'dan gelen json ile instance oluştur
        
        let id = response["id"] as! String
        let optionA = (response["option_a"] as! String)
        let optionB = response["option_b"] as! String
        
        let optionACount = response["option_a_count"] as! Int
        let optionBCount = response["option_b_count"] as! Int
        let skipCount = response["skip_count"] as! Int
        
        // test
        //let optionACount = Int(arc4random_uniform(100) + 1)
        //let optionBCount = Int(arc4random_uniform(100) + 1)
        //let skipCount =   Int(arc4random_uniform(12) + 1)
        
        let question = Question(
            id: id, optionA: optionA, optionB: optionB, optionACount: optionACount, optionBCount: optionBCount, skipCount: skipCount
        )
        
        return question
    }
}