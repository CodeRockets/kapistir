//
//  UserListTableViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 17/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import Kingfisher

class UserListTableViewController: UITableViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserListTableCell", forIndexPath: indexPath) as! UserListTableViewCell

        // Configure the cell...
        let user = self.users[indexPath.row];
        cell.imgProfile.kf_setImageWithURL(NSURL(string: user.profileImageUrl)!, placeholderImage: nil)
        cell.lblUserName.text = user.userName
        
        return cell
    }
}
