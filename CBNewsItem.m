//
//  CBNewsItem.m
//  CorpBoard
//
//  Created by Justin Moore on 11/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNewsItem.h"

@implementation CBNewsItem

-(id)initTitle:(NSString *)newsTitle withLink:(NSString *)newsLink withDate:(NSDate *)newsD {
    if (self == [super init]) {
        self.title = newsTitle;
        self.link = newsLink;
        self.newsDate = newsD;
    }
    return self;
}

@end
