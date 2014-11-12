//
//  JustinHelper.m
//  CorpsJudge
//
//  Created by Justin Moore on 6/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "JustinHelper.h"

@implementation JustinHelper

+(NSDate*)dateWithMonth:(NSInteger)month
                    day:(NSInteger)day
                   year:(NSInteger)year {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:gregorian];
    [dateComps setMonth:month];
    [dateComps setDay:day];
    [dateComps setYear:year];
    
    NSDate *newDate = [dateComps date];
    
    return newDate;
}


// Takes a string and returns whether or not it is a valid email format
+(BOOL) StringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
