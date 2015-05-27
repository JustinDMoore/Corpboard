//
//  CBReviewAttendance.m
//  Corpboard
//
//  Created by Justin Moore on 5/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBReviewAttendance.h"

@implementation CBReviewAttendance

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 6;
        
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

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent:(CGRect)parent {
    
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    self.alpha = 0;
    
    self.center = [self.superview convertPoint:self.superview.center fromView:self.superview.superview];
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
        self.center = [self.superview convertPoint:self.superview.center fromView:self.superview.superview];
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)closeView:(BOOL)attendend {
    
    if (!attendend) {
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
                                 if ([delegate respondsToSelector:@selector(userAttended:)]) {
                                     [delegate userAttended:attendend];
                                 }
                             }];
        }];
    } else {
        if ([delegate respondsToSelector:@selector(userAttended:)]) {
            [delegate userAttended:attendend];
        }
    }
}

- (IBAction)btnYes_tapped:(id)sender {
    [self closeView:YES];
}

- (IBAction)btnNo_tapped:(id)sender {
    
    [self closeView:NO];
}

@end
