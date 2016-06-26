//
//  AppDelegate.swift
//  CorpBoard
//
//  Created by Justin Moore on 5/8/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

import UIKit
import Stripe
import IQKeyboardManager
import ParseFacebookUtilsV4
import Firebase

protocol messagesDelegate: class {
    func messageReceived()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let stripePublishableKey = "pk_test_UJ1Jcj6gdlBK5ASXmKWeR7Vf"
    var window: UIWindow?
    var alertParentView = UIView()
    var messDelegate: messagesDelegate?
    
    
    override init() {
        FIRApp.configure()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Stripe.setDefaultPublishableKey(stripePublishableKey)
        
        PCorps.registerSubclass()
        PFact.registerSubclass()
        PShow.registerSubclass()
        PStadium.registerSubclass()
        PUser.registerSubclass()
        PPhoto.registerSubclass()
        PAppMessage.registerSubclass()
        PAppSetting.registerSubclass()
        PChat.registerSubclass()
        PBanner.registerSubclass()
        PFavorite.registerSubclass()
        PScore.registerSubclass()
        PCalendar.registerSubclass()
        PDailySchedule.registerSubclass()
        PStoreItem.registerSubclass()
        POrder.registerSubclass()
        PVideo.registerSubclass()
        PCorpsExperience.registerSubclass()
        PRepertoire.registerSubclass()
        PChatRoom.registerSubclass()
        
        Parse.enableLocalDatastore()
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "wx8eMIWy1f9e60WrQJYUI81jlk5g6YYAPPmwxequ"
            $0.clientKey = "ECyvUjxayFW3un2sOkTkgFJC8mmqweeOAjW0OlKJ"
            $0.server = "http://corpsboard.herokuapp.com/parse"
            $0.localDatastoreEnabled = true
        }
        Parse.initializeWithConfiguration(configuration)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        IQKeyboardManager.sharedManager().overrideKeyboardAppearance = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().toolbarManageBehaviour = IQAutoToolbarManageBehaviour.ByPosition
        IQKeyboardManager.sharedManager().keyboardAppearance = UIKeyboardAppearance.Dark
        
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        //UINavigationBar.appearance().translucent = false
        let navBgImage = UIImage(named: "stone")!
        UINavigationBar.appearance().setBackgroundImage(navBgImage, forBarMetrics: .Default)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        registerForPushNotifications(application)
        return true

    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("User allowed push notifications.")
        //Store the deviceToken int he current installation for parse
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation["allowsPush"] = true
        currentInstallation.saveInBackground()
    }
    
    //handles push notifications if user is running the app (not in background)
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Got a notification")
//        if application.applicationState == UIApplicationState.Active {
//            let currentInstallation = PFInstallation.currentInstallation()
//            let count = currentInstallation["badge"] as? Int
//            if count != 0 {
//                currentInstallation.setValue(0, forKey: "badge")
//                currentInstallation.saveInBackground()
//            }
//            let dict = userInfo["aps"]
//            let pushView = NSBundle.mainBundle().loadNibNamed("CBPush",
//                                                                      owner: self,
//                                                                      options: nil) as! CBPush
//            pushView.showPush(dict["alert"], inParent: self.alertParentView)
//            
//        }
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("User did not allow push notifications.")
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation["allowsPush"] = false
        currentInstallation.saveInBackground()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "kLastCloseDate")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //self.checkLastLogin()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        let currentInstallation = PFInstallation.currentInstallation()
        let count = currentInstallation["badge"] as! Int
        if count != 0 {
            currentInstallation.setValue(0, forKey: "badge")
            currentInstallation.saveInBackground()
        }
    
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        Server.sharedInstance.unsubscribeFromAllRooms()
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "kLastCloseDate")
    }
//    
//    func checkLastLogin() {
//        let lastDate = NSUserDefaults.standardUserDefaults().objectForKey("kLastCloseDate") as! NSDate
//        let timeDiff = NSDate().minutesAfterDate(lastDate)
//        if timeDiff > 2 {
//            //restart app
//            // Access the storyboard and fetch an instance of the view controller
//            var storyboard = UIStoryboard(name: "Main", bundle: nil)
//            var viewController: MainViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as MainViewController
//            
//            // Then push that view controller onto the navigation stack
//            var rootViewController = self.window!.rootViewController as UINavigationController
//            rootViewController.pushViewController(viewController, animated: true)
//        }
//    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
}

















