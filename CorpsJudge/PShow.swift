//
//  PShow.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/8/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation

class PShow: PFObject, PFSubclassing {
    
    @NSManaged var showName: String
    @NSManaged var recapOpen: String
    @NSManaged var showDate: NSDate
    @NSManaged var exception: String
    @NSManaged var showLocation: String
    @NSManaged var recapWorld: String
    @NSManaged var arrayOfCorps: [String]
    @NSManaged var isShowOver: Bool
    @NSManaged var recapAllAge: String
    @NSManaged var stadium: PStadium?
    @NSManaged var coordinates: PFGeoPoint?

    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Shows"
    }
}
