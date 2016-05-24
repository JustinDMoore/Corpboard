//
//  POrder.swift
//  CorpBoard
//
//  Created by Peggy Moore on 5/24/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class POrder: PFObject, PFSubclassing {

    @NSManaged var size: String?
    @NSManaged var color: String?
    @NSManaged var quantity: Int
    @NSManaged var user: PFUser
    @NSManaged var status: String
    @NSManaged var item: PStoreItem
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Order"
    }
    
}
