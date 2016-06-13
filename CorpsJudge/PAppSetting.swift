//
//  PAppSetting.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/8/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation

class PAppSetting: PFObject, PFSubclassing {
    
    @NSManaged var photos: Int
    @NSManaged var iOS7AppStoreLink: String
    @NSManaged var feedback: Int
    @NSManaged var DCI_news: String
    @NSManaged var storeOpen: Bool
    @NSManaged var problems: Int
    @NSManaged var releasedVersion: String
    @NSManaged var allowPredictions: Bool
    @NSManaged var usersReported: Int
    @NSManaged var arrayOfCorpsExperiencePositions: [String]
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "AppSettings"
    }
}
