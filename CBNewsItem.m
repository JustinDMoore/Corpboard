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
        if ([newsTitle isEqualToString:@"Corps news and announcements"]) {
            self.desc = @"The latest news and notes from Drum Corps International's World and Open Class corps";
        } else {
            self.desc = description;
        }
        self.desc = description;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM d"];
        NSString *dateString = [format stringFromDate:newsD];
        self.newsDateString = dateString;
    }
    return self;
}

@end
