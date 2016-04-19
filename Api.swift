//
//  Api.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import Kingfisher
import Alamofire
import SwiftyJSON

struct Api {
    
    static func getBatch( errorCallback: ()-> Void, successCallback: ([Question])-> Void ) {
        
        let url = NSURL(string: App.URLs.getQuestionsUrl)

        var retQuestions = [Question]()
        
        let request = NSMutableURLRequest(URL: url!)
        
        request.setValue("application/json",    forHTTPHeaderField: "Accept")
        request.setValue(App.Keys.clientId,     forHTTPHeaderField: "x-voter-client-id")
        request.setValue(App.Keys.version,      forHTTPHeaderField: "x-voter-version")
        request.setValue(App.Keys.installation, forHTTPHeaderField: "x-voter-installation")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
           
            if error != nil {
                errorCallback()
            }
                
            do {
                
                if let responseData = data {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(responseData, options: .MutableContainers)
                    
                    let rows = jsonData["rows"] as! NSArray
                    
                    for questionData in rows {
                        
                        print("question: \(questionData)")
                        let question = Question.fromApiResponse(questionData as! NSDictionary)
                        retQuestions.append(question)
                    }
                    
                    fetchBatchImages(retQuestions, errorCallback: errorCallback, successCallback: successCallback)
                }
                else{
                    errorCallback()
                }
               
                
            } catch {
                errorCallback()
            }
            
        }.resume()
    }
    
    static func fetchBatchImages(batch: [Question], errorCallback: ()->Void, successCallback: ([Question])-> Void) {
        
        let urlsA = batch.filter({
            NSURL(string: $0.optionA) != nil
        }).map { (question) -> NSURL in
            return NSURL(string: question.optionA)!
        }
        
        let urls = urlsA + batch.filter({ (question) -> Bool in
            NSURL(string: question.optionA) != nil
        }).map({ (question) -> NSURL in
             return NSURL(string: question.optionB)!
        })
        
        print("image urls:  \(urls)")
        
        let prefetcher = ImagePrefetcher(urls: urls, optionsInfo: nil, progressBlock: nil, completionHandler: {
            (skippedResources, failedResources, completedResources) -> () in

            print("resources are prefetched: \(completedResources)")
            
            successCallback(batch)
        })
        prefetcher.start()
    }
    
    static func saveUser(facebookApiToken: String, errorCallback: ()-> Void, successCallback: (loggedUser: User)-> Void) {
        
        let headers = [
           "x-voter-client-id": "asd123",
           "x-voter-version":   "1",
           "x-voter-installation": "asd123"
        ]
        
        let params = [
            "token": facebookApiToken
        ]
        
        Alamofire.request(
            .POST,
            App.URLs.saveUser,
            parameters: params,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    
                    print("user saved, json response:  \(json)")
                    
                    let user = User(
                        userName: json["data"]["name"].stringValue,
                        userId: json["data"]["id"].stringValue,
                        profileImageUrl: json["data"]["profile_img"].stringValue,
                        facebookId: json["data"]["facebook_id"].stringValue,
                        profileImage: nil
                    )
                    
                    successCallback(loggedUser: user)
                    
                    break
                case .Failure(_):
                    errorCallback()
                }
            }
    }

    static func saveQuestion(imageUrls imageUrls:(String,String), images:(UIImage,UIImage), errorCallback: ()-> Void, successCallback: (question: Question)-> Void) {
        
        let headers = [
            "x-voter-client-id": "asd123",
            "x-voter-version":   "1",
            "x-voter-installation": "asd123"
        ]
        
        let params: [String: AnyObject] = [
            "user_id": (UserStore.user?.userId)!,
            "app": 1,
            "option_a": imageUrls.0,
            "option_b": imageUrls.1
        ]
        
        print("question will be saved. params: \(params)")
        
        Alamofire.request(
            .POST,
            App.URLs.saveQuestion,
            parameters: params,
            headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)

                    print("question saved, option_a:  \(json["data"]["option_a"].stringValue)")
                    print("question saved, option_b:  \(json["data"]["option_b"].stringValue)")
                    
                    let statusCode = json["statusCode"].intValue

                    if statusCode == 200 {
                        let question = Question(
                            id: json["data"]["id"].stringValue,
                            optionA: json["data"]["option_a"].stringValue,
                            optionB: json["data"]["option_b"].stringValue,
                            optionACount: 0,
                            optionBCount: 0,
                            skipCount: 0
                        )
                        
                        question.imageLeft = images.0
                        question.imageRight = images.1
                        
                        successCallback(question: question)
                    }
                    else{
                        errorCallback()
                    }
                    
                    break
                case .Failure(_):
                    errorCallback()
                }
        }
    }

    
    
}