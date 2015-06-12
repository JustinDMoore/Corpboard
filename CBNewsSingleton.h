//
//  CBNews.h
//  CorpBoard
//
//  Created by Justin Moore on 11/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"
#import "CBSingle.h"

@protocol newsProtocol <NSObject>
-(void)newsDidLoad;
@end

@interface CBNewsSingleton : NSObject <MWFeedParserDelegate, dataProtocol> {
    // Parsing
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    
    // Displaying
    
    NSDateFormatter *formatter;
    id delegate;
}

@property (nonatomic, strong) NSArray *arrayOfNewsItemsToDisplay;
@property (nonatomic) BOOL newsLoaded;
@property (nonatomic, strong) NSMutableArray *arrayOfColors;

+(id)news;
-(void)setDelegate:(id)newDelegate;
+(NSString *)dateForNews:(NSDate *)newsDate;

@end
