////
////  CBNews.m
////  CorpBoard
////
////  Created by Justin Moore on 11/13/14.
////  Copyright (c) 2014 Justin Moore. All rights reserved.
////
//
//#import "CBNewsSingleton.h"
//#import "CBNewsItem.h"
//#import "NSDate+InternetDateTime.h"
//#import "NSString+HTML.h"
//#import "NSDate+Utilities.h"
//#import "Corpsboard-Swift.h"
//
//Server *server;
//
//@implementation CBNewsSingleton {
//   
//}
////
////
////
////+(id)news {
////    static CBNewsSingleton *news = nil;
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
////        news = [[self alloc] init];
////        server = [Server sharedInstance];
////    });
////    return news;
////}
////
////-(id)init {
////    self = [super init];
////    if (self) {
////        //[data setDelegate:self];
////        self.arrayOfColors = [[NSMutableArray alloc] init];
////        for (int i = 0; i < 17; i++) {
////            [self.arrayOfColors addObject:[NSNumber numberWithInt:i]];
////        }
////        [self shuffle];
////    }
////    return self;
////}
////
////-(void)beginUpdatingNewsWithURL:(NSString *)URL {
////    //rss setup
////    formatter = [[NSDateFormatter alloc] init];
////    [formatter setDateStyle:NSDateFormatterShortStyle];
////    [formatter setTimeStyle:NSDateFormatterShortStyle];
////    parsedItems = [[NSMutableArray alloc] init];
////    self.arrayOfNewsItemsToDisplay = [NSArray array];
////    
////    self.newsLoaded = NO;
////    NSURL *feedURL = [NSURL URLWithString:URL];
////    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
////    feedParser.delegate = self;
////    feedParser.feedParseType = ParseTypeFull;
////    // TODO: play with this synchronous stuff
////    feedParser.connectionType = ConnectionTypeAsynchronously;
////    [feedParser parse];
////    
////}
////
////-(void)setDelegate:(id)newDelegate{
////    delegate = newDelegate;
////}
////
////#pragma mark -
////#pragma mark Parsing
////
////- (void)refresh {
////    [parsedItems removeAllObjects];
////    [feedParser stopParsing];
////    [feedParser parse];
////}
////
////- (void)updateTableWithParsedItems {
////    
////    self.arrayOfNewsItemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
////                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
////                                                                                ascending:NO]]];
////}
//
////#pragma mark -
////#pragma mark MWFeedParserDelegate
////
////- (void)feedParserDidStart:(MWFeedParser *)parser {
////   NSLog(@"Started Parsing: %@", parser.url);
////}
////
////- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
////    
////    NSLog(@"Parsed Feed Info: “%@”", info.title);
////}
////
////- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
////    //NSLog(@"Parsed Feed Item: “%@”", item.title);
////    if (item) [parsedItems addObject:item];
////    NSLog(@"%@", item.description);
////}
////
////-(void)feedParserDidFinish:(MWFeedParser *)parser {
////    
////    //NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
////   [self updateTableWithParsedItems];
////    self.newsLoaded = YES;
////    if ([delegate respondsToSelector:@selector(newsDidLoad)]) {
////        [delegate newsDidLoad];
////    }
////}
////
////- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
////    NSLog(@"Finished Parsing With Error: %@", error);
////    if (parsedItems.count == 0) {
////         // Show failed message in title
////    } else {
////        // Failed but some items parsed, so show and inform of error
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
////                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
////                                                       delegate:nil
////                                              cancelButtonTitle:@"Dismiss"
////                                              otherButtonTitles:nil];
////        [alert show];
////    }
////    [self updateTableWithParsedItems];
////}
////
////- (void)shuffle
////{
////    NSUInteger count = [self.arrayOfColors count];
////    for (NSUInteger i = 0; i < count; ++i) {
////        NSInteger remainingCount = count - i;
////        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
////        [self.arrayOfColors exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
////    }
////}
////
////+(NSString *)dateForNews:(NSDate *)newsDate {
////    
////    NSString *result = @"";
////    
////    if (newsDate) {
////        int diff = (int)[newsDate minutesBeforeDate:[NSDate date]];
////        if (diff < 5) {
////            return @"Just Now";
////        } else if (diff <= 50) {
////            return [NSString stringWithFormat:@"%i min ago", diff];
////        } else if ((diff > 50) && (diff < 65)) {
////            return @"An hour ago";
////        } else {
////            if ([newsDate isYesterday]) {
////                return @"Yesterday";
////            }
////            if ([newsDate daysBeforeDate:[NSDate date]] == 2) {
////                return @"2 days ago";
////            } else {
////                if ([newsDate isToday]) {
////                    int hours = (int)[newsDate hoursBeforeDate:[NSDate date]];
////                    return [NSString stringWithFormat:@"%i hours ago", hours];
////                } else {
////                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
////                    [format setDateFormat:@"MMMM d"];
////                    
////                    return [format stringFromDate:newsDate];
////                }
////            }
////        }
////    }
////    
////    return result;
////}
//
//@end
