//
//  PUser.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/8/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation

class PUser: PFUser {

     var acceptedTermsString = "acceptedTerms"
     var facebookIdString = "facebookId"
     var emailVerifiedString = "emailVerified"
     var coverImageString = "coverImage" //from camera roll
     var isAdminString = "isAdmin"
     var profileViewsString = "profileViews"
     var coverPointerString = "coverPointer" //default/user submitted
     var predictionEnteredString = "predictionEntered"
     var arrayOfBadgesString = "arrayOfBadges"
     var thumbnailString = "thumbnail"
     var nicknameString = "nickname"
     var backgroundString = "background"
     var emailCopyString = "emailCopy"
     var geoString = "geo"
     var lastLoginString = "lastLogin"
     var last_nameString = "last_name"
     var locationString = "location"
     var fullnameString = "fullname"
     var first_nameString = "first_name"
     var numberOfUnreadMessagesString = "numberOfUnreadMessages"
     var fullname_lowerString = "fullname_lower"
    var pictureString = "picture"
    
    @NSManaged var acceptedTerms: Bool
    @NSManaged var facebookId: String?
    @NSManaged var emailVerified: String
    @NSManaged var coverImage: PFFile? //from camera roll
    @NSManaged var isAdmin: Bool
    @NSManaged var profileViews: Int
    @NSManaged var coverPointer: PPhoto? //for default/user submitted covers
    @NSManaged var predictionEntered: Bool
    @NSManaged var arrayOfBadges: [String]?
    @NSManaged var thumbnail: PFFile?
    @NSManaged var nickname: String
    @NSManaged var background: String?
    @NSManaged var acceptedTermsDate: NSDate
    @NSManaged var emailCopy: String
    @NSManaged var geo: PFGeoPoint
    @NSManaged var lastLogin: NSDate
    @NSManaged var last_name: String
    @NSManaged var location: String?
    @NSManaged var fullname: String
    @NSManaged var first_name: String
    @NSManaged var numberOfUnreadMessages: Int
    @NSManaged var fullname_lower: String
    @NSManaged var agreedToChatTerms: Bool
    @NSManaged var desc: String //May need to change name.. desc is a class func
    @NSManaged var picture: PFFile?
    @NSManaged var showReviews: Int
    @NSManaged var firebaseUID: String?
    @NSManaged var tutorialProfile: Bool
    @NSManaged var isStaff: Bool
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}
