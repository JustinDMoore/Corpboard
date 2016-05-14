//
//  Configuration.h
//  CorpsJudge
//
//  Created by Justin Moore on 6/18/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "JustinHelper.h"
#import <KVNProgress/KVNProgress.h>

@interface Configuration : NSObject

@property (nonatomic, strong) NSMutableArray *arrayOfCorpsObjects;
-(void)createAllShowsAndEmptyScores;
-(void)createAllCorps;
-(void)getAllCorps;
-(PFObject *)getCorpsByName:(NSString *)name;
+(KVNProgressConfiguration *)standardProgressConfig;
+(KVNProgressConfiguration *)errorProgressConfig;

@end
