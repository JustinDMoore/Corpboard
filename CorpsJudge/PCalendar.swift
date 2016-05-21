//
//  PCalendar.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/20/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PCalendar: PFObject, PFSubclassing {

    @NSManaged var housingSite: String
    @NSManaged var city: String
    @NSManaged var typeOfDay: String
    @NSManaged var date: NSDate
    @NSManaged var housingAddress: String
    @NSManaged var zip: Int
    @NSManaged var timeZone: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Calendar"
    }
    
}
