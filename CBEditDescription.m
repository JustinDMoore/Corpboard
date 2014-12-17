//
//  CBEditDescription.m
//  CorpBoard
//
//  Created by Justin Moore on 12/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBEditDescription.h"

@implementation CBEditDescription

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
        
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

-(void)showInParent:(CGRect)parent {
    
    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2), CGRectGetMidY(parent) - (self.frame.size.height / 1.1), self.frame.size.width, self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        

        if ([[PFUser currentUser][@"background"] length]) {
            self.txtDescription.text = [PFUser currentUser][@"background"];
        } else {
            self.txtDescription.placeholder = @"Tell us about yourself";
            self.txtDescription.placeholderColor = [UIColor lightGrayColor];
            self.txtDescription.textColor = [UIColor blackColor];
        }
        [self.txtDescription becomeFirstResponder];
        
    }];
}


-(void)closeView:(BOOL)cancelled {
    [self.txtDescription resignFirstResponder];
    
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
                             if (!cancelled) {
                                 [delegate savedDescription];
                             } else {
                                 [delegate cancelledDescription];
                             }
                             
                         }];
    }];
    
}

- (IBAction)btn_Cancel:(id)sender {
    
    [self closeView:YES];
}

- (IBAction)btnSave:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    user[@"background"] = self.txtDescription.text;
    [user saveInBackground];
    [self closeView:NO];
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

@end
