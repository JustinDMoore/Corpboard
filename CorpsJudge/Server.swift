//
//  Server.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/5/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import Foundation
import ImageSlideshow
import YouTubePlayer

protocol delegateInitialAppLoad: class {
    func updateProgress()
    func showAppMessage(title: String?, message: String?, canUseApp: Bool)
    func displayFact(factObject: PFact)
}


protocol delegateUserProfile: class {
    func updateUserMessages()
}

@objc protocol delegateUserLocation: class {
    func userLocationUpdated()
    func userLocationError()
}

//TODO: Remove @objc
@objc class Server: NSObject, delegateNews {
    
    //MARK:-
    //MARK:SINGLETON DECLARATION
    static let sharedInstance = Server()
    
    //MARK:-
    //MARK:Properties
    var numberOfMessages = 0

    weak var delegateInitial: delegateInitialAppLoad?
    weak var delegateUser: delegateUserProfile?
    weak var delegateLocation: delegateUserLocation?
    var userTotal = 0, usersOnline = 0
    var objAdmin: PAppSetting?
    var adminMode = false
    var arrayOfAllCorps = [PCorps]?()

    var arrayOfWorldClass = [PCorps]?()
    var arrayOfOpenClass = [PCorps]?()
    var arrayOfAllAgeClass = [PCorps]?()
    
    
    var NSarrayOfWorldClass = NSMutableArray()
    var NSarrayOfOpenClass = NSMutableArray()
    var NSarrayOfAllAgeClass = NSMutableArray()
    
    var arrayOfAllShows = [PShow]?()
    var arrayOfBannerImages = [ImageSource]?()
    var arrayOfBannerObjects = [PBanner]?()
    var arrayOfVideoPlayerViews = [YouTubePlayerView]()
    var arrayOfSubscribedRooms = [String]()
    
    var arrayOfAllFavorites = NSMutableArray()
    
    var arrayOfWorldFavs = NSMutableArray()
    var arrayOfWorldFavorites = NSMutableArray()
    var arrayOfWorldColorguardFavs = NSMutableArray()
    var arrayOfWorldHornlineFavs = NSMutableArray()
    var arrayOfWorldLoudestFavs = NSMutableArray()
    var arrayOfWorldPercussionFavs = NSMutableArray()
    
    var arrayOfOpenFavs = NSMutableArray()
    var arrayOfOpenFavorites = NSMutableArray()
    var arrayOfOpenColorguardFavs = NSMutableArray()
    var arrayOfOpenHornlineFavs = NSMutableArray()
    var arrayOfOpenLoudestFavs = NSMutableArray()
    var arrayOfOpenPercussionFavs = NSMutableArray()
    
    var arrayOfAllAgeFavs = NSMutableArray()
    var arrayOfAllAgeFavorites = NSMutableArray()
    var arrayOfAllAgeColorguardFavs = NSMutableArray()
    var arrayOfAllAgeHornlineFavs = NSMutableArray()
    var arrayOfAllAgeLoudestFavs = NSMutableArray()
    var arrayOfAllAgePercussionFavs = NSMutableArray()
    
    var arrayOfWorldColorguardVotes = NSMutableArray()
    var arrayOfWorldFavorirtes = NSMutableArray()
    var arrayOfWorldHornlineVotes = NSMutableArray()
    var arrayOfWorldPercussionVotes = NSMutableArray()
    var arrayOfWorldLoudestVotes = NSMutableArray()

    var arrayOfOpenColorguardVotes = NSMutableArray()
    var arrayOfOpenFavorirtes = NSMutableArray()
    var arrayOfOpenHornlineVotes = NSMutableArray()
    var arrayOfOpenPercussionVotes = NSMutableArray()
    var arrayOfOpenLoudestVotes = NSMutableArray()
    
    var arrayOfAllAgeColorguardVotes = NSMutableArray()
    var arrayOfAllAgeFavorirtes = NSMutableArray()
    var arrayOfAllAgeHornlineVotes = NSMutableArray()
    var arrayOfAllAgePercussionVotes = NSMutableArray()
    var arrayOfAllAgeLoudestVotes = NSMutableArray()
    
    var arrayOfWorldClassRankings = NSMutableArray()
    var arrayOfOpenClassRankings = NSMutableArray()
    var arrayOfAllAgeClassRankings = NSMutableArray()
    
    var arrayOfUserWorldClassRankings = NSMutableArray()
    var arrayOfUserOpenClassRankings = NSMutableArray()
    var arrayOfUserAllAgeClassRankings = NSMutableArray()
    
    var day = PCalendar()
    var currentTask = String()
    var currentLocation = String()
    
    var arrayOfFacts = [PFObject]()
    var isFactDisplayed = false
    
    func createShowsAndScores() {
        let config = Configuration()
        config.getAllCorps()
    }
    
    //MARK:-
    //MARK: Initial App Load (delgateInitialAppLoad)
    func factBaseQuery() -> PFQuery {
        let query = PFQuery(className: PFact.parseClassName())
        return query
    }
    
    func findObjectsLocallyThenRemotely(query: PFQuery!, block:[AnyObject]! -> Void) {
        
        let localQuery = (query.copy() as! PFQuery).fromLocalDatastore()
        localQuery.findObjectsInBackgroundWithBlock({ (locals, error) -> Void in
            if (error == nil) {
                block(locals)
                self.arrayOfFacts = []
                for fact in locals! {
                    self.arrayOfFacts.append(fact)
                }
            } else {
                print("Error : Local Query \(query.parseClassName)")
            }
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if(error == nil) {
                    self.arrayOfFacts = []
                    for fact in objects! {
                        self.arrayOfFacts.append(fact)
                    }
                    PFObject.unpinAllInBackground(locals, block: { (success, error) -> Void in
                        if (error == nil) {
                            block(objects)
                            PFObject.pinAllInBackground(objects, block: { (success, error) -> Void in
                                if (error == nil) {
                                } else {
                                    print("Error : Pin Query Result \(query.parseClassName)")
                                }
                            })
                        } else {
                            print("Error : Unpin Local Query \(query.parseClassName)")
                        }
                    })
                } else {
                    print("Error : Network Query \(query.parseClassName)")
                }
            })
        })
    }

    func updateFacts() {
        self.findObjectsLocallyThenRemotely(self.factBaseQuery()) { (results: [AnyObject]!) in
            if let facts = results {
                if facts.count > 0 {
                    if !self.isFactDisplayed {
                        self.isFactDisplayed = true
                        let randomIndex = Int(arc4random_uniform(UInt32(facts.count)))
                        self.delegateInitial?.displayFact(facts[randomIndex] as! PFact)
                    }
                }
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
                print("1. APP STATUS: **ERROR** \(error!) - \(error!.userInfo)")
            }
            self.delegateInitial?.updateProgress()
            print("1. APP STATUS: OK")
        }
    }
    
    func signInAndSyncOrAllowAnonymousUser() {
        PFInstallation.currentInstallation().saveInBackground()
        if let currentUser = PFUser.currentUser() {
            // update user
            currentUser.fetchInBackgroundWithBlock({ (user: PFObject?, err: NSError?) in
                if let error = err {
                    let errorString = error.userInfo["error"] as? NSString
                    print("2. USER: **ERROR** \(errorString)")
                }
                self.delegateInitial?.updateProgress()
                self.updateUserLastLogin()
                print("2. USER LOGGED IN: \(currentUser["fullname"])")
            })
        } else {
                self.delegateInitial?.updateProgress()
                print("2. USER: New User")
        }
    }
    
    func updateUserLocation() {
        //make sure location is enabled, if not, set installationAllowsLocation to false, then bail
        switch CLLocationManager.authorizationStatus() {
        case .Denied:
            self.setInstallationLocationAllowed(false)
            self.delegateInitial?.updateProgress()
            self.delegateLocation?.userLocationError()
            print("3. LOCATION SERVICES: Not allowed")
            return
        case .AuthorizedAlways:
            break
        case .AuthorizedWhenInUse:
            break
        case .NotDetermined:
            self.delegateInitial?.updateProgress()
            print("3. LOCATION SERVICES: Not prompted")
            return
        case .Restricted:
            self.setInstallationLocationAllowed(false)
            self.delegateInitial?.updateProgress()
            self.delegateLocation?.userLocationError()
            print("3. LOCATION SERVICES: Not allowed")
            return
        }
        
        if PFUser.currentUser() != nil {
            PFGeoPoint.geoPointForCurrentLocationInBackground { (geo: PFGeoPoint?, err: NSError?) in
                if let error = err {
                    let errorString = error.userInfo["error"] as? NSString
                    print("3. LOCATION SERVICES: **ERROR** \(errorString)")
                    self.delegateInitial?.updateProgress()
                } else {
                    if let geoL = geo {
                        let geoCoder = CLGeocoder()
                        let location = CLLocation(latitude: (geoL.latitude), longitude: (geoL.longitude))
                        geoCoder.reverseGeocodeLocation(location, completionHandler:
                            {(placemarks, error) in
                                if let topResult = placemarks?.first {
                                    if topResult.locality != nil && topResult.administrativeArea != nil {
                                        let loc = "\(topResult.locality!), \(topResult.administrativeArea!)"
                                        PFUser.currentUser()!["location"] = loc
                                        PFUser.currentUser()!["geo"] = geo
                                        PFUser.currentUser()!.saveEventually()
                                        self.setInstallationLocationAllowed(true)
                                        self.delegateInitial?.updateProgress()
                                        print("3. LOCATION: \(loc)")
                                        self.delegateLocation?.userLocationUpdated()
                                    } else {
                                        //no location from result
                                        self.delegateInitial?.updateProgress()
                                        print("3. LOCATION: **ERROR** Unknown Location")
                                        self.delegateLocation?.userLocationError()
                                    }
                                } else {
                                    //no result
                                    self.delegateInitial?.updateProgress()
                                    print("3. LOCATION: **ERROR** Unknown Location")
                                    self.delegateLocation?.userLocationError()
                                }
                        })
                    }
                }
            }
        } else {
            self.delegateInitial?.updateProgress()
            print("3. LOCATION: New user")
            self.delegateLocation?.userLocationError()
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
                print("4. APP SETTINGS: OK")
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("4. APP SETTINGS: **ERROR** \(errorString)")
            }
        }
    }
    
    func updateNews() {
        News.sharedInstance.delegateNewsParser = self
        News.sharedInstance.beginUpdatingNewsWithURL((self.objAdmin?.DCI_news)!)
    }

    func newsDidLoad() {
        self.delegateInitial?.updateProgress()
        print("5. NEWS: OK")
    }
    
    func newsDidFail() {
        self.delegateInitial?.updateProgress()
        print("5. NEWS: **ERROR**")
    }
    
    func updateCorps() {
        self.arrayOfAllCorps = [PCorps]()
        self.arrayOfWorldClass = [PCorps]()
        self.arrayOfOpenClass = [PCorps]()
        self.arrayOfAllAgeClass = [PCorps]()
        let query = PFQuery(className: PCorps.parseClassName())
        query.orderByAscending("corpsName")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                for corps in objects! {
                    if let active = corps["active"] as? Bool {
                        if active {
                            self.arrayOfAllCorps?.append(corps as! PCorps)
                            let corpsclass = corps["classification"] as! String
                            switch corpsclass {
                            case "World":
                                self.arrayOfWorldClass?.append(corps as! PCorps)
                                self.NSarrayOfWorldClass.addObject(corps)
                            case "Open":
                                self.arrayOfOpenClass?.append(corps as! PCorps)
                                self.NSarrayOfOpenClass.addObject(corps)
                            case "All Age":
                                self.arrayOfAllAgeClass?.append(corps as! PCorps)
                                self.NSarrayOfAllAgeClass.addObject(corps)
                            default: print("Error sorting the corps by class. A class doesn't exist.")
                            }
                        }
                    }
                }
                self.delegateInitial?.updateProgress()
                print("6. CORPS: OK")
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("6. CORPS: **ERROR** \(errorString)")
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
                print("7. SHOWS: OK")
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("7. SHOWS: **ERROR** \(errorString)")
            }
        }
    }
    
//    func deleteShows() {
//        let query = PFQuery(className: "Scores")
//        query.limit = 1000
//        //query.orderByAscending("createdAt")
//        query.whereKey("isOfficial", equalTo: true)
//        query.findObjectsInBackgroundWithBlock { (photos: [PFObject]?, err: NSError?) in
//            if photos?.count > 0 {
//                for obj in photos! {
//                    obj.deleteInBackground()
////                    let rep = PRepertoire()
////                    if obj["placement"] != nil {
////                        rep.placement = obj["placement"] as! String
////                    }
////                    
////                    if obj["score"] != nil {
////                        rep.score = obj["score"] as! String
////                    }
////                    
////                    if obj["corpsName"] != nil {
////                        rep.corpsName = obj["corpsName"] as! String
////                    }
////                    
////                    if obj["repertoire"] != nil {
////                        rep.repertoire = obj["repertoire"] as! String!
////                    }
////                    
////                    if obj["class"] != nil {
////                        rep.classification = obj["class"] as! String
////                    }
////                    
////                    if obj["showTitle"] != nil {
////                        rep.showTitle = obj["showTitle"] as? String
////                    }
////                    
////                    if obj["year"] != nil {
////                        rep.year = obj["year"] as! Int
////                    }
////                    
////                    for corps in self.arrayOfAllCorps! {
////                        if corps.corpsName == obj["corpsName"] as! String {
////                            rep.corps = corps
////                            break
////                        }
////                    }
////                    
////                    rep.saveInBackground()
//                }
//            }
//        }
//    }
    
    func updateBanners() {

        self.arrayOfBannerImages = [ImageSource]()
        self.arrayOfBannerObjects = [PBanner]()
        let query = PFQuery(className: PBanner.parseClassName())
        query.whereKey("hidden", equalTo: false)
        query.whereKey("type", equalTo: "MAIN")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                var x = 0
                for obj in objects! {
                    let userImageFile = obj["image"] as! PFFile
                    userImageFile.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) in
                        if err === nil {
                            x+=1
                            let image = UIImage(data: data!)
                            let imageSource = ImageSource(image: image!)
                            self.arrayOfBannerImages?.append(imageSource)
                            self.arrayOfBannerObjects?.append(obj as! PBanner)
                            if x == objects!.count {
                                //we've processed all the banners, notify the progress
                                self.delegateInitial?.updateProgress()
                                print("8. BANNERS: OK")
                            }
                        }
                    })
                }
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("8. BANNERS: **ERROR** \(errorString)")
            }
        }
    }
    
    func updateVideos() {
        arrayOfVideoPlayerViews = [YouTubePlayerView]()
        let query = PFQuery(className: PVideo.parseClassName())
        query.whereKey("public", equalTo: true)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                for video in objects! {
                    if let vid = video as? PVideo {
                        let viewVideo = YouTubePlayerView(frame: CGRectZero)
                        let myVideoURL = NSURL(string: vid.url)
                        viewVideo.loadVideoURL(myVideoURL!)
                        self.arrayOfVideoPlayerViews.append(viewVideo)
                    }
                }
                self.delegateInitial?.updateProgress()
                if !objects!.isEmpty { print("9. VIDEOS: \(objects!.count)") }
                else { print("9. VIDEOS: 0") }
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("9. VIDEOS: **ERROR** \(errorString)")
            }
        }
    }
    
    //MARK:-
    //MARK:User (delegateUser)
    func getUnreadMessagesForUser() {
        if PFUser.currentUser() != nil {
            self.numberOfMessages = 0
            let query = PFQuery(className: "Messages")
            query.whereKey("roomId", containsString: PFUser.currentUser()?.objectId)
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
        //        })
    }
    
    //MARK:-
    //MARK:Chatroom Subscriptions
    
    func subscribeToRoom(roomID: String) {
        //if they aren't subscribed on parse, makes it so
        if !self.isUserSubscribedToChatRoomOnParse(roomID) {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.addUniqueObject(roomID, forKey: "chatRooms")
            currentInstallation.saveInBackgroundWithBlock({ (complete: Bool, err: NSError?) in
                //now sync it with corpsboard
                if !self.isUserSubscribedToChatRoomOnCorpsboard(roomID) {
                    self.arrayOfSubscribedRooms.append(roomID)
                }
            })
        }
    }
    
    func unsubscribeFromRoom(roomID: String) {
        //if they are subscribed on parse, remove it
        if self.isUserSubscribedToChatRoomOnParse(roomID) {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.removeObject(roomID, forKey: "chatRooms")
            currentInstallation.saveInBackgroundWithBlock({ (complete: Bool, err: NSError?) in
                if complete {
                    //now sync it with corpsboard
                    if self.isUserSubscribedToChatRoomOnCorpsboard(roomID) {
                       self.arrayOfSubscribedRooms = self.arrayOfSubscribedRooms.filter{$0 != roomID}
                    }
                }
            })
        }
    }
    
    func isUserSubscribedToChatRoomOnCorpsboard(roomID: String) -> Bool {
        for room in self.arrayOfSubscribedRooms {
            if room == roomID {
                return true
            }
        }
        return false
    }
    
    func isUserSubscribedToChatRoomOnParse(roomID: String) -> Bool {
        let currentInstallation = PFInstallation.currentInstallation()
        let subscribedChannels = currentInstallation["chatRooms"] as! [String]
        if subscribedChannels.count > 0 {
            for channel in subscribedChannels {
                if channel == roomID {
                    return true
                }
            }
        } else {
            return false
        }
        return false
    }
    
    func unsubscribeFromAllRooms() {
        self.arrayOfSubscribedRooms = []
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation["chatRooms"] = []
        currentInstallation.saveInBackground()
    }
    
    
    //MARK:-
    //MARK:Push Notifications
    
    func setUpPushNotifications() {
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(pushNotificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        let pushAllowed = UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
        self.setParsePush(pushAllowed)
    }
    
    func setParsePush(on: Bool) {
        let install = PFInstallation.currentInstallation()
        let allowsPush = install["allowsPush"] as! Bool
        if allowsPush != on {
            install["allowsPush"] = on
            install.saveEventually()
        }
    }
    
    func checkForAdminMode() {
        if let user = PUser.currentUser() {
            if user.isAdmin { self.adminMode = true }
        }
    }
    
    func getCurrentTask() {
        
        let now = NSDate()
        now.dateByAddingMinutes(1)
        
        let query = PFQuery(className: PDailySchedule.parseClassName())
        query.whereKey("dateTime", lessThan: now)
        query.orderByDescending("dateTime")
        query.limit = 1
        query.includeKey("calendarDay")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                if objects?.count > 0 {
                    if let schedule = objects?.first as? PDailySchedule {
                        self.currentLocation = "The Cadets are in \(schedule.calendarDay.city)"
                        self.currentTask = "and \(schedule.taskPresent)"
                        self.getCurrentLocationForTheCadets(true)
                    }
                } else {
                    self.getCurrentLocationForTheCadets(false)
                }
            }
        }
    }
    
    func getCurrentLocationForTheCadets(hasTask: Bool) {
            
            let now = NSDate()
            now.dateByAddingMinutes(1)
            
            let query = PFQuery(className: PCalendar.parseClassName())
            query.includeKey("housing")
            query.includeKey("show")
            query.whereKey("date", lessThan: now)
            query.orderByDescending("date")
            query.limit = 1
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
                if err === nil {
                    if objects?.count > 0 {
                        if let obj = objects?.first as? PCalendar {
                            self.day = obj
                            if (!hasTask) {
                                self.currentLocation = "The Cadets are in \(obj.city)"
                                self.currentTask = "and are hard at work."
                            }
                        }
                    } else {
                        if (!hasTask) {
                            self.currentLocation = "The Cadets are hard at work today."
                            self.currentTask = ""
                        }
                    }
                }
        }
    }
    
    func createDailySchedules() {
        var today = NSDate()
        
        let q = PFQuery(className: PCalendar.parseClassName())
        q.findObjectsInBackgroundWithBlock { (objs: [PFObject]?, err: NSError?) in
            for obj in objs! {
                
                let day = obj as! PCalendar
                if day.typeOfDay == "Spring Training" {
                    let block = PDailySchedule()
                    block.calendarDay = day
                    block.task = "Wake Up"
                    block.taskPresent = "are waking up."
                    block.rawDateTime = "0800"
                    let formatter = NSDateFormatter()
                    formatter.timeZone = NSTimeZone(abbreviation: day.timeZone)
                    let newDate: NSDate = formatter.dateFromString(day.date.toString())!
                    block.dateTime = newDate
                    
                    let calendar = NSCalendar.currentCalendar()
                    let date = day.date
                    let components = calendar.components([.Month, .Day, .Year, .Hour, .Minute, .Second], fromDate: date)
                    components.hour = 17
                    components.minute = 0
                    components.second = 0
                }
            }
        }
        
        for _ in 0..<60 {
            let newSchedule = PCalendar()
            let dateComponents = NSDateComponents()
            dateComponents.day = today.day()
            dateComponents.month = today.month()
            dateComponents.year = today.year()
            dateComponents.hour = 17
            dateComponents.minute = 0
            dateComponents.second = 0
            let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let date = gregorianCalendar!.dateFromComponents(dateComponents)
            newSchedule.date = date!
            today = today.dateByAddingDays(1)
            newSchedule.saveInBackground()
        }
    }
 
    
    
    //DEMO METHODS ---- NOT PART OF THE APP
    func deleteFavorites() {
        let query = PFQuery(className: PFavorite.parseClassName())
        query.limit = 5000
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            for obj in objects! {
                obj.deleteInBackground()
            }
        }
    }
    
//    case catcorps: return @"Favorite Corps";
//    case catdrums: return @"Favorite Drums";
//    case catguard: return @"Favorite Color Guard";
//    case cathornline: return @"Favorite Brass";
//    case catloud: return @"Loudest Brass";


    func createAllDemoFavoritesAndUserScores() {
        createDemoFavoritesForCorpsName("The Cadets", category: "Favorite Brass", count: 20)
        createDemoFavoritesForCorpsName("Carolina Crown", category: "Favorite Brass", count: 18)
        createDemoFavoritesForCorpsName("Blue Devils", category: "Favorite Brass", count: 17)
        createDemoFavoritesForCorpsName("Bluecoats", category: "Favorite Brass", count: 17)
        createDemoFavoritesForCorpsName("Santa Clara Vanguard", category: "Favorite Brass", count: 15)
        createDemoFavoritesForCorpsName("Phantom Regiment", category: "Favorite Brass", count: 12)
        createDemoFavoritesForCorpsName("The Cavaliers", category: "Favorite Brass", count: 11)
        createDemoFavoritesForCorpsName("Blue Knights", category: "Favorite Brass", count: 10)
        createDemoFavoritesForCorpsName("Madison Scouts", category: "Favorite Brass", count: 10)
        createDemoFavoritesForCorpsName("Blue Stars", category: "Favorite Brass", count: 7)
        createDemoFavoritesForCorpsName("Crossmen", category: "Favorite Brass", count: 3)
        createDemoFavoritesForCorpsName("Boston Crusaders", category: "Favorite Brass", count: 2)
        
        createDemoFavoritesForCorpsName("The Cadets", category: "Loudest Brass", count: 22)
        createDemoFavoritesForCorpsName("Carolina Crown", category: "Loudest Brass", count: 26)
        createDemoFavoritesForCorpsName("Blue Devils", category: "Loudest Brass", count: 20)
        createDemoFavoritesForCorpsName("Bluecoats", category: "Loudest Brass", count: 18)
        createDemoFavoritesForCorpsName("Phantom Regiment", category: "Loudest Brass", count: 14)
        createDemoFavoritesForCorpsName("Santa Clara Vanguard", category: "Loudest Brass", count: 13)
        
        createDemoFavoritesForCorpsName("The Cadets", category: "Favorite Drums", count: 28)
        createDemoFavoritesForCorpsName("Santa Clara Vanguard", category: "Favorite Drums", count: 24)
        createDemoFavoritesForCorpsName("Blue Devils", category: "Favorite Drums", count: 25)
        createDemoFavoritesForCorpsName("Carolina Crown", category: "Favorite Drums", count: 16)
        createDemoFavoritesForCorpsName("The Cavaliers", category: "Favorite Drums", count: 10)
        createDemoFavoritesForCorpsName("Blue Knights", category: "Favorite Drums", count: 4)
        
        createDemoFavoritesForCorpsName("The Cadets", category: "Favorite Corps", count: 30)
        createDemoFavoritesForCorpsName("The Cavaliers", category: "Favorite Corps", count: 22)
        createDemoFavoritesForCorpsName("Carolina Crown", category: "Favorite Corps", count: 26)
        createDemoFavoritesForCorpsName("Phantom Regiment", category: "Favorite Corps", count: 20)
        createDemoFavoritesForCorpsName("Blue Devils", category: "Favorite Corps", count: 28)
        createDemoFavoritesForCorpsName("Bluecoats", category: "Favorite Corps", count: 25)
        createDemoFavoritesForCorpsName("Santa Clara Vanguard", category: "Favorite Corps", count: 24)
        createDemoFavoritesForCorpsName("Blue Knights", category: "Favorite Corps", count: 17)
        createDemoFavoritesForCorpsName("Madison Scouts", category: "Favorite Corps", count: 18)
        createDemoFavoritesForCorpsName("Crossmen", category: "Favorite Corps", count: 14)
        createDemoFavoritesForCorpsName("Spirit of Atlanta", category: "Favorite Corps", count: 10)
        createDemoFavoritesForCorpsName("Troopers", category: "Favorite Corps", count: 9)
        
        createDemoFavoritesForCorpsName("Blue Devils", category: "Favorite Color Guard", count: 20)
        createDemoFavoritesForCorpsName("The Cadets", category: "Favorite Color Guard", count: 19)
        createDemoFavoritesForCorpsName("Carolina Crown", category: "Favorite Color Guard", count: 16)
        createDemoFavoritesForCorpsName("Santa Clara Vanguard", category: "Favorite Color Guard", count: 14)
        createDemoFavoritesForCorpsName("Phantom Regiment", category: "Favorite Color Guard", count: 10)
        
        createDemoUserScoreForCorpsName("The Cadets", scoreAmount: "92.75")
        createDemoUserScoreForCorpsName("Blue Devils", scoreAmount: "90.15")
        createDemoUserScoreForCorpsName("Carolina Crown", scoreAmount: "90.00")
        createDemoUserScoreForCorpsName("Bluecoats", scoreAmount: "89.00")
        createDemoUserScoreForCorpsName("Santa Clara Vanguard", scoreAmount: "87.25")
        createDemoUserScoreForCorpsName("Blue Knights", scoreAmount: "85.30")
        createDemoUserScoreForCorpsName("Blue Stars", scoreAmount: "83.75")
        createDemoUserScoreForCorpsName("The Cavaliers", scoreAmount: "86.75")
        createDemoUserScoreForCorpsName("Phantom Regiment", scoreAmount: "86.65")
        createDemoUserScoreForCorpsName("Crossmen", scoreAmount: "80.10")
        createDemoUserScoreForCorpsName("Madison Scouts", scoreAmount: "81.25")
        createDemoUserScoreForCorpsName("Pacific Crest", scoreAmount: "72.30")
    }
    
//    @NSManaged var classification: String
//    @NSManaged var corps: PCorps
//    @NSManaged var showDate: NSDate
//    @NSManaged var user: PUser
//    @NSManaged var exception: String
//    @NSManaged var colorguardScore: String
//    @NSManaged var score: String
//    @NSManaged var corpsName: String
//    @NSManaged var isOfficial: Bool
//    @NSManaged var percussionScore: String
//    @NSManaged var hornlineScore: String
//    @NSManaged var show: PShow
//    @NSManaged var performanceTime: String
    func createDemoUserScoreForCorpsName(corpsName: String, scoreAmount: String) {
        for corps in arrayOfAllCorps! {
            if corpsName == corps.corpsName {
                let score = PScore()
                score.classification = corps.classification
                score.corps = corps
                score.user = PUser.currentUser()!
                score.score = scoreAmount
                score.corpsName = corps.corpsName
                score.isOfficial = false
                score.saveInBackground()
                break
            }
        }
    }
    
    func createDemoFavoritesForCorpsName(corpsName: String, category: String, count: Int) {
        for _ in 0...count {
            for corps in arrayOfAllCorps! {
                if corpsName == corps.corpsName {
                    let fav = PFavorite()
                    fav.category = category
                    fav.corps = corps
                    fav.corpsName = corps.corpsName
                    fav.showName = "DEMO"
                    fav.user = PUser.currentUser()!
                    fav.classification = corps.classification
                    fav.saveInBackground()
                    break
                }
            }
        }
    }
    
//    func signIntoFirebase() {
//        if let currentUser = PUser.currentUser() {
//            let email = currentUser.email!
//            let password = currentUser.facebookId
//            if !email.characters.isEmpty && !password.characters.isEmpty {
//                FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
//                    if error != nil {
//                        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
//                            if error == nil {
//                                user?.getTokenWithCompletion({ (id: String?, err: NSError?) in
//                                    currentUser.firebaseUID = id
//                                    currentUser.saveInBackground()
//                                })
//                                print("10. FIREBASE: Signed up and logged in")
//                            } else {
//                                print("10. FIREBASE: **ERROR** \(error)")
//                            }
//                        }
//                    } else {
//                        print("10. FIREBASE: Logged In")
//                        if currentUser.firebaseUID == nil || currentUser.firebaseUID == "" {
//                            user?.getTokenWithCompletion({ (id: String?, err: NSError?) in
//                                currentUser.firebaseUID = id
//                                currentUser.saveInBackground()
//                            })
//                        }
//                    }
//                }
//            } else {
//                print("10. FIREBASE: No email and/or password")
//            }
//        }
//    }
}
