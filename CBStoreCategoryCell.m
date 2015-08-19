//
//  CBStoreCategoryCell.m
//  Corpboard
//
//  Created by Justin Moore on 8/17/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBStoreCategoryCell.h"

@implementation CBStoreCategoryCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CBStoreCategoryCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
}

@end
