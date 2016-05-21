//
//  PDailySchedule.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/20/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PDailySchedule: PFObject, PFSubclassing {

    @NSManaged var calendarDay: PCalendar
    @NSManaged var rawDateTime: String
    @NSManaged var task: String
    @NSManaged var taskPresent: String
    var localDeviceDateTime = NSDate() //as GMT/UTC
    @NSManaged var dateTime: NSDate
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "DailySchedule"
    }
    
}
