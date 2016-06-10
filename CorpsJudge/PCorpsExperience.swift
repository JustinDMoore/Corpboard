//
//  PCorpsExperience.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/9/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PCorpsExperience: PFObject, PFSubclassing {

    @NSManaged var position: String
    @NSManaged var corps: PCorps
    @NSManaged var user: PUser
    @NSManaged var corpsName: String
    @NSManaged var year: Int
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "CorpsExperience"
    }
}
