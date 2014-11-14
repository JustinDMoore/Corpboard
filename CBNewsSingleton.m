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

@implementation CBNewsSingleton

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
        
        self.arrayOfNews = [[NSMutableArray alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://www.dci.org/news/rss/news_rss.xml"];
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        
        [self.parser setDelegate:self];
        [self.parser setShouldResolveExternalEntities:NO];
        [self.parser parse];
    }
    return self;
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

// delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    self.element = elementName;
    
    if ([self.element isEqualToString:@"item"]) {
        
        self.title   = [[NSMutableString alloc] init];
        self.link    = [[NSMutableString alloc] init];
        self.newsDate = [[NSMutableString alloc] init];
        self.desc = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([self.element isEqualToString:@"title"]) {
        [self.title appendString:string];
    } else if ([self.element isEqualToString:@"link"]) {
        [self.link appendString:string];
    } else if ([self.element isEqualToString:@"news_date"]) {
        [self.newsDate appendString:string];
    } else if ([self.element isEqualToString:@"description"]) {
        [self.desc appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM d"];
        NSDate *date = [[NSDate alloc] init];
        date = [dateFormatter dateFromString:self.newsDate];
        NSLog(@"DateObject : %@", date);

        CBNewsItem *newsItem = [[CBNewsItem alloc] initTitle:self.title withDescription:self.desc withLink:self.link withDate:self.newsDate];
        [self.arrayOfNews addObject:newsItem];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    

}

@end
