//
//  HousingDetailTableViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 7/9/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class HousingDetailTableViewController: UITableViewController {

    var housing: PStadium?
    var showLocation: PStadium?
    var show: PShow?
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print(housing)
//        print(showLocation)
//        print(show)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        if housing != nil && show == nil {
//            return 2
//        } else if housing != nil && show != nil {
//            return 4
//        } else if housing == nil && show == nil {
//            return 0
//        }
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0: //Housing
//            if housing != nil { return 3 }
//            else { return 0 }
//        case 1: //Housing Contact
//            if housing != nil {
//                let emailCount = housing?.arrayOfEmailAddresses?.count ?? 0
//                let phoneCount = housing?.arrayOfPhoneNumbers?.count ?? 0
//                return emailCount + phoneCount
//            } else {
//                return 0
//            }
//        case 2: //Show
//            if show != nil { return 3 }
//            else { return 0 }
//        case 3: //Show Contact
//            if show != nil {
//                let emailCount = show?.stadium?.arrayOfEmailAddresses?.count ?? 0
//                let phoneCount = show?.stadium?.arrayOfPhoneNumbers?.count ?? 0
//                return emailCount + phoneCount
//            } else {
//                return 0
//            }
//        default:
//            return 0
//        }
//    }
//
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        switch indexPath.row {
//        case 0: //stadium
//            return stadiumCell(tableView, indexPath: indexPath)
//        case 1: //rating
//            return ratingCell(tableView, indexPath: indexPath)
//        case 2: //notes
//            return notesCell(tableView, indexPath: indexPath)
//        case 3: //contact
//            return contactCell(tableView, indexPath: indexPath)
//        default:
//            return UITableViewCell()
//        }
//    }
// 
//    func stadiumCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
//        
//    }
//    
//    func ratingCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
//        
//    }
//
//    func notesCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
//        
//    }
//    
//    func contactCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
//        
//    }
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
