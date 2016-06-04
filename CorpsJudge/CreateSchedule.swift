//
//  CreateSchedule.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/21/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

protocol delegateTasks: class {
    func taskAdded()
}

class CreateSchedule: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableTasks: UITableView!
    @IBOutlet weak var lblTimeZone: UILabel!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var switchAfterMidnight: UISwitch!
    @IBOutlet weak var txtCustomTask: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtCustomTaskPresent: UITextField!
    var calendarDay = PCalendar()
    var arrayOfTasks = [Task]()
    var selectedTask: Task?
    
    weak var delegateTask: delegateTasks?
    
    let format = "MM-dd-yyyy HH:mm"
    
    @IBAction func btnAdd(sender: AnyObject) {
        //add first
        if selectedTask != nil {
            if txtTime.text?.characters.count > 0 {
                let newTask = PDailySchedule()
                newTask.calendarDay = self.calendarDay
                newTask.task = selectedTask!.task
                newTask.taskPresent = selectedTask!.taskPresent
                
                //divide the 4 digit time up between hour and minutes
                
                let str = self.txtTime.text!
                let index1 = str.startIndex.advancedBy(2)
                let hours = Int(str.substringToIndex(index1))!
                
                let index2 = str.startIndex.advancedBy(2)
                let minutes = Int(str.substringFromIndex(index2))!
                
                var day = self.calendarDay.date.day()
                if switchAfterMidnight.on {
                    day += 1
                }
                
                let stra = "\(self.calendarDay.date.year())-\(self.calendarDay.date.month())-\(day) \(hours):\(minutes):00"
                newTask.rawDateTime = stra
                //print("Starting string: \(stra)")
                
                let gmtDf: NSDateFormatter = NSDateFormatter()
                gmtDf.timeZone = NSTimeZone(name: "GMT")
                gmtDf.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let gmtDate: NSDate = gmtDf.dateFromString(stra)!
                //print("GMT: \(gmtDate)")
                
                let estDf: NSDateFormatter = NSDateFormatter()
                estDf.timeZone = NSTimeZone(abbreviation: self.calendarDay.timeZone)
                estDf.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let estDate: NSDate = estDf.dateFromString(gmtDf.stringFromDate(gmtDate))!
                //print("EST: \(estDate)")
                
                newTask.dateTime = estDate
                
                if self.txtNote.text?.characters.count > 0 {
                    newTask.note = self.txtNote.text
                }
                
                newTask.saveInBackground()
            }
            
            //rawdatetime - raw date and time of time zone for calendarDay
            //datetime - convert date/time from time zone to UTC
            
        } else {
            if self.tableTasks.hidden {
                if self.txtCustomTask.text?.characters.count > 0 && self.txtCustomTaskPresent.text?.characters.count > 0 {
                    let newTask = PDailySchedule()
                    newTask.calendarDay = self.calendarDay

                    newTask.task = self.txtCustomTask.text!
                    newTask.taskPresent = self.txtCustomTaskPresent.text!
                    
                    //divide the 4 digit time up between hour and minutes
                    
                    let str = self.txtTime.text!
                    let index1 = str.startIndex.advancedBy(2)
                    let hours = Int(str.substringToIndex(index1))!
                    
                    let index2 = str.startIndex.advancedBy(2)
                    let minutes = Int(str.substringFromIndex(index2))!
                    
                    var day = self.calendarDay.date.day()
                    if switchAfterMidnight.on {
                        day += 1
                    }
                    
                    let stra = "\(self.calendarDay.date.year())-\(self.calendarDay.date.month())-\(day) \(hours):\(minutes):00"
                    newTask.rawDateTime = stra
                    //print("Starting string: \(stra)")
                    
                    let gmtDf: NSDateFormatter = NSDateFormatter()
                    gmtDf.timeZone = NSTimeZone(name: "GMT")
                    gmtDf.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let gmtDate: NSDate = gmtDf.dateFromString(stra)!
                    //print("GMT: \(gmtDate)")
                    
                    let estDf: NSDateFormatter = NSDateFormatter()
                    estDf.timeZone = NSTimeZone(abbreviation: self.calendarDay.timeZone)
                    estDf.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let estDate: NSDate = estDf.dateFromString(gmtDf.stringFromDate(gmtDate))!
                    //print("EST: \(estDate)")
                    
                    newTask.dateTime = estDate
                    
                    if self.txtNote.text?.characters.count > 0 {
                        newTask.note = self.txtNote.text
                    }
                    
                    newTask.saveInBackground()
                }
            }
        }
        
        
        self.switchAfterMidnight.on = false
        self.tableTasks.reloadData()
        self.txtTime.text = ""
        self.txtNote.text = ""
        self.txtCustomTaskPresent.text = ""
        self.txtCustomTask.text = ""
        self.txtCustomTask.hidden = true
        self.txtCustomTaskPresent.hidden = true
        self.tableTasks.hidden = false
        self.delegateTask?.taskAdded()
    }
    
    @IBAction func btnCancel(sender: AnyObject) {
        self.removeFromSuperview()
    }
 
    func showInParent(parent: UINavigationController, forDay: PCalendar) {
        parent.view.addSubview(self)
        self.center = parent.view.center
        self.tableTasks.dataSource = self
        self.tableTasks.delegate = self
        self.calendarDay = forDay
        self.lblTimeZone.text = "Time Zone: \(self.calendarDay.timeZone)"
        self.loadDict()
        self.tableTasks.reloadData()
    }
    
    func loadDict() {
        createTask("Wake Up", present: "are waking up and having breakfast.")
        createTask("The Day", present: "are having their morning meeting.")
        createTask("S & R", present: "are stretching and running.")
        createTask("Visual", present: "are having visual rehearsal.")
        createTask("Lunch", present: "are having lunch.")
        createTask("Sectionals", present: "are in sectionals.")
        createTask("Snack", present: "are having a snack.")
        createTask("Visual Ensemble", present: "are having visual ensemble rehearsal.")
        createTask("Set Up", present: "are setting up for ensemble rehearsal.")
        createTask("Ensemble", present: "are having full ensemble rehearsal.")
        createTask("Dinner", present: "are having dinner.")
        createTask("Hop Talk", present: "are having a discussion with Hopkins.")
        createTask("Sleep", present: "are sleeping.")
        createTask("Warm Up", present: "are warming up for the show.")
        createTask("Warm Up", present: "are warming up for ensemble rehearsal.")
        createTask("Perform", present: "are performing their show.")
    }
    
    func createTask(task: String, present: String) {
        let t = Task()
        t.task = task
        t.taskPresent = present
        arrayOfTasks.append(t)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfTasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        
        let task = self.arrayOfTasks[indexPath.row]
        cell.textLabel!.text = task.task
        cell.detailTextLabel!.text = task.taskPresent
        cell.textLabel?.font = UIFont.systemFontOfSize(10)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(8)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedTask = self.arrayOfTasks[indexPath.row]
    }

    @IBAction func btnCustom(sender: UIButton) {
        self.tableTasks.hidden = true
        self.txtCustomTask.hidden = false
        self.txtCustomTaskPresent.hidden = false
        self.selectedTask = nil
    }
}
