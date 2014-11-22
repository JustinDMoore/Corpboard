//
//  ParseErrors.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "ParseErrors.h"

@implementation ParseErrors
+(NSString *)getErrorStringForCode:(NSInteger)code {
    NSString *string;
    
    switch (code) {
        case 1: string = @"The server is temporarily undergoing maintenance. Please try again later"; break;
        case 101: string = @"Incorrect email address or password."; break;
        case 100: string = @"Unable to connect to the server. This could be caused by a network error."; break;
        case 202: string = @"This username is already taken. If this is you, please select LOG INTO EXISTING ACCOUNT from the main menu."; break;
        case 203: string = @"This username is already taken. If this is you, please select LOG INTO EXISTING ACCOUNT from the main menu."; break;
        default: string = @"An unknown error has occurred."; break;
    }
    
    return string;
}
@end
