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
    func displayFact(factObject: PFObject)
}

class Server {
    
    static let data = Server()
    weak var delegateInitial: delegateInitialAppLoad?
    var userTotal = 0, usersOnline = 0
    var objAdmin: PFObject?
    var news = News()
    var arrayOfAllCorps = [PFObject]?(), arrayOfWorldClass = [PFObject]?(), arrayOfOpenClass = [PFObject]?(), arrayOfAllAge = [PFObject]?(), arrayOfAllShows = [PFObject]?(), arrayOfBannerImages = [UIImage]?(), arrayOfBannerObjects = [PFObject]?()
    
    private init() {
        
    }
    
    //MARK:-
    //MARK: Initial App Load
    func updateFacts() {
        let query = PFQuery(className: "Facts")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                if let facts = objects {
                    if facts.count > 0 {
                        let randomIndex = Int(arc4random_uniform(UInt32(facts.count)))
                        self.delegateInitial?.displayFact(facts[randomIndex])
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
        let query = PFQuery(className:"AppMessages")
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
                self.updateLastLogin()
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
        let query = PFQuery(className: "AppSettings")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                self.objAdmin = objects?.last
                self.delegateInitial?.updateProgress()
                print("4. App Settings Updated.")
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("Error getting app settings: \(errorString)")
            }
        }
    }
    
    func updateNews() {
        news = News()
        self.delegateInitial?.updateProgress()
        print("5. News Updated.")
    }

    func updateCorps() {
        self.arrayOfAllCorps?.removeAll()
        self.arrayOfWorldClass?.removeAll()
        self.arrayOfOpenClass?.removeAll()
        self.arrayOfAllAge?.removeAll()
        let query = PFQuery(className: "corps")
        query.orderByAscending("corpsName")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                for corps in objects! {
                    if let active = corps["active"] as? Bool {
                        if active {
                            self.arrayOfAllCorps?.append(corps)
                            let corpsclass = corps["class"] as! String
                            switch corpsclass {
                            case "World": self.arrayOfWorldClass?.append(corps)
                            case "Open": self.arrayOfOpenClass?.append(corps)
                            case "All Age": self.arrayOfAllAge?.append(corps)
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
        self.arrayOfAllShows?.removeAll()
        let query = PFQuery(className: "shows")
        query.includeKey("stadium")
        query.limit = 1000
        query.orderByAscending("showDate")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err: NSError?) in
            if err === nil {
                self.arrayOfAllShows = objects
                self.delegateInitial?.updateProgress()
                print("7. Shows Updated.")
            } else {
                let errorString = err!.userInfo["error"] as? NSString
                print("Error updating the shows: \(errorString)")
            }
        }
    }
    
    func updateBanners() {
        self.arrayOfBannerImages?.removeAll()
        self.arrayOfBannerObjects?.removeAll()
        let query = PFQuery(className: "banners")
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
                            self.arrayOfBannerObjects?.append(obj)
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
    
    func updateLastLogin() {
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
}
