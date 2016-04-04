//
//  QuestionStore.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation

struct QuestionStore{

    typealias Batch = [Question]
    
    typealias Callback = (Batch)-> Void
    
    private static var _questions = [Question]()
    
    private static var _callbacks = [Callback]()
    
    static func registerUpdateCallback(block: Callback) {
        self._callbacks.append(block)
    }
    
    private static func publishUpdate(){
        for block in self._callbacks {
            block(self._questions)
        }
    }
    
    static func getBatch() {
        // sorular indirilecek
        
        Api.getBatch({ () -> Void in
            // error
            },
            successCallback:  {(questions) -> Void in
                self._questions = questions
                self.publishUpdate()
            })
    }

    
}