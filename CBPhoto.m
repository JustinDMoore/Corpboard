//
//  CBPhoto.m
//  CorpBoard
//
//  Created by Justin Moore on 2/25/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBPhoto.h"

@implementation CBPhoto

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
       
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

    }
    return self;
}

-(void)setup {
    
    [self.imgView setFile:self.imgFile];
    [self.imgView loadInBackground];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:tap];
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
                             if ([delegate respondsToSelector:@selector(imageClosed)]) {
                                 
                                 [delegate imageClosed];
                             }
                         }];
    }];
    
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent:(CGRect)parent {
    [self setup];
    
    self.frame = CGRectMake(parent.origin.x, parent.origin.y, parent.size.width, parent.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
       
    }];
}

@end
