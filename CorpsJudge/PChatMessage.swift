//
//  PChatMessage.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/16/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PChatMessage: PFObject, PFSubclassing {

    @NSManaged var author: PUser
    @NSManaged var authorName: String
    @NSManaged var authorId: String
    @NSManaged var message: String?
    @NSManaged var room: String
    @NSManaged var roomName: String
    @NSManaged var file: PFFile?
    @NSManaged var messageType: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Messages"
    }
}
