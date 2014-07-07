//
//  CSSingle.m
//  CorpsJudge
//
//  Created by Justin Moore on 6/24/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CSSingle.h"


@implementation CSSingle

+(id)data {
    static CSSingle *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[self alloc] init];
    });
    return data;
}

-(id)init {
    self = [super init];
    if (self) {
        self.updatedShows = NO;
        self.updatedCorps = NO;
    }
    return self;
}

#pragma mark - Parse methods

-(void)getAllCorpsFromServer {
    
    self.updatedCorps = NO;
    self.arrayOfAllCorps = nil;
    PFQuery *query = [PFQuery queryWithClassName:@"corps"];
    [query orderByDescending:@"corpsName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            [self.arrayOfAllCorps addObjectsFromArray:objects];
            
            for (PFObject *corps in objects) {
                BOOL isWorld = [corps[@"isWorldClass"] boolValue];
                if (isWorld) [self.arrayOfWorldClass addObject:corps];
                else [self.arrayOfOpenClass addObject:corps];
            }
            
            self.updatedCorps = YES;
        } else {
            
            NSLog(@"Error getting all shows: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)getAllShowsFromServer {
    
    self.updatedShows = NO;
    self.arrayOfAllShows = nil;
    PFQuery *query = [PFQuery queryWithClassName:@"shows"];
    [query setLimit:1000];
    [query orderByAscending:@"showDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [self.arrayOfAllShows addObjectsFromArray:objects];
            self.updatedShows = YES;
        } else {

            NSLog(@"Error getting shows from server: %@ %@", error, [error userInfo]);
        }
    }];
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
        
        for (PFObject *score in results) {
            PFObject *corps = score[@"corps"];
            BOOL isWorld = [corps[@"isWorldClass"] boolValue];
            if (isWorld) {
                [world addObject:score];
            } else {
                [open addObject:score];
            }
        }
        
        returnResults = [NSArray arrayWithObjects:world, open, nil];
    }
    
    return returnResults;
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


@end
