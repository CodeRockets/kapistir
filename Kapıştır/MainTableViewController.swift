//
//  MainTableViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    var onboarded = true
    
    var questions = [Question]()
    
    var currentQuestion: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QuestionStore.registerUpdateCallback(questionsUpdated)
        QuestionStore.getBatch()
    }

    func questionsUpdated(batch: [Question]) {
        print("questions updated and received in tableViewController")
        
        self.questions = batch
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*if !onboarded && indexPath.row < 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OnboardingCell", forIndexPath: indexPath) as! OnboardingTableViewCell
        
            // Configure the cell...
        
            cell.lblTitle.text = "Kapıştır'a Hoşgeldiniz!"
            cell.lblText.text = indexPath.row == 0 ? "Bu ilk sayfa" : "Bu diğer sayfa"
        
            return cell
        }
        else{*/
        
            var cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionTableViewCell
           
            cell.question = self.questions[indexPath.row]
        
            QuestionTableViewCell.configureTableCell(cell.question, cell: &cell)
        
            return cell
        //}
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //QuestionStore.currentQuestionIndex = indexPath.row
        print("current question index \(indexPath.row)")
        
        if let _ = self.currentQuestion?.answer {
            
        } else{
            
            if let currentQuestion = self.currentQuestion {
                Api.saveAnswer(currentQuestion, answer: .Skip, errorCallback: {}, successCallback: {})
            }
            
        }
        
        self.currentQuestion = self.questions[indexPath.row]
        QuestionStore.setCurrentQuestion(self.currentQuestion!)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    /*
    var lastOffset = CGFloat(0)
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrolled")
        let currentOffset = scrollView.contentOffset.y
    
        let scrollDirection = (lastOffset - currentOffset)
    }*/
    
}
