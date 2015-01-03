//
//  CBNewsItem.m
//  CorpBoard
//
//  Created by Justin Moore on 11/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNewsItem.h"

@implementation CBNewsItem

-(id)initTitle:(NSString *)newsTitle withDescription:(NSString *)description withLink:(NSString *)newsLink withDate:(NSDate *)newsD {
    if (self == [super init]) {
        self.title = newsTitle;
        self.link = newsLink;
        self.newsDate = newsD;
        self.desc = description;
    }
    return self;
}

@end
