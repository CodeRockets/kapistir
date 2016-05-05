//
//  App.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation

struct App {
    
    struct UI {
        static let batchSize = 10
        
        static func showServerError(completion completionCallback: (()->Void)?) {
            let alert = UIAlertController(
                title: "Sunucu Hatası",
                message: "İnternete bağlanılamıyor. Lütfen internet bağlantınızı kontrol ederek tekrar deneyiniz.",
                preferredStyle: .Alert
            )
            
            App.UI.getTopMostViewController().presentViewController(alert, animated: true, completion: completionCallback)
        }
        
        private static func getTopMostViewController() -> UIViewController {
            var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
            
            while let presentedViewController = topController!.presentedViewController {
                topController = presentedViewController
            }
            return topController!
        }
    }

    struct URLs {
        static var backendEndpoint: String!
        static var getQuestionsUrl = "question/fetch/1"
        static var uploadImage = "question/image"
        static var saveUser = "user"
        static var saveQuestion = "question"
        static var saveAnswer = "answer"
    }
    
    struct Keys {
        static var clientId: String!
        static var version: String!
        static var installation: String!
        
        static var requestHeaders: [String:String]!
    }
    
    struct Load {
        static func settings() {
            let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            
            let clientId = dict!.valueForKey("clientId") as? String
            let version = dict!.valueForKey("version") as? String
            let installation = dict!.valueForKey("installation") as? String
            let backendEndpoint = dict!.valueForKey("backendEndpoint") as? String
            
            App.Keys.clientId = clientId!
            App.Keys.installation = installation!
            App.Keys.version = version!
            App.URLs.getQuestionsUrl = backendEndpoint! + App.URLs.getQuestionsUrl
            App.URLs.uploadImage = backendEndpoint! + App.URLs.uploadImage
            App.URLs.saveUser = backendEndpoint! + App.URLs.saveUser
            App.URLs.saveQuestion = backendEndpoint! + App.URLs.saveQuestion
            App.URLs.saveAnswer = backendEndpoint! + App.URLs.saveAnswer
            
            App.Keys.requestHeaders = [
                "x-voter-client-id":     App.Keys.clientId,
                "x-voter-version":       App.Keys.version,
                "x-voter-installation":  UIDevice.currentDevice().identifierForVendor!.UUIDString
            ]
        
            print("app setting loaded \(App.Keys.requestHeaders)")
        }
    }
}