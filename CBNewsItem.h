//
//  CBNewsItem.h
//  CorpBoard
//
//  Created by Justin Moore on 11/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBNewsItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSDate *newsDate;
@property (nonatomic, strong) NSString *newsDateString;

-(id)initTitle:(NSString *)newsTitle withDescription:(NSString *)description withLink:(NSString *)newsLink withDate:(NSDate *)newsD;

@end
