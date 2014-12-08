//
//  CBNews.m
//  CorpBoard
//
//  Created by Justin Moore on 11/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNewsSingleton.h"
#import "CBNewsItem.h"
#import "NSDate+InternetDateTime.h"
#import "NSString+HTML.h"

@implementation CBNewsSingleton {
   
}

+(id)news {
    static CBNewsSingleton *news = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        news = [[self alloc] init];
    });
    return news;
}

-(id)init {
    self = [super init];
    if (self) {
        self.arrayOfColors = [[NSMutableArray alloc] init];
        for (int i = 0; i < 17; i++) {
            [self.arrayOfColors addObject:[NSNumber numberWithInt:i]];
        }
        [self shuffle];
        
        //rss setup
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        parsedItems = [[NSMutableArray alloc] init];
        self.itemsToDisplay = [NSArray array];
        
        
        self.isNewsLoaded = NO;
        NSURL *feedURL = [NSURL URLWithString:@"http://www.dci.org/news/rss/news_rss.xml"];
        feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        feedParser.delegate = self;
        feedParser.feedParseType = ParseTypeFull;
        // TODO: play with this synchronous stuff
        feedParser.connectionType = ConnectionTypeAsynchronously;
        [feedParser parse];
        
    }
    return self;
}

#pragma mark -
#pragma mark Parsing

- (void)refresh {
    [parsedItems removeAllObjects];
    [feedParser stopParsing];
    [feedParser parse];
}

- (void)updateTableWithParsedItems {
    
    self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                ascending:NO]]];
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
   // NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    //NSLog(@"Parsed Feed Info: “%@”", info.title);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    //NSLog(@"Parsed Feed Item: “%@”", item.title);
    if (item) [parsedItems addObject:item];
}

-(void)feedParserDidFinish:(MWFeedParser *)parser {
    
    //NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
   [self updateTableWithParsedItems];
    self.isNewsLoaded = YES;
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    //NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
         // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}

- (void)shuffle
{
    NSUInteger count = [self.arrayOfColors count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.arrayOfColors exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}


@end
