//
//  CBProblemWhere.m
//  CorpBoard
//
//  Created by Isaias Favela on 1/4/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBProblemWhere.h"

@implementation CBProblemWhere


-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.arrayOfProblemAreas = @[@"About the Corps", @"Ads", @"Chat or Messages", @"CorpRankings", @"Friends or Profiles", @"News", @"Shows", @"Show Reviews", @"Other"];
    }
    return self;
}

-(NSArray *)arrayOfProblemAreas {
    if (!_arrayOfProblemAreas) {
        _arrayOfProblemAreas = [NSArray array];
    }
                                return _arrayOfProblemAreas;
}
@end
