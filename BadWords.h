//
//  BadWords.h
//  CorpBoard
//
//  Created by Justin Moore on 11/25/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadWords : NSObject
@property (nonatomic, strong) NSArray *arrayOfBadWords;
-(BOOL)stringContainsExplicit:(NSString *)text;
@end
