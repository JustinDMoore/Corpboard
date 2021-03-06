////
////  CBAppDelegate.m
////  CorpsBoard
////
////  Created by Isaias Favela on 6/16/14.
////  Copyright (c) 2014 Justin Moore. All rights reserved.
////
//
//#import "CBAppDelegate.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
//#import "IQKeyboardManager.h"
//#import "CBSingle.h"
//#import <AudioToolbox/AudioToolbox.h>
//#import "DTCoreText.h"
//#import "CBAlertView.h"
//#import "CBPush.h"
//#import "Stripe.h"
//#import "PCorps.swift"
//
//@implementation CBAppDelegate
//
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//NSString * const StripePublishableKey = @"pk_test_UJ1Jcj6gdlBK5ASXmKWeR7Vf";
//CBSingle *data;
//
//
//-(void)setDelegate:(id)newDelegate{
//    delegate = newDelegate;
//}
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    
//    data = [CBSingle data];
//    [Stripe setDefaultPublishableKey:StripePublishableKey];
//    //parse
//    
//    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
//        configuration.applicationId = @"wx8eMIWy1f9e60WrQJYUI81jlk5g6YYAPPmwxequ";
//        configuration.clientKey = @"ECyvUjxayFW3un2sOkTkgFJC8mmqweeOAjW0OlKJ";
//        configuration.server = @"http://corpsboard.herokuapp.com/parse";
//    }]];
//    
//    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//    
//    
//    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
//
//    //facebook
//    //[FBLoginView class];
//
//    
////    //push notifications
////    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
////                                                    UIUserNotificationTypeBadge |
////                                                    UIUserNotificationTypeSound);
////    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
////                                                                             categories:nil];
////    [application registerUserNotificationSettings:settings];
////    [application registerForRemoteNotifications];
//    
//    
//    // Override point for customization after application launch.
//    //self.appTintColor = [UIColor colorWithRed:63/255.0 green:97/255.0 blue:138/255.0 alpha:1];
//    //self.appTintColor = [UIColor colorWithRed:105/255.0 green:140/255.0 blue:181/255.0 alpha:1];
//    
//    self.appTintColor = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:237/255.0 alpha:1];
//    // hex 00aceb
//
//    [[IQKeyboardManager sharedManager] setOverrideKeyboardAppearance:YES];
//    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
//    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
//    [[IQKeyboardManager sharedManager] setKeyboardAppearance:UIKeyboardAppearanceDark];
//
//    
//    [self.window setTintColor:self.appTintColor];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//
////    BOOL isLoggedIn = false;
////    
////    
////    PFUser *currentUser = [PFUser currentUser];
////    [currentUser fetchInBackground];
////    
////    if (currentUser) {
////        isLoggedIn = true;
////    }
////    
////    NSString *storyboardId = isLoggedIn ? @"mainScreen" : @"loginScreen";
////    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:storyboardId];
//    
//    PFInstallation *installation = [PFInstallation currentInstallation];
//    if (![installation.deviceToken length]) {
//        
//    }
//    
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                    didFinishLaunchingWithOptions:launchOptions];
//}
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation];
//}
//
////for push notifications with parse
//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    
//    NSLog(@"User allowed push notifications.");
//    // Store the deviceToken in the current Installation and save it to Parse.
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation setDeviceTokenFromData:deviceToken];
//    currentInstallation.channels = @[ @"global" ];
//    currentInstallation[@"allowsPush"] = [NSNumber numberWithBool:YES];
//    [currentInstallation saveInBackground];
//}
//
//-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    
//    //user did not allow notifications
//    NSLog(@"User did not allow push notifications.");
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    currentInstallation[@"allowsPush"] = [NSNumber numberWithBool:NO];
//    [currentInstallation saveInBackground];
//}
//
////handles push notification if the user is currently running the app (app not in background)
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    
//    if (application.applicationState == UIApplicationStateActive)
//    {
//        
//        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//        
//        int count = [currentInstallation[@"badge"] intValue];
//        
//        if (count != 0) {
//            [currentInstallation setValue:[NSNumber numberWithInt:0] forKey:@"badge"];
//            [currentInstallation saveInBackground];
//        }
//        
//        NSDictionary *dict = [userInfo valueForKey:@"aps"];
//        
//        CBPush *pushView = [[[NSBundle mainBundle] loadNibNamed:@"CBPush"
//                                                          owner:self
//                                                        options:nil]
//                            objectAtIndex:0];
//        
//        [pushView showPush:[dict valueForKey:@"alert"] inParent:self.alertParentView];
//        
//    }
//    
//    NSString *pvt = [userInfo valueForKey:@"type"];
//    
//    if ([pvt isEqualToString:@"Private Message"]) {
//        
//        [data getUnreadMessagesForUser];
//        //[PFPush handlePush:userInfo];
//        if ([delegate respondsToSelector:@selector(messageReceived)]) {
//            
//            [delegate messageReceived];
//        }
//    }
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    
//    [FBSDKAppEvents activateApp];
//    
//    //[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
//    
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    
//    int count = [currentInstallation[@"badge"] intValue];
//    
//    if (count != 0) {
//        [currentInstallation setValue:[NSNumber numberWithInt:0] forKey:@"badge"];
//        [currentInstallation saveInBackground];
//    }
//}
//
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    // Saves changes in the application's managed object context before the application terminates
//    [data unsubscribeFromAllRooms];
//    [self saveContext];
//}
//
//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}
//
//#pragma mark - Core Data stack
//
//// Returns the managed object context for the application.
//// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
//
//-(NSManagedObjectContext *)managedObjectContext {
//
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return _managedObjectContext;
//    
//}
//
//
//
//// Returns the managed object model for the application.
//// If the model doesn't already exist, it is created from the application's model.
//- (NSManagedObjectModel *)managedObjectModel
//{
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"[name]" withExtension:@"momd"];
//    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TipRecord" withExtension:@"momd"];
//    
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CorpsJudge" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//// Returns the persistent store coordinator for the application.
//// If the coordinator doesn't already exist, it is created and the application's store added to it.
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"coredata.sqlite"];
//    
//    NSError *error = nil;
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    
//    
//    //****
//    
//    
//    //********the following line deletes the store
//    //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
//    
//    
//    //****
//    
//    
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        
//        /*
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//         
//         Typical reasons for an error here include:
//         * The persistent store is not accessible;
//         * The schema for the persistent store is incompatible with current managed object model.
//         Check the error message to determine what the actual problem was.
//         
//         
//         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
//         
//         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//         * Simply deleting the existing store:
//         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
//         
//         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
//         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
//         
//         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
//         
//         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//#pragma mark - Application's Documents directory
//
//// Returns the URL to the application's Documents directory.
//- (NSURL *)applicationDocumentsDirectory
//{
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//@end
