//
//  PCorps.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/8/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation

class PCorps: PFObject, PFSubclassing {
    
    @NSManaged var logo: PFFile?
    @NSManaged var logoLight: PFFile?
    @NSManaged var active: Bool
    @NSManaged var from: String
    @NSManaged var about: String
    @NSManaged var corpsName: String
    @NSManaged var numberOfChamps: Int
    @NSManaged var champs: String
    @NSManaged var classification: String //TODO: Change parse 'class' to 'classification'
    @NSManaged var website: String
    @NSManaged var websiteDisplay: String
    @NSManaged var lastScore: String
    @NSManaged var lastScoreDate: NSDate
    @NSManaged var olderScore: String
    @NSManaged var lastBrass: String
    @NSManaged var lastColorguard: String
    @NSManaged var lastPercussion: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Corps"
    }
}
