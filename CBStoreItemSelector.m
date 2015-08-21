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

-(void)showInParent:(CGRect)parent {
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height / 4, [UIScreen mainScreen].bounds.size.width);
    
//    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
//        
//        self.transform = CGAffineTransformIdentity;
//        
//    } completion:^(BOOL finished) {
//        
//        
//    }];
}

-(void)closeView:(BOOL)cancelled {
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:8 options:0 animations:^{
        
        self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:8
                            options:0
                         animations:^{
                             self.transform = CGAffineTransformScale(self.transform, 0.1f, 0.1f);
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             //[delegate corpExperienceUpdated];
                         }];
    }];
    
}

- (IBAction)btnClose:(id)sender {
    [self closeView:NO];
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}
@end
