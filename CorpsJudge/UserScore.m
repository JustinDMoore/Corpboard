//
//  UserScore.m
//  CorpsJudge
//
//  Created by Isaias Favela on 6/24/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "UserScore.h"

@implementation UserScore

-(void)setScore:(double)score {
    
    _score = score;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumIntegerDigits:2];
    
    _scoreString = [formatter stringFromNumber:[NSNumber numberWithDouble:score]];
}

@end
