//
//  CBNews.h
//  CorpBoard
//
//  Created by Justin Moore on 11/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CBNewsSingleton : NSObject <NSXMLParserDelegate> {

}

@property (nonatomic, strong) NSXMLParser *parser;

@property (nonatomic, strong) NSMutableString *title;
@property (nonatomic, strong) NSMutableString *link;
@property (nonatomic, strong) NSString *element;
@property (nonatomic, strong) NSMutableString *newsDate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray *arrayOfNews;
@property (nonatomic, strong) NSMutableArray *arrayOfColors;
+(id)news;

@end
