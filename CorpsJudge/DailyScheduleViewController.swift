//
//  DailyScheduleViewController.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/20/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class DailyScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, delegateTasks {

    
    @IBOutlet weak var tableSchedule: UITableView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblHousingLocation: UILabel!
    @IBOutlet weak var lblHousingAddress: UILabel!
    @IBOutlet weak var lblHousingCityStateZip: UILabel!
    @IBOutlet weak var btnShowDetails: UIButton!
    @IBOutlet weak var btnOpenInMaps: UIButton!
    @IBOutlet weak var btnAddTask: UIButton!
    @IBOutlet weak var btnDeleteSchedule: UIButton!
    
    var day: PCalendar?
    var housing: PStadium?
    var show: PShow?
    var viewLoading = Loading()
    var arrayOfTasks = [PDailySchedule]()
    var viewPickAStadium = PickAStadium()
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        let backBtn = UISingleton.sharedInstance.getBackButton()
        backBtn.addTarget(self, action: #selector(DailyScheduleViewController.goBack), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initUI()
        if day != nil {
            if day?.housing != nil {
                housing = day?.housing
            }
            if day?.show != nil {
                show = day?.show
            }
            self.edgesForExtendedLayout = UIRectEdge.None
            self.displayDay()
            self.displaySchedule()
        }
        
        // ONLY FOR ADMIN TO ADD HOUSING
//        if day?.housing == nil {
//            viewPickAStadium = NSBundle.mainBundle().loadNibNamed("PickAStadium", owner: self, options: nil).first as! PickAStadium
//            viewPickAStadium.showInParent(self.navigationController!, forShow: day!)
//        }
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func initUI() {
        
        if Server.sharedInstance.adminMode {
            self.btnAddTask.hidden = false
            self.btnDeleteSchedule.hidden = false
        } else {
            self.btnAddTask.hidden = true
            self.btnDeleteSchedule.hidden = true
        }
        
        self.tableSchedule.dataSource = self
        self.tableSchedule.delegate = self
        self.tableSchedule.tableFooterView = UIView()
        self.tableSchedule.allowsMultipleSelectionDuringEditing = false
        
        let disclosure1 = UITableViewCell()
        self.btnShowDetails.addSubview(disclosure1)
        disclosure1.frame = CGRectMake(25, 1, self.btnShowDetails.bounds.size.width, self.btnShowDetails.bounds.size.height)
        disclosure1.accessoryType = .DisclosureIndicator
        disclosure1.userInteractionEnabled = false
        let img1 = UIImageView(image: UIImage(named: "disclosure"))
        img1.frame = CGRectMake(0, 0, 20, 20)
        disclosure1.accessoryView = img1
        
        let disclosure2 = UITableViewCell()
        self.btnOpenInMaps.addSubview(disclosure2)
        disclosure2.frame = CGRectMake(25, 1, self.btnOpenInMaps.bounds.size.width, self.btnOpenInMaps.bounds.size.height)
        disclosure2.accessoryType = .DisclosureIndicator
        disclosure2.userInteractionEnabled = false
        let img2 = UIImageView(image: UIImage(named: "disclosure"))
        img2.frame = CGRectMake(0, 0, 20, 20)
        disclosure2.accessoryView = img2
    }
    
    func displayDay() {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE M/dd"
        lblCity.text = day!.city
        lblType.text = "\(formatter.stringFromDate(day!.date)) - \(day!.typeOfDay)"

        if housing != nil {
            lblHousingLocation.text = housing!.facility
            lblHousingAddress.text = housing!.address
            lblHousingCityStateZip.text = "\(housing!.city), \(housing!.state) \(housing!.zip)"
        } else {
            lblHousingLocation.text = "Housing will be posted soon"
            lblHousingAddress.text = ""
            lblHousingCityStateZip.text = ""
        }
        
        if show != nil {
            btnShowDetails.hidden = false
        } else {
            btnShowDetails.hidden = true
        }
        
    }
    
    func displaySchedule() {
        
        viewLoading = NSBundle.mainBundle().loadNibNamed("Loading", owner: self, options: nil).first as! Loading
        self.view.addSubview(viewLoading)
        viewLoading.center = self.view.center
        viewLoading.animate()
        
        self.tableSchedule.hidden = true
        
        arrayOfTasks = []
        
        let query = PFQuery(className: PDailySchedule.parseClassName())
        query.whereKey("calendarDay", equalTo: day!)
        query.orderByAscending("dateTime")
        query.findObjectsInBackgroundWithBlock { (objs: [PFObject]?, err: NSError?) in
            if err === nil {
                if objs?.count > 0 {
                    for obj in objs! {
                        if let obj = obj as? PDailySchedule {
                            self.arrayOfTasks.append(obj)
                        }
                    }
                }
            self.reloadData()
            }
        }
    }
    
    func reloadData() {
        
        self.viewLoading.removeFromSuperview()
        self.tableSchedule.hidden = false
        self.tableSchedule.reloadData()
    }
    
    //MARK:-
    //MARK:UITableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTasks.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if arrayOfTasks.count > 0 {
            return "Schedule"
        } else {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if arrayOfTasks.count > 0 {
            return "Subject to change"
        } else {
            return "Schedule will be posted soon"
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.darkGrayColor()
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFontOfSize(14)
        header.textLabel?.textColor = UIColor.lightGrayColor()
    }
    
    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.blackColor()
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFontOfSize(10)
        header.textLabel?.textColor = UIColor.lightGrayColor()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 20
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        
        let task = arrayOfTasks[indexPath.row]
        
        let formatter = NSDateFormatter()
        //formatter.dateFormat = "HH:mm"

        let zone = NSTimeZone(abbreviation: self.day!.timeZone)
        formatter.timeZone = zone
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        let outputString = formatter.stringFromDate(task.dateTime)
        
        cell.textLabel?.text = "  \(outputString)  \(task.task)"
        
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(12)
        
        if let text = task.note {
            cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(10)
            cell.detailTextLabel?.text = text
        }
        
        //print(self.day!.date)
        return cell

    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if Server.sharedInstance.adminMode {
            return true
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let task = arrayOfTasks[indexPath.row]
            task.deleteInBackgroundWithBlock({ (done: Bool, error: NSError?) in
                if done {
                    self.arrayOfTasks.removeAtIndex(indexPath.row)
                    self.tableSchedule.reloadData()
                }
            })
        }
    }
    
    @IBAction func btnAddTask(sender: UIButton) {
        if let taskView = NSBundle.mainBundle().loadNibNamed("CreateSchedule", owner: self, options: nil).first as? CreateSchedule {
            taskView.showInParent(self.navigationController!, forDay: self.day!)
            taskView.delegateTask = self
        }
    }
    
    func taskAdded() {
        self.displaySchedule()
    }
    
    @IBAction func btnDeleteSchedule(sender: UIButton) {
        
        let alert = UIAlertController(title: "Daily Schedule", message: "Delete this schedule?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action: UIAlertAction!) in
            //delete
            
            let query = PFQuery(className: PDailySchedule.parseClassName())
            query.whereKey("calendarDay", equalTo: self.day!)
            query.findObjectsInBackgroundWithBlock { (objs: [PFObject]?, err: NSError?) in
                if err === nil {
                    if objs?.count > 0 {
                        for obj in objs! {
                            obj.deleteInBackground()
                        }
                    }
                    self.reloadData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            //cancel
        }))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
}
