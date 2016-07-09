//
//  PStadium.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/8/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation

class PStadium: PFObject, PFSubclassing {


    @NSManaged var facility: String
    @NSManaged var name: String //of the stadium
    @NSManaged var address: String
    @NSManaged var city: String!
    @NSManaged var state: String!
    @NSManaged var zip: String!
    @NSManaged var coordinates: PFGeoPoint
    @NSManaged var arrayOfPhoneNumbers: [String : String]?
    @NSManaged var arrayOfEmailAddresses: [String : String]?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Stadiums"
    }
}
