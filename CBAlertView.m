//
//  CBAlertView.m
//  CorpBoard
//
//  Created by Isaias Favela on 5/14/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBAlertView.h"

@implementation CBAlertView

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

-(void)setAlertType:(CBAlertType)type {
    
    switch (type) {
        case CBAlertTypeOKOnly:
            self.viewBottomBar.hidden = YES;
            self.btnAffirm.hidden = YES;
            self.btnDeny.hidden = YES;
            self.btnAcknowledge.hidden = NO;
            [self.btnAcknowledge setTitle:@"OK" forState:UIControlStateNormal];
            break;
        case CBAlertTypeOKCancel:
            self.viewBottomBar.hidden = NO;
            self.btnAcknowledge.hidden = YES;
            self.btnAffirm.hidden = NO;
            self.btnDeny.hidden = NO;
            [self.btnAffirm setTitle:@"OK" forState:UIControlStateNormal];
            [self.btnDeny setTitle:@"Cancel" forState:UIControlStateNormal];
            break;
        case CBAlertTypeYesNO:
            self.viewBottomBar.hidden = NO;
            self.btnAcknowledge.hidden = YES;
            self.btnAffirm.hidden = NO;
            self.btnDeny.hidden = NO;
            [self.btnAffirm setTitle:@"Yes" forState:UIControlStateNormal];
            [self.btnDeny setTitle:@"No" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)setAlertImage:(CBAlertImage)image {
    
    switch (image) {
        case CBAlertImageCheck:
            [self.imgView setImage:[UIImage imageNamed:@"CBAlertCheck"]];
            break;
        case CBAlertImageInformation:
            [self.imgView setImage:[UIImage imageNamed:@"CBAlertInformation"]];
            break;
        case CBAlertImageWarning:
            [self.imgView setImage:[UIImage imageNamed:@"CBAlertWarning"]];
            break;
        default:
            break;
    }
}

-(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message forAlertType:(CBAlertType)type withCBAlertImage:(CBAlertImage)image {
    
    [self setAlertType:type];
    [self setAlertImage:image];
    self.lblTitle.text = title;
    self.lblBody.text = message;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self.viewBlur = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    self.viewBlur.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    [self.superview addSubview:self.viewBlur];
    [self.superview bringSubviewToFront:self];
    
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

-(void)dismissAlert {
    
    
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
                             [self.viewBlur removeFromSuperview];
                         }];
    }];
}

#pragma mark
#pragma mark - Actions
#pragma mark

- (IBAction)btnAcknowledge_tapped:(id)sender {
 
    if ([delegate respondsToSelector:@selector(didAcknowledgeCBAlert)]) {
        [delegate didAcknowledgeCBAlert];
    }
    [self dismissAlert];
}

- (IBAction)btnAffirm_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didAffirmCBAlert)]) {
        [delegate didAffirmCBAlert];
    }
    [self dismissAlert];
}

- (IBAction)btnDeny_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didDenyCBAlert)]) {
        [delegate didDenyCBAlert];
    }
    [self dismissAlert];
}

@end
