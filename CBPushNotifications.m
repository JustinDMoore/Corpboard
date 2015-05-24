//
//  CBPushNotifications.m
//  Corpboard
//
//  Created by Justin Moore on 5/23/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBPushNotifications.h"

@implementation CBPushNotifications 

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)show {
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.backgroundColor = [UIColor clearColor];
    
    self.btnAllowPush.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnAllowPush.layer.borderWidth = 1;
    self.btnAllowPush.layer.cornerRadius = 5;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self.viewBlur = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    self.viewBlur.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self.parentNav addSubview:self.viewBlur];
    [self.parentNav bringSubviewToFront:self.viewBlur];
    [self.viewBlur addSubview:self];
    [self.parentNav bringSubviewToFront:self];
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:.9
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                         self.center = self.viewBlur.center;
                     } completion:nil];
}


-(void)dismissView:(BOOL)allow {
    
    [UIView animateWithDuration:0.25
                          delay:0.09
         usingSpringWithDamping:1
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.viewBlur.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
                     } completion:^(BOOL finished){
                         
                         [self.viewBlur removeFromSuperview];
                         if (allow) {
                             if ([delegate respondsToSelector:@selector(allowPush)]) {
                                 [delegate allowPush];
                             }
                         } else {
                             if ([delegate respondsToSelector:@selector(denyPush)]) {
                                 [delegate denyPush];
                             }
                         }
                     }];
}

#pragma mark
#pragma mark - Actions
#pragma mark

- (IBAction)btnNotNow_tapped:(id)sender {
    
    [self dismissView:NO];
}

- (IBAction)btnAllowPush_tapped:(id)sender {
    
    [self dismissView:YES];
}

@end
