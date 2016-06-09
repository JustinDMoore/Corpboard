//
//  PVideo.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/9/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PVideo: PFObject, PFSubclassing {

    @NSManaged var url: String!
    @NSManaged var desc: String!
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Videos"
    }
}
