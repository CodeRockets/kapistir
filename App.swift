//
//  App.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import AVFoundation
import Kingfisher
import Crashlytics

struct App {
    
    struct UI {
        static let batchSize = 10
        
        static var onboarded = false
        
        static var createOnboarded = false
        
        static let DEBUG = 0
        
        static let questionScrollDelay = UInt32(1300000)
        
        static let colorButtonFollow = UIColor(red: 176/255, green: 193/255, blue: 206/255, alpha: 1.0)
        
        static func showServerError(completion completionCallback: (()->Void)?) {
            let alert = UIAlertController(
                title: "Sunucu Hatası",
                message: "İnternete bağlanılamıyor. Lütfen internet bağlantınızı kontrol ederek tekrar deneyiniz.",
                preferredStyle: .Alert
            )
            
            alert.addAction(UIAlertAction(title: "Tamam", style: .Default, handler: { (action) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            App.UI.getTopMostViewController().presentViewController(alert, animated: true, completion: completionCallback)
        }
        
        static func noQuestionsLeftMessage() {
            let alert = UIAlertController(
                title: "Bu Kadar",
                message: "Bugünlük bu kadar. Elimizde şu anda başka kapıştır kalmadı. Sen ekleyebilirsin!",
                preferredStyle: .Alert
            )
            
            alert.addAction(UIAlertAction(title: "Peki", style: .Default, handler: { (action) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            App.UI.getTopMostViewController().presentViewController(alert, animated: true, completion: nil)
        }
        
        static func getTopMostViewController() -> UIViewController {
            var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
            
            while let presentedViewController = topController!.presentedViewController {
                topController = presentedViewController
            }
            return topController!
        }
    }
    
    struct Play {
        
        static var audioPlayer: AVAudioPlayer?
        
        static func Applause(){
            let soundFileUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("applause", ofType: "mp3")!)

            do{
                audioPlayer = try AVAudioPlayer(contentsOfURL: soundFileUrl)
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch {
                
            }
        }
        
        static func Stop() {
            audioPlayer?.stop()
        }
    }

    struct URLs {
        static var backendEndpoint: String!
        static var getQuestionsUrl = "question/fetch/1"
        static var uploadImage = "question/image"
        static var saveUser = "user"
        static var saveQuestion = "question"
        static var saveAnswer = "answer"
        static var getUserQuestions = "user/questions"
        
        static var followQuestion = "favorite"
        static var reportQuestion = "reportabuse"
        static var deleteQuestion = "question/delete"
        static var banUser = "user/block"
    }
    
    struct Keys {
        static var clientId: String!
        static var version: String!
        static var installation: String!
        
        static var requestHeaders: [String:String]!
    }
    
    struct Store {
        static func loadAppSettings() {
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
            App.URLs.getUserQuestions = backendEndpoint! + App.URLs.getUserQuestions
            App.URLs.followQuestion = backendEndpoint! + App.URLs.followQuestion
            App.URLs.reportQuestion = backendEndpoint! + App.URLs.reportQuestion
            App.URLs.deleteQuestion = backendEndpoint! + App.URLs.deleteQuestion
            App.URLs.banUser = backendEndpoint! + App.URLs.banUser
            
            App.Keys.requestHeaders = [
                "x-voter-client-id":     App.Keys.clientId,
                "x-voter-version":       App.Keys.version,
                "x-voter-installation":  UIDevice.currentDevice().identifierForVendor!.UUIDString
            ]
            
            App.Keys.installation = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
            App.UI.onboarded = true // NSUserDefaults.standardUserDefaults().valueForKey("onboarded") != nil
 
            App.UI.createOnboarded = NSUserDefaults.standardUserDefaults().valueForKey("createOnboarded") != nil
            
            print("createOnboarded \(UI.createOnboarded)")
            
            print("app setting loaded \(App.Keys.requestHeaders)")
            
             //let cache = KingfisherManager.sharedManager.cache
             //cache.maxMemoryCost = 600*400*10
        }
        
        static func saveUserOnboarded() {
            NSUserDefaults.standardUserDefaults().setValue("yes", forKey: "onboarded")
            App.UI.onboarded = true
            print("onboarded saved")
        }
        
        static func saveCreateOnboarded() {
            NSUserDefaults.standardUserDefaults().setValue("yes", forKey: "createOnboarded")
            App.UI.createOnboarded = true
            print("createOnboarded saved")
        }
    }
    
    struct Logging {
        static func Log(text: String) {
            CLSLogv(text + " %@", getVaList([UserStore.user?.facebookId ?? ""]))
        }
    }
}