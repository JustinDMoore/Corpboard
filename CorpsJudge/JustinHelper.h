//
//  JustinHelper.h
//  CorpsJudge
//
//  Created by Justin Moore on 6/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JustinHelper : NSObject

+(NSDate*)dateWithMonth:(NSInteger)month
                    day:(NSInteger)day
                   year:(NSInteger)year;

+(BOOL) StringIsValidEmail:(NSString *)checkString;

@end
