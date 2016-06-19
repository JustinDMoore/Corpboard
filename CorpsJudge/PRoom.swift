//
//  PRoom.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/18/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

struct NotificationKeys {
    static let SignedIn = "onSignInCompleted"
}

class PRoom: PFObject, PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var authorName: String
    @NSManaged var authorId: String
    @NSManaged var isPrivate: Bool
    @NSManaged var author: PUser
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Rooms"
    }
}
