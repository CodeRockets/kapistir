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
        
        if self.type == "user" {
        
            Api.getUserQuestions(UserStore.user!,
                errorCallback: {
                // error
                print("getUserQuestions error")
                },
                successCallback: { questions in
                
                    print("got user questions \(questions.count)")
                
                    self.userQuestions = questions
                
                    Publisher.publish("user/userQuestionsLoaded", data: questions.count)
                
                    dispatch_async(dispatch_get_main_queue()) {
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.tableView.reloadData()
                        self.feedLoaded = true
                    }
            })
        }
        
        if self.type == "followed" {
            
            Publisher.publish("user/followedQuestionsLoaded", data: 0 /*questions.count*/)
            
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.tableView.reloadData()
                self.feedLoaded = true
            }
        }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
