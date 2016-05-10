//
//  PUser.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/8/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation

class PUser: PFObject, PFSubclassing {

    @NSManaged var acceptedTerms: Bool
    @NSManaged var facebookId: String
    @NSManaged var emailVerified: String
    @NSManaged var coverImage: PFFile
    @NSManaged var isAdmin: Bool
    @NSManaged var profileViews: Int
    @NSManaged var coverPointer: PPhoto
    @NSManaged var predictionEntered: Bool
    @NSManaged var arrayOfCategories: [String]?
    @NSManaged var thumbnail: PFFile
    @NSManaged var nickname: String
    @NSManaged var background: String
    @NSManaged var acceptedTermsDate: NSDate
    @NSManaged var emailCopy: String
    @NSManaged var geo: PFGeoPoint
    @NSManaged var lastLogin: NSDate
    @NSManaged var last_name: String
    @NSManaged var location: String
    @NSManaged var username: String
    @NSManaged var fullname: String
    @NSManaged var first_name: String
    @NSManaged var numberOfUnreadMessages: Int
    @NSManaged var password: String
    @NSManaged var fullname_lower: String
    @NSManaged var agreedToChatTerms: Bool
    @NSManaged var email: String
    @NSManaged var desc: String //May need to change name.. desc is a class func
    @NSManaged var picture: PFFile
    @NSManaged var showReviews: Int
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "User"
    }
}
