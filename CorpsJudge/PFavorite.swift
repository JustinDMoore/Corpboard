//
//  PFavorite.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/10/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit

class PFavorite: PFObject, PFSubclassing {

    @NSManaged var showName: String
    @NSManaged var corps: PCorps
    @NSManaged var user: PUser
    @NSManaged var corpsName: String
    @NSManaged var classification: String
    @NSManaged var show: PShow
    @NSManaged var category: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Favorites"
    }
}
