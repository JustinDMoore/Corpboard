//
//  CBNews.h
//  CorpBoard
//
//  Created by Justin Moore on 11/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

@interface CBNewsSingleton : NSObject <MWFeedParserDelegate> {
    // Parsing
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    
    // Displaying
    
    NSDateFormatter *formatter;
}

@property (nonatomic, strong) NSArray *itemsToDisplay;
@property (nonatomic) BOOL isNewsLoaded;
@property (nonatomic, strong) NSMutableArray *arrayOfColors;

+(id)news;

@end
