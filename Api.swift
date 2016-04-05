//
//  Api.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import Kingfisher

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

    
}