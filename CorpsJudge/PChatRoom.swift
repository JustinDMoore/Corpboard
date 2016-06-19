//
//  PChatRoom.swift
//  CorpBoard
//
//  Created by Justin Moore on 6/16/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PChatRoom: PFObject, PFSubclassing {

    @NSManaged var name: String
    @NSManaged var numberOfMessages: Int
    @NSManaged var numberOfViews: Int
    @NSManaged var lastUserNickname: String
    @NSManaged var lastUserThumbnail: PFFile
    @NSManaged var createdByUserNickname: String
    @NSManaged var isPrivate: Bool
    @NSManaged var toUser: PUser?
    @NSManaged var lastMessage: String
    @NSManaged var createdByCounter: Int
    @NSManaged var toUserCounter: Int
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "ChatRooms"
    }
    
}
