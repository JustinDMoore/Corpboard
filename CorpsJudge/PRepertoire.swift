//
//  PRepertoire.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/14/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PRepertoire: PFObject, PFSubclassing {

    @NSManaged var placement: String!
    @NSManaged var corps: PCorps!
    @NSManaged var score: String!
    @NSManaged var corpsName: String!
    @NSManaged var repertoire: String!
    @NSManaged var classification: String!
    @NSManaged var showTitle: String?
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
        return "Repertoires"
    }
}
