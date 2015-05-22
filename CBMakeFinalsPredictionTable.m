//
//  CBMakeFinalsPredictionTable.m
//  CorpBoard
//
//  Created by Justin Moore on 5/20/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBMakeFinalsPredictionTable.h"

@implementation CBMakeFinalsPredictionTable

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 6;
        self.tableCorps.canCancelContentTouches = YES;
        
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

-(void)reload {
    
    self.tableCorps.alpha = 0;
    [self.tableCorps reloadData];
    [self.tableCorps scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         self.tableCorps.alpha = 1;
                         [self.tableCorps scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                     } completion:nil];
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)show {
    
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
                             if ([delegate respondsToSelector:@selector(predictionClosed)]) {
                                 [delegate predictionClosed];
                             }
                         }];
    }];
}

- (IBAction)btnSend_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(predictionNext)]) {
        [delegate predictionNext];
    }
}

- (IBAction)btnCancel_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(predictionBackTapped)]) {
        [delegate predictionBackTapped];
    }
}

@end
