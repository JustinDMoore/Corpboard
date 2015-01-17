//
//  UserScore.h
//  CorpsJudge
//
//  Created by Isaias Favela on 6/24/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserScore : NSObject
@property (nonatomic, strong) PFObject *corps;
@property (nonatomic) double score;
@property (nonatomic, strong) NSString *scoreString;
@end
