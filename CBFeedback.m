//
//  CBFeedback.m
//  CorpBoard
//
//  Created by Justin Moore on 5/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBFeedback.h"

@implementation CBFeedback

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 6;
        self.tableFeedback.canCancelContentTouches = YES;
        self.tableFeedback.delegate = self;
        self.tableFeedback.dataSource = self;
        
        // Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.y"
         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        // Add both effects to your view
        [self addMotionEffect:group];
        
        self.alpha = 0;
    }
    return self;
}

- (IBAction)btnCancel_tapped:(id)sender {
    
    [self closeView];
}


-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent:(CGRect)parent {

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    self.frame = CGRectMake(CGRectGetMidX(screenRect) - (screenSize.width - 100) / 2, CGRectGetMidY(screenRect) - (self.frame.size.height / 2), screenSize.width - 100, self.frame.size.height);
    //self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2), CGRectGetMidY(parent) - (self.frame.size.height / 2), self.frame.size.width, self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    self.alpha = 0;
    
    [UIView animateWithDuration:.2 delay:.5 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)closeView {
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
                             if ([delegate respondsToSelector:@selector(cancelled)]) {
                                 [delegate cancelled];
                             }
                         }];
    }];
}

@end
