//
//  CBSingle.m
//  CorpsBoard
//
//  Created by Justin Moore on 6/24/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBSingle.h"
#import "JustinHelper.h"
#import "AppConstant.h"
#import "NSMutableArray+Shuffling.h"
#import "NSDate+Utilities.h"

@implementation CBSingle

+(id)data {
    static CBSingle *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[self alloc] init];
    });
    return data;
}

-(id)init {
    self = [super init];
    if (self) {

        self.updatedAdmin = NO;
        self.updatedShows = NO;
        self.updatedCorps = NO;
        self.updatedBanners = NO;
        //self.currentDate = [NSDate date];
        self.currentDate = [JustinHelper dateWithMonth:1 day:1 year:2015];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(newCoverPhoto)
                                                     name:@"newCoverPhoto" object:nil];
        
    }
    return self;
}

-(void)newCoverPhoto {
    
    PFQuery *adminQuery = [PFQuery queryWithClassName:@"User"];
    [adminQuery whereKey:@"isAdmin" equalTo:[NSNumber numberWithBool:YES]];
    
    // Send the notification.
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:adminQuery];
    [push setMessage:@"New cover photo submitted for approval"];
    [push sendPushInBackground];
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)updateUserLocationAndLastLogin {
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        
        PFUser *user = [PFUser currentUser];
        
        if (!error) {
            CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
            [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark *topResult = [placemarks objectAtIndex:0];
                NSString *loc = [NSString stringWithFormat:@"%@, %@", [topResult locality], [topResult administrativeArea]];
                user[@"location"] = loc;
                user[@"geo"] = geoPoint;
                [user saveEventually];
                [self setParseLocationServices:YES];
            }];
        } else {
            user[@"geo"] = geoPoint;
            [user saveEventually];
        }
    }];
}

-(void)setParseLocationServices:(BOOL)on {
    PFInstallation *install = [PFInstallation currentInstallation];
    BOOL allowsLocation = [install[@"allowsLocation"] boolValue];
    if (allowsLocation != on) {
        install[@"allowsLocation"] = [NSNumber numberWithBool:on];
        [install saveEventually];
    }
}

-(void)setParsePush:(BOOL)on {
    
    PFInstallation *install = [PFInstallation currentInstallation];
    BOOL allowsPush = [install[@"allowsPush"] boolValue];
    if (allowsPush != on) {
        install[@"allowsPush"] = [NSNumber numberWithBool:on];
        [install saveEventually];
    }
}

#pragma mark -
#pragma mark - Data Methods
#pragma mark -
-(void)refreshAdmin {
    
    [self getNumberOfUsers];
    self.updatedAdmin = NO;
    PFQuery *queryAdmin = [PFQuery queryWithClassName:@"admin"];
    [queryAdmin whereKey:@"objectId" equalTo:@"IjplBNRNjj"];
    [queryAdmin findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.objAdmin = objects[0];
            self.updatedAdmin = YES;
            [self didWeFinish];
            if ([delegate respondsToSelector:@selector(adminUpdated)]) {
                [delegate adminUpdated];
            }
        }
    }];
}

-(void)getNumberOfUsers {
    
    PFQuery *queryUsers = [PFQuery queryWithClassName:@"_User"];
    [queryUsers countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error) self.usersTotal = 0;
        else self.usersTotal = number;
    }];
    
    [PFCloud callFunctionInBackground:@"getOnlineUsers"
                       withParameters:@{}
                                block:^(NSArray *userArray, NSError *error) {
                                    if (!error) {
                                        if ([userArray count]) {
                                            self.usersOnline = (int)[userArray count] - 1;
                                        } else self.usersOnline = 0;
                                    } else {
                                        self.usersOnline = 0;
                                    }
                                }];
}

-(void)refreshCorpsAndShows {
    
    if ([delegate respondsToSelector:@selector(dataDidBeginLoading)]) {
        [delegate dataDidBeginLoading];
    }
    [self getAllCorpsFromServer];
    [self getAllShowsFromServer];
    [self getBanners];
}

-(void)getAllCorpsFromServer {
    
    self.updatedCorps = NO;
    self.arrayOfAllCorps = nil;
    self.arrayOfWorldClass = nil;
    self.arrayOfOpenClass = nil;
    
    PFQuery *query = [PFQuery queryWithClassName:@"corps"];
    [query orderByAscending:@"corpsName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            [self.arrayOfAllCorps addObjectsFromArray:objects];
            
            for (PFObject *corps in objects) {
                BOOL active = [corps[@"active"] boolValue];
                if (active) {

                    if ([corps[@"class"] isEqualToString:@"World"]) {
                        
                        [self.arrayOfWorldClass addObject:corps];
                        
                    } else if ([corps[@"class"] isEqualToString:@"Open"]) {
                        
                        [self.arrayOfOpenClass addObject:corps];
                        
                    } else if ([corps[@"class"] isEqualToString:@"All Age"]) {
                        
                        [self.arrayOfAllAgeClass addObject:corps];
                        
                    }
                }
            }
            
            self.updatedCorps = YES;
            [self didWeFinish];
            
        } else {
            
            NSLog(@"Error getting all shows: %@ %@", error, [error userInfo]);
            if ([delegate respondsToSelector:@selector(dataFailed)]) {
                [delegate dataFailed];
            }
        }
    }];
}

-(void)getAllShowsFromServer {
    
    self.updatedShows = NO;
    self.arrayOfAllShows = nil;
    PFQuery *query = [PFQuery queryWithClassName:@"shows"];
    [query includeKey:@"stadium"];
    [query setLimit:1000];
    [query orderByAscending:@"showDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [self.arrayOfAllShows addObjectsFromArray:objects];
            self.updatedShows = YES;
            [self didWeFinish];
        } else {

            NSLog(@"Error getting shows from server: %@ %@", error, [error userInfo]);
            if ([delegate respondsToSelector:@selector(dataFailed)]) {
                [delegate dataFailed];
            }
        }
    }];
}

-(void)didWeFinish {
    
    if ((self.updatedCorps) && (self.updatedShows) && (self.updatedAdmin) && (self.updatedBanners)) {
        
        self.dataLoaded = YES;
        if ([delegate respondsToSelector:@selector(dataDidLoad)]) {

            [delegate dataDidLoad];
        }
        
        
////        //for creating new repertoires
//        PFObject *corps;
//        for (PFObject *obj in self.arrayOfAllCorps) {
//            if ([obj[@"corpsName"] isEqualToString:@"Carolina Gold"]) {
//                corps = obj;
//            }
//        }
//        
//        for (int x = 2001; x < 2015; x++) {
//            PFObject *rep = [PFObject objectWithClassName:@"repertoires"];
//            [rep setObject:corps[@"corpsName"] forKey:@"corpsName"];
//            [rep setObject:[NSNumber numberWithInt:x] forKey:@"year"];
//            //if (x < 1992) [rep setObject:@"Open Class" forKey:@"class"];
//            //if (x > 1991) [rep setObject:@"Division II" forKey:@"class"];
//            //if (x > 2007)
//                [rep setObject:@"All Age Class" forKey:@"class"];
//            [rep setObject:corps forKey:@"corps"];
//            [rep saveInBackground];
//        }
    }
}

// Returns a multidemensional array.
// Index 0 is an NSMutableArray of world class scores
// Index 1 is an NSMutableArray of open class scores
-(NSArray *)getOfficialScoresForShow:(PFObject *)show {
    
    NSArray *returnResults;
    
    PFQuery *query = [PFQuery queryWithClassName:@"scores"];
    [query whereKey:@"show" equalTo:show];
    [query whereKey:@"isOfficial" equalTo:[NSNumber numberWithBool:YES]];
    [query setLimit:1000];
    [query includeKey:@"corps"];
    
    BOOL isShowOver = [show[@"isShowOver"] boolValue];
    if (isShowOver) {
        [query orderByDescending:@"score"];
    } else {
        [query orderByAscending:@"corpsName"];
    }
    
    NSArray *results = [query findObjects];
    
    if ([results count]) {
        NSMutableArray *world = [[NSMutableArray alloc] init];
        NSMutableArray *open = [[NSMutableArray alloc] init];
        NSMutableArray *allage = [[NSMutableArray alloc] init];
        
        for (PFObject *score in results) {
            PFObject *corps = score[@"corps"];
            
            if ([corps[@"class"] isEqualToString:@"World"]) {
                
                [world addObject:score];
                
            } else if ([corps[@"class"] isEqualToString:@"Open"]) {
                
                [open addObject:score];
                
            } else if ([corps[@"class"] isEqualToString:@"All Age"]) {
                
                [allage addObject:score];
                
            }
        }
        
        returnResults = [NSArray arrayWithObjects:world, open, nil];
    }
    
    return returnResults;
}

-(void)getUnreadMessagesForUser {
    
    self.numberOfMessages = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:PF_CHAT_ROOMID containsString:[PFUser currentUser].objectId];
    
    [query whereKey:@"belongsToUser" equalTo:[PFUser currentUser]];
    [query selectKeys:@[@"counter"]];
    [query includeKey:@"user"];
    [query orderByDescending:@"updatedAt"];
    [query setLimit:50];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            for (PFObject *obj in objects) {
                self.numberOfMessages += [obj[@"counter"] intValue];
            }
            if ([delegate respondsToSelector:@selector(messagesUpdated)]) {
                [delegate messagesUpdated];
            }
        } else {
            
            NSLog(@"Error getting new messages.");
        }
    }];
}

-(void)getBanners {
    
    PFQuery *query = [PFQuery queryWithClassName:@"banners"];
    [query whereKey:@"hidden" equalTo:[NSNumber numberWithBool:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // do your thing with text
        if (!error) {
            for (PFObject *obj in objects) {
                PFFile *imageFile = [obj objectForKey:@"image"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        [self.arrayOfBannerImages addObject:image];
                        [self.arrayOfBannerObjects addObject:obj];
                        if ([self.arrayOfBannerImages count] == [objects count]) {
                            
                            self.updatedBanners = YES;
                            [self didWeFinish];
                        }
                    }
                }];
            }
        }
    }];
}

#pragma mark
#pragma mark - Chat Room Subscriptions
#pragma mark

-(void)subscribeToRoom:(NSString *)roomID {
    
    //if they aren't subscribed on parse, makes it so
    if (![self isUserSubsribedToChatRoomOnParse:roomID]) {
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:roomID forKey:@"chatRooms"];
        [currentInstallation saveInBackground];
    }
    
    // now sync it with corpboard
    if (![self isUserSubscribedToChatRoomOnCorpboard:roomID]) {
        [self.arrayOfSubscribedRooms addObject:roomID];
    }

}

-(void)unsubscribeFromRoom:(NSString *)roomID {
 
    //if they are subscribed on parse, removes it
    if ([self isUserSubsribedToChatRoomOnParse:roomID]) {
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation removeObject:roomID forKey:@"chatRooms"];
        [currentInstallation saveInBackground];
    }
    
    // now sync it with corpboard
    if ([self isUserSubscribedToChatRoomOnCorpboard:roomID]) {
        [self.arrayOfSubscribedRooms removeObject:roomID];
    }
}

-(BOOL)isUserSubscribedToChatRoomOnCorpboard:(NSString *)roomID {
    
    for (NSString *room in self.arrayOfSubscribedRooms) {
        if ([room isEqualToString:roomID]) return YES;
    }
    return NO;
}

-(BOOL)isUserSubsribedToChatRoomOnParse:(NSString *)roomID {
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSArray *subscribedChannels = currentInstallation[@"chatRooms"];
    for (NSString *channel in subscribedChannels) {
        if ([channel isEqualToString:roomID]) {
            return YES;
        }
    }
    return NO;
}

-(void)unsubscribeFromAllRooms {
    
    [self.arrayOfSubscribedRooms removeAllObjects];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"chatRooms"] = [NSArray array];
    [currentInstallation saveInBackground];
}

#pragma mark - Properites

-(UIColor *)systemColor {
    return [UIColor colorWithRed:66 green:96 blue:125 alpha:1];
}

-(NSMutableArray *)arrayOfUserWorldClassRankings {
    
    if (!_arrayOfUserWorldClassRankings) {
        _arrayOfUserWorldClassRankings = [[NSMutableArray alloc] init];
    }
    return _arrayOfUserWorldClassRankings;
}

-(NSMutableArray *)arrayOfUserOpenClassRankings {
    
    if (!_arrayOfUserOpenClassRankings) {
        _arrayOfUserOpenClassRankings = [[NSMutableArray alloc] init];
    }
    return _arrayOfUserOpenClassRankings;
}

-(NSMutableArray *)arrayOfUserAllAgeClassRankings {
    
    if (!_arrayOfUserAllAgeClassRankings) {
        _arrayOfUserAllAgeClassRankings = [[NSMutableArray alloc] init];
    }
    return _arrayOfUserAllAgeClassRankings;
}

-(NSMutableArray *)arrayOfAllCorps {
    
    if (!_arrayOfAllCorps) {
        _arrayOfAllCorps = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllCorps;
}

-(NSMutableArray *)arrayOfAllShows {
    
    if (!_arrayOfAllShows) {
        _arrayOfAllShows = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllShows;
}

-(NSMutableArray *)arrayOfWorldClass {
    
    if (!_arrayOfWorldClass) {
        _arrayOfWorldClass = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldClass;
}

-(NSMutableArray *)arrayOfOpenClass {
    
    if (!_arrayOfOpenClass) {
        _arrayOfOpenClass = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenClass;
}

-(NSMutableArray *)arrayOfAllAgeClass {
    
    if (!_arrayOfAllAgeClass) {
        _arrayOfAllAgeClass = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllAgeClass;
}

-(NSMutableArray *)arrayOfWorldHornlineVotes {
    
    if (!_arrayOfWorldHornlineVotes) {
        _arrayOfWorldHornlineVotes = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldHornlineVotes;
}

-(NSMutableArray *)arrayOfOpenHornlineVotes {
    
    if (!_arrayOfOpenHornlineVotes) {
        _arrayOfOpenHornlineVotes = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenHornlineVotes;
}

-(NSMutableArray *)arrayOfAllAgeHornlineVotes {
    
    if (!_arrayOfAllAgeHornlineVotes) {
        _arrayOfAllAgeHornlineVotes = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllAgeHornlineVotes;
}


-(NSMutableArray *)arrayOfWorldPercussionVotes {
    
    if (!_arrayOfWorldPercussionVotes) {
        _arrayOfWorldPercussionVotes = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldPercussionVotes;
}

-(NSMutableArray *)arrayOfOpenPercussionVotes {
    
    if (!_arrayOfOpenPercussionVotes) {
        _arrayOfOpenPercussionVotes = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenPercussionVotes;
}

-(NSMutableArray *)arrayOfAllAgePercussionVotes {
    
    if (!_arrayOfAllAgePercussionVotes) {
        _arrayOfAllAgePercussionVotes = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllAgePercussionVotes;
}

-(NSMutableArray *)arrayOfAllFavorites {
    
    if (!_arrayOfAllFavorites) {
        _arrayOfAllFavorites = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllFavorites;
}

-(NSMutableArray *)arrayofWorldColorguardVotes {
    
    if (!_arrayofWorldColorguardVotes) {
        _arrayofWorldColorguardVotes = [[NSMutableArray alloc] init];
    }
    return _arrayofWorldColorguardVotes;
}

-(NSMutableArray *)arrayofOpenColorguardVotes {
    
    if (!_arrayofOpenColorguardVotes) {
        _arrayofOpenColorguardVotes = [[NSMutableArray alloc] init];
    }
    return _arrayofOpenColorguardVotes;
}

-(NSMutableArray *)arrayofAllAgeColorguardVotes {
    
    if (!_arrayofAllAgeColorguardVotes) {
        _arrayofAllAgeColorguardVotes = [[NSMutableArray alloc] init];
    }
    return _arrayofAllAgeColorguardVotes;
}

-(NSMutableArray *)arrayofWorldLoudestVotes {
    
    if (!_arrayofWorldLoudestVotes) {
        _arrayofWorldLoudestVotes = [[NSMutableArray alloc] init];
    }
    return _arrayofWorldLoudestVotes;
}

-(NSMutableArray *)arrayofOpenLoudestVotes {
    
    if (!_arrayofOpenLoudestVotes) {
        _arrayofOpenLoudestVotes = [[NSMutableArray alloc] init];
    }
    return _arrayofOpenLoudestVotes;
}

-(NSMutableArray *)arrayofAllAgeLoudestVotes {
    
    if (!_arrayofAllAgeLoudestVotes) {
        _arrayofAllAgeLoudestVotes = [[NSMutableArray alloc] init];
    }
    return _arrayofAllAgeLoudestVotes;
}

-(NSMutableArray *)arrayofWorldFavorites {
    
    if (!_arrayofWorldFavorites) {
        _arrayofWorldFavorites = [[NSMutableArray alloc] init];
    }
    return _arrayofWorldFavorites;
}

-(NSMutableArray *)arrayofOpenFavorites {
    
    if (!_arrayofOpenFavorites) {
        _arrayofOpenFavorites = [[NSMutableArray alloc] init];
    }
    return _arrayofOpenFavorites;
}

-(NSMutableArray *)arrayofAllAgeFavorites {
    
    if (!_arrayofAllAgeFavorites) {
        _arrayofAllAgeFavorites = [[NSMutableArray alloc] init];
    }
    return _arrayofAllAgeFavorites;
}

-(NSMutableArray *)arrayOfBannerImages {
    if (!_arrayOfBannerImages) {
        _arrayOfBannerImages = [[NSMutableArray alloc] init];
    }
    return _arrayOfBannerImages;
}

-(NSMutableArray *)arrayOfBannerObjects {
    if (!_arrayOfBannerObjects) {
        _arrayOfBannerObjects = [[NSMutableArray alloc] init];
    }
    return _arrayOfBannerObjects;
}

-(NSMutableArray *)arrayOfSubscribedRooms {
    if (!_arrayOfSubscribedRooms) {
        _arrayOfSubscribedRooms = [[NSMutableArray alloc] init];
    }
    return _arrayOfSubscribedRooms;
}

@end
