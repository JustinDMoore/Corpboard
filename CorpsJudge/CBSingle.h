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
-(void)dataDidBeginLoading;
-(void)dataDidLoad;
-(void)dataFailed;
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

@property (nonatomic) BOOL dataLoaded;

+(id)data;
-(void)setDelegate:(id)newDelegate;
-(void)refreshCorpsAndShows;
-(NSArray *)getOfficialScoresForShow:(PFObject *)show ;

@end
