//
//  PScore.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/11/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PScore: PFObject, PFSubclassing {
    
    @NSManaged var classification: String
    @NSManaged var corps: PCorps
    @NSManaged var showDate: NSDate
    @NSManaged var user: PUser
    @NSManaged var exception: String
    @NSManaged var colorguardScore: String
    @NSManaged var score: String
    @NSManaged var corpsName: String
    @NSManaged var isOfficial: Bool
    @NSManaged var percussionScore: String
    @NSManaged var hornlineScore: String
    @NSManaged var show: PShow
    @NSManaged var performanceTime: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Scores"
    }
}
