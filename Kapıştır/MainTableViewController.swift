//
//  MainTableViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 13/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
   
    var table_onboarded = true // App.UI.onboarded
    
    let ONBOARDING_PAGE_COUNT = 2
    
    var questions = [Question]()
    
    var currentQuestion: Question?
    
    var loadingNotification: MBProgressHUD?
    
    var reloadingTable = false
    
    let onboardingTitles = [
        "Kapıştır'a hoşgeldiniz!",
        "Hemen başlıyoruz!"
    ]
    
    let onboardingTexts = [
        "Herhangi ikişeyi karşılaştırın, arkadaşlarınız ile oylayın!",
        "+ ile siz de anında kapıştır oluşturabilirsiniz."
    ]
    
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
                
                if QuestionStore.hasNextQuestion {
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
        
        Publisher.subscibe("question/created", callback: scrollToCreatedQuestion)
        
        Publisher.subscibe("question/showFriendsList", callback: {
            msg in
            
            
            if let cell = msg as? QuestionTableViewCell {
            
                // left friends
                let friendsLeft = cell.question.friends?
                    .filter({ (friend) -> Bool in
                        return friend.userVotedOption == .Left
                    })
            
                print("friends left \(friendsLeft)")
            
                self.showFriendsList(friendsLeft!)
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func scrollToCreatedQuestion(payload: AnyObject?) {
        
        let questionIndex = QuestionStore.questionCount > 1 ?
            QuestionStore.currentQuestionIndex + 1 : 0
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.scrollToRowAtIndexPath(
                NSIndexPath(forRow: questionIndex, inSection: 0),
                atScrollPosition: .Top,
                animated: true
            )
        }
    }

    func questionsUpdated(batch: [Question]) {
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        print("questions updated and received in tableViewController")
        
        self.questions = batch
        
        if App.UI.onboarded {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                print("table reloaded")
                self.reloadingTable = true
                self.tableView.reloadData()
            }
        }
    }
    
    func showFriendsList(users: [User]) {
        let storyBoard = UIStoryboard(name: "UserList", bundle: nil)
        let userListViewControllerLeft = storyBoard.instantiateViewControllerWithIdentifier("UserListTableViewController") as! UserListTableViewController
        
        userListViewControllerLeft.users = users
        userListViewControllerLeft.modalPresentationStyle = .Popover
        userListViewControllerLeft.preferredContentSize = CGSizeMake((UIApplication.sharedApplication().keyWindow?.bounds.size.width)! / 2,
                                                                     (UIApplication.sharedApplication().keyWindow?.bounds.size.height)! / 4)
        
        let currentCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: QuestionStore.currentQuestionIndex, inSection: 0)) as! QuestionTableViewCell
        
        let popover = userListViewControllerLeft.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .Down
        popover.sourceView = currentCell.avatarViewLeft
        popover.sourceRect = currentCell.avatarViewLeft.bounds
        
        self.presentViewController(userListViewControllerLeft, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
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
        
            cell.lblTitle.text = self.onboardingTitles[indexPath.row]
            cell.lblText.text = self.onboardingTexts[indexPath.row]
            
            return cell
        }
        else{
 
            // first time here
            if !App.UI.onboarded {
                Publisher.publish("user/didFinishOnboarding", data: nil)
                print("onboarding completed")
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    print("table reloaded after onboarding")
                    self.tableView.reloadData()
                }
            }
            
            var cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath) as! QuestionTableViewCell
            
            let question = self.questions[indexPath.row]
            QuestionTableViewCell.configureTableCell(question, cell: &cell)
        
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if !App.UI.onboarded {
            return
        }
        
        if self.reloadingTable {
            self.reloadingTable = false
            return
        }
        
        //QuestionStore.currentQuestionIndex = indexPath.row
        print("current question index \(indexPath.row) \(self.currentQuestion?.answer)")
        
        
        if let currentQuestion = self.currentQuestion {
            
            if currentQuestion.answer == nil {
                Api.saveAnswer(currentQuestion, answer: .Skip, errorCallback: {}, successCallback: {})
            }
            else{
                print("cant save answered question")
            }
        }
        else{
            print("no current question")
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
