//
//  UserQuestionsTableViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 22/04/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import MBProgressHUD

class UserQuestionsTableViewController: UITableViewController {

    var userQuestions = [Question]()
    
    var loadingNotification: MBProgressHUD?
    
    var type = "user" // user | followed
    
    var feedLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadFeed() {
        
        if !self.feedLoaded {
            loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification!.mode = MBProgressHUDMode.Indeterminate
            loadingNotification!.opacity = 0.5
        }
        
        Api.getUserQuestions(UserStore.user!,
            errorCallback: {
                print("getUserQuestions error")
            },
            successCallback: { (questions: [Question], followed: [Question]) in
            
                
                if self.type == "user" {
                    print("got user questions \(questions.count)")
                    
                    self.userQuestions = questions
                    
                    Publisher.publish("user/userQuestionsLoaded", data: questions.count)
                }
                
                if self.type == "followed" {
                    
                    print("got followed questions \(followed.count)")
                    
                    self.userQuestions = followed
                    
                    Publisher.publish("user/followedQuestionsLoaded", data: followed.count)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.tableView.reloadData()
                    self.feedLoaded = true
                }
            })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userQuestions.count
    }

    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! UserQuestionTableViewCell).imgLeft.kf_cancelDownloadTask()
        (cell as! UserQuestionTableViewCell).imgRight.kf_cancelDownloadTask()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UserQuestionTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("userQuestionCell", forIndexPath: indexPath) as! UserQuestionTableViewCell

        let question = self.userQuestions[indexPath.row]
        
        UserQuestionTableViewCell.configureTableCell(question, cell: &cell)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            print("delete row \(indexPath.row)")
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        let unsubscribeTitle = (self.type == "user") ? "Sil" : "Takibi Bırak"
        let question = self.userQuestions[indexPath.row]
        
        let btnUnsubscribe = UITableViewRowAction(style: .Normal, title: unsubscribeTitle) { action, index in
            if self.type == "followed" {
                Api.updateFollowQuestion(question,
                errorCallback: {
                    //
                },
                successCallback: {
                    print("takip bırakıldı")
                })
            }
            
            if self.type == "user" {
                // delete user-created kapıştır
            }
            
            self.userQuestions.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
        btnUnsubscribe.backgroundColor = UIColor.redColor()
        
        return [btnUnsubscribe]
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.reloadData()
    }
}
