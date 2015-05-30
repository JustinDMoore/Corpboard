//
//  CBNewsCell.m
//  CorpBoard
//
//  Created by Justin Moore on 2/2/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBNewsCell.h"

@implementation CBNewsCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CBNewsCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self.layer.cornerRadius = 8;
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
}

-(void)setColorNumber:(int)colorNumber {
    
    //_colorNumber = 16;
    _colorNumber = colorNumber;
    [self createBackground];
}

-(void)createBackground {

    
    switch (self.colorNumber) {
        case 0:
            self.backgroundColor = [self getRGB1:189 two:38 three:133];
            break;
        case 1:
            self.backgroundColor = [self getRGB1:65 two:11 three:97];
            break;
        case 2:
            self.backgroundColor = [self getRGB1:217 two:48 three:51];
            break;
        case 3:
            self.backgroundColor = [UIColor whiteColor];
            self.layer.borderColor = (__bridge CGColorRef)([UIColor grayColor]);
            self.lblTitle.textColor = [UIColor blackColor];
            self.lblDate.textColor = [UIColor lightGrayColor];
            break;
        case 4:
            self.backgroundColor = [self getRGB1:252 two:61 three:77];
            break;
        case 5:
            
            [self makeGradientWithOne:[self getRGB1:43 two:110 three:61] Two:[self getRGB1:168 two:201 three:48]];
            
            break;
        case 6:
            
            [self makeGradientWithOne:[self getRGB1:76 two:33 three:82] Two:[self getRGB1:171 two:32 three:159]];
            
            break;
            
        case 7:
            
            [self makeGradientWithOne:[self getRGB1:30 two:38 three:77] Two:[self getRGB1:118 two:134 three:184]];
            
            break;
            
        case 8:
            vertical = YES;
            [self makeGradientWithOne:[self getRGB1:34 two:102 three:240] Two:[self getRGB1:53 two:219 three:252]];
            
            break;
            
        case 9:
            
            [self makeGradientWithOne:[self getRGB1:159 two:121 three:247] Two:[self getRGB1:61 two:58 three:240]];
            
            break;
            
        case 10:
            
            [self makeGradientWithOne:[self getRGB1:0 two:135 three:126] Two:[self getRGB1:0 two:194 three:145]];
            
            break;
        case 11:
            self.backgroundColor = [self getRGB1:54 two:54 three:54];
            break;
        case 12:
            
            [self makeGradientWithOne:[self getRGB1:214 two:68 three:19] Two:[self getRGB1:235 two:112 three:68]];
            
            break;
        case 13:
            
            [self makeGradientWithOne:[self getRGB1:75 two:41 three:179] Two:[self getRGB1:109 two:61 three:252]];
            
            break;
            
        case 14:
            
            [self makeGradientWithOne:[self getRGB1:128 two:116 three:105] Two:[self getRGB1:171 two:163 three:140]];
            
            break;
            
        case 15:
            
            [self makeGradientWithOne:[self getRGB1:31 two:26 three:22] Two:[self getRGB1:54 two:47 three:41]];
            vertical = YES;
            self.lblTitle.textColor = [UIColor whiteColor];
            self.lblDate.textColor = [UIColor lightGrayColor];
            
            break;
        case 16:
            self.backgroundColor = [self getRGB1:255 two:34 three:0];
            self.lblTitle.textColor = [UIColor whiteColor];
            self.lblDate.textColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
}

bool vertical = NO;
-(void)makeGradientWithOne:(UIColor *)one Two:(UIColor *)two {
    self.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient;
    gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[one CGColor], (id)[two CGColor], nil];
    gradient.cornerRadius = 8;
    
    if (vertical) {
        [gradient setStartPoint:CGPointMake(0.0, 0.5)];
        [gradient setEndPoint:CGPointMake(1.0, 0.5)];
    }
    
    [self.layer insertSublayer:gradient atIndex:0];
    
}

-(UIColor *)getRGB1:(CGFloat)red two:(CGFloat)green three:(CGFloat)blue {
    
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:1];
}


@end
