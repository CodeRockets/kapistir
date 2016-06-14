//
//  MainTableViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainTableViewController: UITableViewController {
   
    var table_onboarded = App.UI.onboarded
    
    let ONBOARDING_PAGE_COUNT = 2
    
    var questions = [Question]()
    
    var currentQuestion: Question?
    
    var loadingNotification: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QuestionStore.registerUpdateCallback(questionsUpdated)
        QuestionStore.getBatch()
        
        if App.UI.onboarded {
            loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification!.mode = MBProgressHUDMode.Indeterminate
            loadingNotification!.opacity = 0.5
        }

        Publisher.subscibe("question.voted") { _ in
            
            // scroll to next question
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                
                usleep(App.UI.questionScrollDelay)
                
                print("will scroll to next question")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.scrollToRowAtIndexPath(
                        NSIndexPath(forRow: QuestionStore.currentQuestionIndex+1, inSection: 0),
                        atScrollPosition: .Top,
                        animated: true
                    )
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    func questionsUpdated(batch: [Question]) {
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        print("questions updated and received in tableViewController")
        
        self.questions = batch
        
        if App.UI.onboarded {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.UI.onboarded ? questions.count : ONBOARDING_PAGE_COUNT + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if !table_onboarded && indexPath.row < ONBOARDING_PAGE_COUNT {
            
            // create onboarding page
            
            let cell = tableView.dequeueReusableCellWithIdentifier("OnboardingCell", forIndexPath: indexPath) as! OnboardingTableViewCell
        
            cell.lblTitle.text = "Kapıştır'a Hoşgeldiniz!"
            cell.lblText.text = indexPath.row == 0 ? "Bu ilk sayfa" : "Bu diğer sayfa"
            
            return cell
        }
        else{
 
            // first time here
            if !App.UI.onboarded {
                Publisher.publish("user/didFinishOnboarding", data: nil)
                print("onboarding completed")
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.tableView.reloadData()
                }
            }
            
            var cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionTableViewCell
           
            cell.question = self.questions[indexPath.row]
        
            QuestionTableViewCell.configureTableCell(cell.question, cell: &cell)
        
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if !App.UI.onboarded {
            return
        }
        
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
