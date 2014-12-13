//
//  CBSingle.h
//  CorpsBoard
//
//  Created by Justin Moore on 6/24/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol dataProtocol <NSObject>
-(void)beganLoadingData;
-(void)finishedLoadingData;


@end

@interface CBSingle : NSObject {
    id delegate;
}

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic) BOOL adminMode;

@property (nonatomic, strong) UIColor *systemColor;

@property (nonatomic, strong) NSMutableArray *arrayOfAllCorps;
@property (nonatomic, strong) NSMutableArray *arrayOfWorldClass;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenClass;

//shows
@property (nonatomic, strong) NSMutableArray *arrayOfAllShows;

//user rankings

@property (nonatomic, strong) NSMutableArray *arrayOfUserWorldClassRankings;
@property (nonatomic, strong) NSMutableArray *arrayOfUserOpenClassRankings;

//user votes
@property (nonatomic, strong) NSMutableArray *arrayOfAllFavorites;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldHornlineVotes;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenHornlineVotes;

@property (nonatomic, strong) NSMutableArray *arrayOfWorldPercussionVotes;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenPercussionVotes;

@property (nonatomic, strong) NSMutableArray *arrayofWorldColorguardVotes;
@property (nonatomic, strong) NSMutableArray *arrayofOpenColorguardVotes;

@property (nonatomic, strong) NSMutableArray *arrayofWorldLoudestVotes;
@property (nonatomic, strong) NSMutableArray *arrayofOpenLoudestVotes;

@property (nonatomic, strong) NSMutableArray *arrayofWorldFavorites;
@property (nonatomic, strong) NSMutableArray *arrayofOpenFavorites;

@property BOOL updatedCorps;
@property BOOL updatedShows;

+(id)data;
-(void)setDelegate:(id)newDelegate;
-(void)getAllCorpsFromServer;
-(void)getAllShowsFromServer;
-(NSArray *)getOfficialScoresForShow:(PFObject *)show ;

@end