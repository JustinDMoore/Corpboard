//
//  CBNewUserView.m
//  CorpBoard
//
//  Created by Justin Moore on 11/21/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNewUserView.h"
#import "JustinHelper.h"

@implementation CBNewUserView {
    
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UIButton *btnSignUp;
    id currentResponder;
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
        
        //disable superview subviews
        for (UIView *v in self.superview.subviews) {
            if (![v isKindOfClass:[CBNewUserView class]]) {
                v.userInteractionEnabled = NO;
            }
        }
    }
    return self;
}

-(void)initUI {
    btnSignUp.enabled = NO;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent:(CGRect)parent {
    
    [self initUI];
    
    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2), CGRectGetMidY(parent) - (self.frame.size.height / 2), self.frame.size.width, self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
        
    }];
}

-(void)closeView:(BOOL)cancelled {
    
    for (UIView *v in self.superview.subviews) {
        if (![v isKindOfClass:[CBNewUserView class]]) {
            v.userInteractionEnabled = YES;
        }
    }
    
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
                             if (cancelled) [delegate newUserCancelled];
                             else [delegate newUserCreated:txtEmail.text pw:txtPassword.text];
                         }];
    }];
}

- (IBAction)btnCancel_clicked:(id)sender {
}

- (IBAction)btnSignUp_clicked:(id)sender {
}

#pragma mark
#pragma mark - UITextField Delegates
#pragma mark

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    currentResponder = textField;
}

- (void)resignOnTap:(id)iSender {
    
    [currentResponder resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == txtEmail)  {
        [txtPassword becomeFirstResponder];
        currentResponder = txtPassword;
    }
    if (textField == txtPassword) {
        // attempt login
        //make sure we have un and pw
        if ((![txtEmail.text isEqualToString:@""]) && (![txtPassword.text isEqualToString:@""])) {
            if ([JustinHelper StringIsValidEmail:txtEmail.text]) {
                [self closeView:NO];
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Please enter a valid email address"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [txtEmail becomeFirstResponder];
            }
        }
    }
    
    return NO;
}
@end
