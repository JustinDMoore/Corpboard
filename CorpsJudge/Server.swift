//
//  Server.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/5/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation

protocol delegateInitialAppLoad: class {
    func updateProgress()
    func showAppMessage(title: String?, message: String?, canUseApp: Bool)
    func displayFact(factObject: PFact)
}


protocol delegateUserProfile: class {
    func updateUserMessages()
}

//TODO: Remove @objc
@objc class Server: NSObject, delegateNews {
    
    //MARK:-
    //MARK:SINGLETON DECLARATION
    static let sharedInstance = Server()
    
    //MARK:-
    //MARK:Chat Constants
    //let HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
    //let hex = UIColor(red: ((c>>24)&0xFF)/255.0, green: ((c>>16)&0xFF)/255.0, blue: ((c>>8)&0xFF)/255.0, alpha: ((c)&0xFF)/255.0)
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    let		PF_INSTALLATION_CLASS_NAME			= "_Installation"		//	Class name
    let		PF_INSTALLATION_OBJECTID			= "objectId"			//	String
    let		PF_INSTALLATION_USER				= "user"				//	Pointer to User Class
    
    let		PF_USER_CLASS_NAME					= "_User"				//	Class name
    let		PF_USER_OBJECTID					= "objectId"			//	String
    let		PF_USER_USERNAME					= "username"			//	String
    let		PF_USER_PASSWORD					= "password"			//	String
    let		PF_USER_EMAIL						= "email"				//	String
    let		PF_USER_EMAILCOPY					= "emailCopy"			//	String
    let		PF_USER_FULLNAME					= "fullname"			//	String
    let		PF_USER_FULLNAME_LOWER				= "fullname_lower"		//	String
    let		PF_USER_FACEBOOKID					= "facebookId"			//	String
    let		PF_USER_PICTURE						= "picture"				//	File
    let		PF_USER_THUMBNAIL					= "thumbnail"			//	File
    
    let		PF_CHAT_CLASS_NAME					= "Chat"				//	Class name
    let		PF_CHAT_USER						= "user"				//	Pointer to User Class
    let		PF_CHAT_ROOMID						= "roomId"				//	String
    let		PF_CHAT_TEXT						= "text"				//	String
    let		PF_CHAT_PICTURE						= "picture"				//	File
    let		PF_CHAT_CREATEDAT					= "createdAt"			//	Date
    
    let		PF_CHATROOMS_CLASS_NAME				= "ChatRooms"			//	Class name
    let		PF_CHATROOMS_NAME					= "name"				//	String
    
    let		PF_MESSAGES_CLASS_NAME				= "Messages"			//	Class name
    let		PF_MESSAGES_USER					= "user"				//	Pointer to User Class
    let		PF_MESSAGES_ROOMID					= "roomId"				//	String
    let		PF_MESSAGES_DESCRIPTION				= "description"			//	String
    let		PF_MESSAGES_LASTUSER				= "lastUser"			//	Pointer to User Class
    let		PF_MESSAGES_LASTMESSAGE				= "lastMessage"			//	String
    let		PF_MESSAGES_COUNTER					= "counter"				//	Number
    let		PF_MESSAGES_UPDATEDACTION			= "updatedAction"		//	Date
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    let		NOTIFICATION_APP_STARTED			= "NCAppStarted"
    let		NOTIFICATION_USER_LOGGED_IN			= "NCUserLoggedIn"
    let		NOTIFICATION_USER_LOGGED_OUT		= "NCUserLoggedOut"
    

    //MARK:-
    //MARK:Properties
    var numberOfMessages = 0

    weak var delegateInitial: delegateInitialAppLoad?
    weak var delegateUser: delegateUserProfile?
    var userTotal = 0, usersOnline = 0
    var objAdmin: PAppSetting?
    var adminMode = false
    var arrayOfAllCorps = [PCorps]?()
    var arrayOfWorldClass = [PCorps]?()
    var arrayOfOpenClass = [PCorps]?()
    var arrayOfAllAge = [PCorps]?()
    var arrayOfAllShows = [PShow]?()
    var arrayOfBannerImages = [UIImage]?()
    var arrayOfBannerObjects = [PBanner]?()
    var arrayOfSubscribedRooms = [String]()
    
    //MARK:-
    //MARK: Initial App Load (delgateInitialAppLoad)
    func updateFacts() {
        let query = PFQuery(className: PFact.parseClassName())
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                if let facts = objects {
                    if facts.count > 0 {
                        let randomIndex = Int(arc4random_uniform(UInt32(facts.count)))
                        self.delegateInitial?.displayFact(facts[randomIndex] as! PFact)
                    }
                }
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("Error getting facts: \(errorString)")
            }
        }
    }
    
    func updateAppStatus() {
        //check to see if there are any admin messages to display to the user
        //and whether or not to continue running
        let query = PFQuery(className: PAppMessage.parseClassName())
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error === nil {
                if let objs = objects {
                    if objs.count > 0 {
                        let obj = objs.last!
                        self.delegateInitial?.showAppMessage(obj["title"] as? String, message: obj["message"] as? String, canUseApp: obj["canUseApp"] as! Bool)
                    }
                }
                
            } else {
                print("Error checking for app messages: \(error!) \(error!.userInfo)")
            }
            self.delegateInitial?.updateProgress()
            print("1. App status ok.")
        }
    }
    
    func signInAndSyncOrAllowAnonymousUser() {
        PFInstallation.currentInstallation().saveInBackground()
        if let currentUser = PFUser.currentUser() {
            // update user
            currentUser.fetchInBackgroundWithBlock({ (user: PFObject?, err: NSError?) in
                if let error = err {
                    let errorString = error.userInfo["error"] as? NSString
                    print("Error fetching user: \(errorString)")
                }
                self.delegateInitial?.updateProgress()
                self.updateUserLastLogin()
                print("2. User logged in.")
            })
        } else {
                self.delegateInitial?.updateProgress()
                print("2. Anonymous user.")
        }
    }
    
    func updateUserLocation() {
        if PFUser.currentUser() != nil {
            PFGeoPoint.geoPointForCurrentLocationInBackground { (geo: PFGeoPoint?, err: NSError?) in
                if let error = err {
                    let errorString = error.userInfo["error"] as? NSString
                    print("Error updating user location: \(errorString)")
                    self.delegateInitial?.updateProgress()
                } else {
                    let geoCoder = CLGeocoder()
                    let location = CLLocation(latitude: (geo?.latitude)!, longitude: (geo?.longitude)!)
                    geoCoder.reverseGeocodeLocation(location, completionHandler:
                        {(placemarks, error) in
                            if let topResult = placemarks?.first {
                                let loc = "]\(topResult.locality), \(topResult.administrativeArea)"
                                PFUser.currentUser()!["location"] = loc
                                PFUser.currentUser()!["geo"] = geo
                                PFUser.currentUser()!.saveEventually()
                                self.setInstallationLocationAllowed(true)
                                self.delegateInitial?.updateProgress()
                                print("3. User location updated.")
                            }
                    })
                }
            }
        } else {
            self.delegateInitial?.updateProgress()
            print("3. Anonymous user cannot update location. This is ok.")
        }
    }
    
    func updateAppSettings() {
        self.updateNumberOfUsers()
        let query = PFQuery(className: PAppSetting.parseClassName())
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                self.objAdmin = objects!.last as? PAppSetting
                self.delegateInitial?.updateProgress()
                self.updateNews() //We call update news here, because we need the URL from the admin object
                print("4. App Settings Updated.")
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("Error getting app settings: \(errorString)")
            }
        }
    }
    
    func updateNews() {
        News.sharedInstance.delegateNewsParser = self
        News.sharedInstance.beginUpdatingNewsWithURL((self.objAdmin?.DCI_news)!)
    }

    func newsDidLoad() {
        self.delegateInitial?.updateProgress()
        print("5. News updated.")
    }
    
    func newsDidFail() {
        self.delegateInitial?.updateProgress()
        print("5. Error loading news.")
    }
    
    func updateCorps() {
        self.arrayOfAllCorps = [PCorps]()
        self.arrayOfWorldClass = [PCorps]()
        self.arrayOfOpenClass = [PCorps]()
        self.arrayOfAllAge = [PCorps]()
        let query = PFQuery(className: PCorps.parseClassName())
        query.orderByAscending("corpsName")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                for corps in objects! {
                    if let active = corps["active"] as? Bool {
                        if active {
                            self.arrayOfAllCorps?.append(corps as! PCorps)
                            let corpsclass = corps["class"] as! String
                            switch corpsclass {
                            case "World": self.arrayOfWorldClass?.append(corps as! PCorps)
                            case "Open": self.arrayOfOpenClass?.append(corps as! PCorps)
                            case "All Age": self.arrayOfAllAge?.append(corps as! PCorps)
                            default: print("Error sorting the corps by class. A class doesn't exist.")
                            }
                        }
                    }
                }
                self.delegateInitial?.updateProgress()
                print("6. Corps Updated.")
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("Error updating the corps: \(errorString)")
            }
        }
    }
    
    func updateShows() {
        self.arrayOfAllShows = [PShow]()
        let query = PFQuery(className: PShow.parseClassName())
        query.includeKey("stadium")
        query.limit = 1000
        query.orderByAscending("showDate")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                for show in objects! {
                    self.arrayOfAllShows?.append(show as! PShow)
                }
                self.delegateInitial?.updateProgress()
                print("7. Shows Updated.")
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("Error updating the shows: \(errorString)")
            }
        }
    }
    
    func updateBanners() {
        self.arrayOfBannerImages = [UIImage]()
        self.arrayOfBannerObjects = [PBanner]()
        let query = PFQuery(className: PBanner.parseClassName())
        query.whereKey("hidden", equalTo: false)
        query.whereKey("type", equalTo: "MAIN")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                for obj in objects! {
                    let userImageFile = obj["image"] as! PFFile
                    userImageFile.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
                        if err === nil {
                            let image = UIImage(data: data!)
                            self.arrayOfBannerImages?.append(image!)
                            self.arrayOfBannerObjects?.append(obj as! PBanner)
                        }
                    })
                }
                self.delegateInitial?.updateProgress()
                print("8. Banners Updated.")
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("Error updating the banners: \(errorString)")
            }
        }
    }
    
    //MARK:-
    //MARK:User (delegateUser)
    func getUnreadMessagesForUser() {
        if PFUser.currentUser() != nil {
            self.numberOfMessages = 0
            let query = PFQuery(className: "Messages")
            query.whereKey(PF_CHAT_ROOMID, containsString: PFUser.currentUser()?.objectId)
            query.whereKey("belongToUser", equalTo: PFUser.currentUser()!)
            query.selectKeys(["counter"])
            query.includeKey("user")
            query.limit = 50
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, err: NSError?) in
                if err === nil {
                    if objects!.count > 0 {
                        for obj in objects! {
                            self.numberOfMessages += obj["counter"] as! Int
                        }
                        self.delegateUser!.updateUserMessages()
                    }
                } else {
                    let errorString = err!.userInfo["error"] as? NSString
                    print("Error updating user messages: \(errorString)")
                }
            })
        }
    }
    
    
    //MARK:-
    //MARK: Helpers
    func removeOldScoresForEachCorps() {
        //THIS IS NOT PART OF THE FUNCTIONALITY OF THE APP
        //ONLY USED FOR DEBBUGING OR TESTING
        //CALL TO REMOVE SCORES THAT HAVE BEEN UPDATED THROUGHOUT USE OF THE APP
        if let allcorps = self.arrayOfAllCorps as [PFObject]! {
            for corp in allcorps {
                corp.removeObjectForKey("olderScore")
                corp.removeObjectForKey("lastScore")
                corp.removeObjectForKey("lastScoreDate")
                corp.removeObjectForKey("lastBrass")
                corp.removeObjectForKey("lastColorguard")
                corp.removeObjectForKey("lastPercussion")
                corp.saveInBackground()
            }
        }
    }
    
    func updateUserLastLogin() {
        if let currentUser = PFUser.currentUser() {
            currentUser["lastLogin"] = NSDate()
            currentUser.saveEventually()
        }
    }
    
    func setInstallationLocationAllowed(on: Bool) {
        let install = PFInstallation.currentInstallation()
        install["allowsLocation"] = on
        install.saveEventually()
    }
    
    func updateNumberOfUsers() {
        let query = PFQuery(className: "_User")
        query.countObjectsInBackgroundWithBlock { (number: Int32, err: NSError?) in
            if let error = err {
                self.userTotal = 0
                let errorString = error.userInfo["error"] as? NSString
                print("Error counting users: \(errorString)")
            }
        }
        //TODO: fix cloud code/swift/parse server issues
        //        PFCloud.callFunctionInBackground("getOnlineUsers", withParameters: [:], block: {
        //            (result: AnyObject!, err: NSError!) -> Void in
        //            if ( error === nil) {
        //                self.usersOnline = result as! Int
        //            } else if (error != nil) {
        //                self.usersOnline = 0
        //                let errorString = err.userInfo["error"] as? NSString
        //                print("Error counting users: \(errorString)")
        //            }
        //        });
    }
    
    func unsubscribeFromAllRooms() {
        self.arrayOfSubscribedRooms.removeAll()
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation["chatRooms"] = []
        currentInstallation.saveInBackground()
    }
}
