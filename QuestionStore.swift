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
    
    private static var currentQuestion: Question?
    
    private static var _questions = [Question]()
    
    private static var _callbacks = [Callback]()
    
    private static func publishUpdate(){
        for block in self._callbacks {
            block(self._questions)
        }
    }
    
    static func registerUpdateCallback(block: Callback) {
        self._callbacks.append(block)
    }
    
    static func getBatch() {
        // sorular indirilecek
        
        Api.getBatch({ () -> Void in
            // error
            },
            successCallback:  {(questions) -> Void in
                self._questions = self._questions + questions
                self.publishUpdate()
            })
    }
    
    static func setCurrentQuestion(question: Question) {
        self.currentQuestion = question
        
        let index = self._questions.indexOf { q -> Bool in
            return q.id == question.id
        }
        
        print("index \(index), question count: \(self._questions.count)")
        
        if self._questions.count - index! < 7 {
            print("get next batch")
            self.getBatch()
        }
    }
}