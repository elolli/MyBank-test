//
//  TransactionViewController.swift
//  MyBank
//
//  Created by Elise Lawley on 2/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class TransactionViewController: UITableViewController, PFLogInViewControllerDelegate {
    
    @IBOutlet weak var transLabel: UILabel!
    
    var transactionsData:NSMutableArray = NSMutableArray()
    
    func loadData() {
        transactionsData.removeAllObjects()
        var currentUser = PFUser.currentUser()
        if (currentUser != nil) {
            var findTransactionData = PFQuery(className: "transactions")
            findTransactionData.cachePolicy = kPFCachePolicyNetworkElseCache
            let isInCache = findTransactionData.hasCachedResult()
            findTransactionData.clearCachedResult()
            findTransactionData.maxCacheAge = 60 * 60 * 24
            
            findTransactionData.whereKey("accountholder", equalTo: currentUser)
            findTransactionData.orderByDescending("createdAt")
            findTransactionData.findObjectsInBackgroundWithBlock{(objects:[AnyObject]!, error:NSError!)->Void in
                if error == nil {
                    for object in objects {
                        self.transactionsData.addObject(object)
                    }
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        var refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
        self.refreshControl = refresh
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        var cellIdentifier = "CELL"
        let account: PFObject = self.transactionsData.objectAtIndex(indexPath.row) as PFObject
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        var transdata: AnyObject! = account["trasaction"]
        var dateUpdated = account.updatedAt as NSDate
        var dateFormat = NSDateFormatter()
        
        dateFormat.dateFormat = "MM d, YYYY, hh:mm a"
        
        let str = NSString(format: "%.2f", transdata as Double)
        if let label = cell.textLabel {
            label.text = "$" + str + " " + NSString(format: "%@", dateFormat.stringFromDate(dateUpdated).capitalizedString)
        }

        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            transactionsData.objectAtIndex(indexPath.row).deleteInBackgroundWithTarget(nil, selector: nil)
            transactionsData.removeObjectAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
