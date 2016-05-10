//
//  CBNewsView.m
//  CorpBoard
//
//  Created by Justin Moore on 11/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNewsView.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "CBNewsSingleton.h"
#import "NSDate+Utilities.h"


@implementation CBNewsView

//-(id)initWithDate:(NSDate *)date title:(NSString *)title link:(NSString *)link {
//    if (self = [super init]) {
//        
//        news = [CBNewsSingleton news];
//        self.frame = CGRectMake(0, 0, 205, 100);
//        self.layer.cornerRadius = 8;
//        self.backgroundColor = [UIColor redColor];
//        self.title = title;
//        self.link = link;
//        
//        self.date = date;
//        
//        NSString *dateString = @"";
//        int diff = (int)[date minutesBeforeDate:[NSDate date]];
//        if (diff < 5) {
//            dateString = @"Just Now";
//        } else if (diff <= 50) {
//            dateString = [NSString stringWithFormat:@"%i min ago", diff];
//        } else if ((diff > 50) && (diff < 65)) {
//            dateString = @"An hour ago";
//        } else {
//            if ([date isYesterday]) {
//                dateString = @"Yesterday";
//            }
//            if ([date daysBeforeDate:[NSDate date]] == 2) {
//                dateString = @"2 days ago";
//            } else {
//                if ([date isToday]) {
//                    int hours = (int)[date hoursBeforeDate:[NSDate date]];
//                    dateString = [NSString stringWithFormat:@"%i hours ago", hours];
//                } else {
//                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                    [format setDateFormat:@"MMMM d"];
//                    
//                    dateString = [format stringFromDate:date];
//                }
//            }
//        }
//    
//    self.dateString = dateString;
//    [self createLabels];
//       
//    }
//    return self;
//}
//
//-(void)createLabels {
//    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 190, 21)];
//    self.dateLabel.font = [UIFont boldSystemFontOfSize:12];
//    self.dateLabel.text = self.dateString;
//    self.dateLabel.textColor = [UIColor lightGrayColor];
//    [self.dateLabel sizeToFit];
//    [self addSubview:self.dateLabel];
//    
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height + 3, 190, 60)];
//    self.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.titleLabel.text = self.title;
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.numberOfLines = 3;
//    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [self.titleLabel sizeToFit];
//    [self addSubview:self.titleLabel];
//    
//    self.imgFrom = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 35, self.frame.size.height - 25, 30, 21)];
//    self.imgFrom.image = [UIImage imageNamed:@"DCI_small"];
//    [self addSubview:self.imgFrom];
//    
//    self.lblFrom = [[UILabel alloc] initWithFrame:CGRectMake(self.imgFrom.frame.origin.x + 3, self.frame.size.height - 17, 190, 21)];
//    self.lblFrom.font = [UIFont systemFontOfSize:10];
//    self.lblFrom.text = @"";
//    self.lblFrom.textColor = [UIColor blueColor];
//    [self.lblFrom sizeToFit];
//    [self addSubview:self.lblFrom];
//}
//
//
//-(void)createBackground {
//
//   // int rndValue = 0 + arc4random_uniform(9 - 0 + 1);
//    //rndValue = 16;
//    switch ([self.colorNumber intValue]) {
//        case 0:
//            self.backgroundColor = [self getRGB1:189 two:38 three:133];
//            break;
//        case 1:
//            self.backgroundColor = [self getRGB1:65 two:11 three:97];
//            break;
//        case 2:
//            self.backgroundColor = [self getRGB1:217 two:48 three:51];
//            break;
//        case 3:
//            self.backgroundColor = [UIColor whiteColor];
//            self.layer.borderColor = (__bridge CGColorRef)([UIColor grayColor]);
//            self.titleLabel.textColor = [UIColor blackColor];
//            self.dateLabel.textColor = [UIColor lightGrayColor];
//            break;
//        case 4:
//            self.backgroundColor = [self getRGB1:252 two:61 three:77];
//            break;
//        case 5:
//
//            [self makeGradientWithOne:[self getRGB1:43 two:110 three:61] Two:[self getRGB1:168 two:201 three:48]];
//            
//            break;
//        case 6:
//            
//            [self makeGradientWithOne:[self getRGB1:76 two:33 three:82] Two:[self getRGB1:171 two:32 three:159]];
//            
//            break;
//            
//        case 7:
//            
//            [self makeGradientWithOne:[self getRGB1:30 two:38 three:77] Two:[self getRGB1:118 two:134 three:184]];
//            
//            break;
//            
//        case 8:
//            vertical = YES;
//            [self makeGradientWithOne:[self getRGB1:34 two:102 three:240] Two:[self getRGB1:53 two:219 three:252]];
//            
//            break;
//            
//        case 9:
//           
//            [self makeGradientWithOne:[self getRGB1:159 two:121 three:247] Two:[self getRGB1:61 two:58 three:240]];
//            
//            break;
//            
//        case 10:
//            
//            [self makeGradientWithOne:[self getRGB1:0 two:135 three:126] Two:[self getRGB1:0 two:194 three:145]];
//            
//            break;
//        case 11:
//            self.backgroundColor = [self getRGB1:54 two:54 three:54];
//            break;
//        case 12:
//            
//            [self makeGradientWithOne:[self getRGB1:214 two:68 three:19] Two:[self getRGB1:235 two:112 three:68]];
//            
//            break;
//        case 13:
//            
//            [self makeGradientWithOne:[self getRGB1:75 two:41 three:179] Two:[self getRGB1:109 two:61 three:252]];
//            
//            break;
//            
//        case 14:
//            
//            [self makeGradientWithOne:[self getRGB1:128 two:116 three:105] Two:[self getRGB1:171 two:163 three:140]];
//            
//            break;
//            
//        case 15:
//            
//            [self makeGradientWithOne:[self getRGB1:31 two:26 three:22] Two:[self getRGB1:54 two:47 three:41]];
//            vertical = YES;
//            self.titleLabel.textColor = [UIColor whiteColor];
//            self.dateLabel.textColor = [UIColor lightGrayColor];
//            
//            break;
//        case 16:
//            self.backgroundColor = [self getRGB1:255 two:34 three:0];
//            self.titleLabel.textColor = [UIColor blackColor];
//            self.dateLabel.textColor = [UIColor lightGrayColor];
//            break;
//        default:
//            break;
//    }
//    
//}
//bool vertical = NO;
//-(void)makeGradientWithOne:(UIColor *)one Two:(UIColor *)two {
//    self.backgroundColor = [UIColor clearColor];
//    CAGradientLayer *gradient;
//    gradient = [CAGradientLayer layer];
//    gradient.frame = self.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[one CGColor], (id)[two CGColor], nil];
//    gradient.cornerRadius = 8;
//    
//    if (vertical) {
//        [gradient setStartPoint:CGPointMake(0.0, 0.5)];
//        [gradient setEndPoint:CGPointMake(1.0, 0.5)];
//    }
//    
//    [self.layer insertSublayer:gradient atIndex:0];
//    
//}
//
//-(UIColor *)getRGB1:(CGFloat)red two:(CGFloat)green three:(CGFloat)blue {
//    
//    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:1];
//}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/

@end
