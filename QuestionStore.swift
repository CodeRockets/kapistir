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
    
    static var currentQuestionIndex = 0
    
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
    
    
    static var hasNextQuestion: Bool {
        return _questions.count > currentQuestionIndex+1
    }
    
    static func getBatch() {
        // sorular indirilecek
        
        Api.getBatch({ () -> Void in
            // error
            
            },
            successCallback:  {(questions) -> Void in
                
                print("\(questions.count) questions fetched")
                
                let questionsWillAdd = questions.filter({ q -> Bool in
                    
                    return self._questions.indexOf({ question -> Bool in
                        return question.id == q.id
                    }) == nil
                    
                })

                self._questions = self._questions + questionsWillAdd
                
                print("\(questionsWillAdd.count) questions added")
                
                self.publishUpdate()
            })
    }
    
    static func setCurrentQuestion(question: Question) {
        self.currentQuestion = question
        
        self.currentQuestionIndex = self._questions.indexOf { q -> Bool in
            return q.id == question.id
        }!
        
        print("index \(self.currentQuestionIndex), question count: \(self._questions.count)")
        
        if self._questions.count - self.currentQuestionIndex < 7 && self._questions.count > 7 {
            print("get next batch")
            self.getBatch()
        }
    }
    
    static func insertCurrentQuestion(question: Question){
        self._questions.insert(question, atIndex: self.currentQuestionIndex+1)
        self.publishUpdate()
    }
}