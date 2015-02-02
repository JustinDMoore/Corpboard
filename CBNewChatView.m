//
//  CBNewChatView.m
//  CorpBoard
//
//  Created by Justin Moore on 2/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBNewChatView.h"

@implementation CBNewChatView {
    CGRect parentRect;
}


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
        
        [self setup];
    }
    return self;
}

-(void)setup {
    
    [self.txtTopic.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.txtTopic setBackgroundColor:[UIColor clearColor]];
    [self.txtTopic.layer setBorderWidth:1.0];
    self.txtTopic.layer.cornerRadius = 5;
    self.txtTopic.clipsToBounds = YES;
    
    [self.txtMessage.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.txtMessage setBackgroundColor:[UIColor clearColor]];
    [self.txtMessage.layer setBorderWidth:1.0];
    self.txtMessage.layer.cornerRadius = 5;
    self.txtMessage.clipsToBounds = YES;
    
    self.txtTopic.placeholder = @"Topic";
    self.txtMessage.placeholder = @"Message";
    
    self.txtTopic.delegate = self;
    self.txtMessage.delegate = self;
}

- (IBAction)btnStartChat_tapped:(id)sender {
    
    if ([self.txtTopic.text length] && [self.txtMessage.text length]) {
        [self closeView:NO];
    }
}

- (IBAction)btnCancel_tapped:(id)sender {
    
    [self closeView:YES];
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent:(CGRect)parent {
    [self setup];
    parentRect = parent;
    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2),
                            20,
                            self.frame.size.width,
                            self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [self.txtTopic becomeFirstResponder];
    }];
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
                             if (!cancelled) {
                                 if ([delegate respondsToSelector:@selector(newChatWithTopic:withMessage:)]) {
                                     [delegate newChatWithTopic:self.txtTopic.text withMessage:self.txtMessage.text];
                                 }
                             } else {
                                 if ([delegate respondsToSelector:@selector(newChatCancelled)]) {
                                     [delegate newChatCancelled];
                                 }
                             }
                         }];
    }];
    
}

-(void)textViewDidChange:(UITextView *)textView {
    [self checkIfReady];
}

-(void)checkIfReady {
    
    if (([self.txtTopic.text length]) && ([self.txtMessage.text length])) {
        self.btnStartChat.enabled = YES;
    } else {
        self.btnStartChat.enabled = NO;
    }
}

@end
