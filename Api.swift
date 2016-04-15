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
        
        let urlsA = batch.map { NSURL(string: $0.optionA)! }
        let urls = urlsA + batch.map { NSURL(string: $0.optionB)! }
        
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
        
        Alamofire.request(.POST, App.URLs.saveUser, parameters: params, headers: headers)
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
        
        /*
        response
        {
        "data": {
        "id": "c94642f0-fd0f-11e5-9a28-a3a2789bd42e",
        "created_at": "2016-04-07T22:26:34.000Z",
        "updated_at": "2016-04-07T22:26:34.000Z",
        "is_deleted": false,
        "facebook_id": "10153036713185139",
        "name": "Eyüp Ferhat Güdücü",
        "profile_img": "https://scontent.xx.fbcdn.net/hprofile-xaf1/v/t1.0-1/p200x200/1901419_10152180825580139_1287991170_n.jpg?oh=14b30a3f828a6515157e9d6e5eda874e&oe=578986B9"
        },
        "statusCode": 200,
        "error": "string",
        "message": "success",
        "timestamp": 1460067996068
        }
        
        */
        
        
            }

    
}