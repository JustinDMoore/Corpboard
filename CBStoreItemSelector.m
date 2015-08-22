//
//  CBStoreItemSelector.m
//  Corpboard
//
//  Created by Justin Moore on 8/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBStoreItemSelector.h"


@implementation CBStoreItemSelector

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)showInParentWithSelectorType:(selectType)type {
    
    switch (type) {
        case SIZE: self.lblTitle.text = @"PICK A SIZE";
            break;
        case COLOR: self.lblTitle.text = @"PICK A COLOR";
            break;
        case QUANTITY: self.lblTitle.text = @"PICK A QUANTITY";
            break;
        default:
            break;
    }
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2);
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - ([UIScreen mainScreen].bounds.size.height / 2), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2);
        
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)closeView:(BOOL)cancelled {
    if ([delegate respondsToSelector:@selector(selectorWillClose)]) {
        [delegate selectorWillClose];
    }
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:8 options:0 animations:^{
        
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([delegate respondsToSelector:@selector(selectorDidClose)]) {
            [delegate selectorDidClose];
        }
    }];
}

- (IBAction)btnClose:(id)sender {
    [self closeView:NO];
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}
@end
