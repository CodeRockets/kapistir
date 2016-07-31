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
    
    static var gettingBatch = false
    
    static func getBatch( errorCallback: ()-> Void, successCallback: ([Question])-> Void ) {
        
        if self.gettingBatch {
            print("currently getting a batch...")
            return
        }
        
        print("getting a batch...")
        
        self.gettingBatch = true
        
        var retQuestions = [Question]()
        
        let params: [String: AnyObject] = [
            "user_id": UserStore.user?.userId ?? "",
            "limit": 10,
            "debug": App.UI.DEBUG
        ]
        
        Alamofire.request(
            .GET,
            App.URLs.getQuestionsUrl,
            parameters: params,
            headers: App.Keys.requestHeaders)
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    
                    let json = JSON(data)
                    
                    let rows = json["data"]["rows"].arrayObject
                    
                    for questionData in rows! {
                        let question = Question.fromApiResponse(questionData as! NSDictionary)
                        retQuestions.append(question)
                    }
                        
                    fetchBatchImages(retQuestions, errorCallback: errorCallback, successCallback: successCallback)
                    
                    break
                case .Failure(_):
                    self.gettingBatch = false
                    App.UI.showServerError(completion: nil)
                    errorCallback()
                }
            }
    }
    
    static func fetchBatchImages(batch: [Question], errorCallback: ()->Void, successCallback: ([Question])-> Void) {
        
        let urlsA = batch.map { NSURL(string: $0.optionA)! }
        let urls = urlsA + batch.map { NSURL(string: $0.optionB)! }
        
        print(urls)
        
        let prefetcher = ImagePrefetcher(urls: urls, optionsInfo: nil, progressBlock: nil, completionHandler: {
            (skippedResources, failedResources, completedResources) -> () in

            print("resources are prefetched")
            
            self.gettingBatch = false
            
            successCallback(batch)
            
            //let cache = KingfisherManager.sharedManager.cache
            //cache.clearMemoryCache()
            
        })
        
        prefetcher.start()
    }
    
    static func saveUser(facebookApiToken: String, errorCallback: ()-> Void, successCallback: (loggedUser: User)-> Void) {
        
        let params = [
            "token": facebookApiToken
        ]
        
        Alamofire.request(
            .POST,
            App.URLs.saveUser,
            parameters: params,
            headers: App.Keys.requestHeaders)
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    
                    let user = User(
                        userName: json["data"]["name"].stringValue,
                        userId: json["data"]["id"].stringValue,
                        profileImageUrl: json["data"]["profile_img"].stringValue,
                        facebookId: json["data"]["facebook_id"].stringValue,
                        profileImage: nil,
                        questions: [Question]()
                    )
                    
                    successCallback(loggedUser: user)
                    
                    break
                case .Failure(_):
                    App.UI.showServerError(completion: nil)
                    errorCallback()
                }
            }
    }
    
    static func saveAnswer(question: Question, answer: Answer, errorCallback: ()-> Void, successCallback: ()-> Void) {
        
        let params: [String: AnyObject] = [
            "user_id":      UserStore.user?.userId ?? "",
            "option":       answer.rawValue,
            "question_id":  question.id,
            "client_id":    1,
            "text":         "0"
        ]
        
        Alamofire.request(
            .POST,
            App.URLs.saveAnswer,
            parameters: params,
            headers: App.Keys.requestHeaders)
            .responseJSON { response in
                
                print("answer response \(response.result)")
                
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    
                    print("answer saved \(question.id) \(answer.rawValue)")
                    
                    successCallback()
                    
                    break
                    
                case .Failure(let data):
                    print("answer save error \(data)")
                    
                    App.UI.showServerError(completion: nil)
                    errorCallback()
                }
        }
    }

    /**
        Save the question
        - parameter imageUrls: *String* tuple of images to be saved
        - parameter images: *UIImage* tuple of the images
        - parameter errorCallback: block for error
        - parameter successCallback: block for success
     */
    static func saveQuestion(imageUrls imageUrls:(String,String), images:(UIImage,UIImage), errorCallback: ()-> Void, successCallback: (question: Question)-> Void) {
        
        let params: [String: AnyObject] = [
            "user_id":  (UserStore.user?.userId)!,
            "app":      1,
            "option_a": imageUrls.0,
            "option_b": imageUrls.1
        ]
        
        print("question will be saved. params: \(params)")
        
        Alamofire.request(
            .POST,
            App.URLs.saveQuestion,
            parameters: params,
            headers: App.Keys.requestHeaders)
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
                            skipCount: 0,
                            askerName: UserStore.user!.userName,
                            askerProfileImage: UserStore.user!.profileImageUrl
                        )
                        
                        // question.imageLeft = images.0
                        // question.imageRight = images.1
                        
                        successCallback(question: question)
                    }
                    else{
                        App.UI.showServerError(completion: nil)
                        errorCallback()
                    }
                    
                    break
                case .Failure(_):
                    App.UI.showServerError(completion: nil)
                    errorCallback()
                }
        }
    }
    
    static func getUserQuestions(user: User, errorCallback: ()-> Void, successCallback: (questions:[Question], followed: [Question])->Void) {
        
        //GET /v1/user/questions
        
        
        //Api.getBatch(errorCallback, successCallback: successCallback)
        
        var retQuestions = [Question]()
        var retFollowed = [Question]()
        
        let params: [String: AnyObject] = [
            "app": 1,
            "user_id": UserStore.user?.userId ?? "",
            "limit": 100
        ]
        
        print("fetch params: \(params)")
        
        Alamofire.request(
            .GET,
            App.URLs.getUserQuestions,
            parameters: params,
            headers: App.Keys.requestHeaders)
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    
                    print("\(json)")
                    
                    let rows = json["data"]["questions"]["rows"].arrayObject
                    
                    for questionData in rows! {
                        let question = Question.fromApiResponse(questionData as! NSDictionary)
                        retQuestions.append(question)
                    }
                    
                    let followedQuestionsArray = json["data"]["favorites"]["rows"].arrayObject
                    
                    for questionData in followedQuestionsArray! {
                        let question = Question.fromApiResponse(questionData as! NSDictionary)
                        retFollowed.append(question)
                    }
                    
                    successCallback(questions: retQuestions, followed: retFollowed)
                    
                    // fetchBatchImages(retQuestions, errorCallback: errorCallback, successCallback: { _ in})
                    
                    break
                case .Failure(_):
                    App.UI.showServerError(completion: nil)
                    errorCallback()
                }
        }

    }
    
    static func updateFollowQuestion(question: Question, errorCallback: ()-> Void, successCallback: ()->Void) {
        
        let params: [String: AnyObject] = [
            "user_id": UserStore.user?.userId ?? "",
            "question_id": question.id,
            "client_id": 1,
            "unfavorite": question.isFollowed ? "false" : "true"
        ]
        
        print("follow params: \(params)")
        
        Alamofire.request(
            .POST,
            App.URLs.followQuestion,
            parameters: params,
            headers: App.Keys.requestHeaders)
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    
                    print("follow question success \(json)")
                    
                    successCallback()
                    
                    break
                case .Failure(_):
                    App.UI.showServerError(completion: nil)
                    errorCallback()
                }
        }
    }
    
    
    static func reportQuestion(question: Question, errorCallback: ()-> Void, successCallback: ()->Void) {
        
        let params: [String: AnyObject] = [
            "user_id": UserStore.user?.userId ?? "",
            "question_id": question.id,
            "client_id" : 1
        ]
        
        print("fetch params: \(params)")
        
        Alamofire.request(
            .POST,
            App.URLs.reportQuestion,
            parameters: params,
            headers: App.Keys.requestHeaders)
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    
                    print("report question success \(json)")
                    
                    successCallback()
                    
                    break
                case .Failure(_):
                    App.UI.showServerError(completion: nil)
                    errorCallback()
                }
        }
    }

}