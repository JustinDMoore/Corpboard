//
//  SchedulesViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/20/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class SchedulesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var arrayOfSchedules = [PCalendar]()
    var selectedSchedule: PCalendar?
    var viewLoading = Loading()
    
    @IBOutlet weak var tableSchedules: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(SchedulesViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
        
        if let indexPath = tableSchedules.indexPathForSelectedRow {
            tableSchedules.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        viewLoading = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil).first as! Loading
        self.view.addSubview(viewLoading)
        viewLoading.center = self.view.center
        viewLoading.animate()
        
        self.tableSchedules.delegate = self
        self.tableSchedules.dataSource = self
        self.tableSchedules.estimatedRowHeight = 44
        self.tableSchedules.tableFooterView = UIView()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.getSchedules()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getSchedules() {
        self.arrayOfSchedules = []
        let query = PFQuery(className: PCalendar.parseClassName())
        query.includeKey("show")
        query.includeKey("housing")
        query.orderByAscending("date")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                if objects?.count > 0 {
                    for obj in objects! {
                        let schedule = obj as! PCalendar
                        self.arrayOfSchedules.append(schedule)
                    }
                    self.reload()
                } else {
                    
                }
            } else {
                
            }
        }
    }

    func reload() {
        self.viewLoading.removeFromSuperview()
        self.tableSchedules.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "schedule" {
            if let vc = segue.destinationViewController as? DailyScheduleViewController {
                if selectedSchedule != nil {
                    vc.day = selectedSchedule
                }
            }
        }
    }

    //MARK:-
    //MARK:UITableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfSchedules.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("schedule") as! ScheduleTableViewCell
        
        let lblLocation = cell.viewWithTag(1) as? UILabel
        let lblDate = cell.viewWithTag(2) as? UILabel
        let lblType = cell.viewWithTag(3) as? UILabel
        
        let schedule = self.arrayOfSchedules[indexPath.row]
        
        lblLocation?.text = schedule.city
        lblType?.text = schedule.typeOfDay
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE M/dd"
        lblDate?.text = formatter.stringFromDate(schedule.date)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSchedule = arrayOfSchedules[indexPath.row]
        self.performSegueWithIdentifier("schedule", sender: self)
    }
    
}
