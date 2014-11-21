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
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *btnSignUp;
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
    txtEmail.delegate = self;
    txtPassword.delegate = self;

}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent:(CGRect)parent withEmail:(NSString *)email {
    
    [self initUI];
    
    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2), CGRectGetMidY(parent) - (self.frame.size.height / 2) - 65, self.frame.size.width, self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        txtEmail.text = email;
        [txtEmail becomeFirstResponder];
        
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
    [self closeView:YES];
}

- (IBAction)btnSignUp_clicked:(id)sender {
    if ([self checkForEmailAndPassword:nil]) {
        [self closeView:NO];
    }
}

#pragma mark
#pragma mark - UITextField Delegates
#pragma mark

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    currentResponder = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == txtEmail)  {
        if ([textField.text length]) {
            [textField resignFirstResponder];
            [txtPassword becomeFirstResponder];
            currentResponder = txtPassword;
        }
    }

    if (textField == txtPassword) {
        if ([self checkForEmailAndPassword:textField]) {
            [self closeView:NO];
        }
    }
    
    return NO;
}

-(BOOL)checkForEmailAndPassword: (UITextField *)textField {
    
    UIAlertView *alert;
    
    if (![txtEmail.text length]) {
        alert = [[UIAlertView alloc] initWithTitle:@""
                                           message:@"Please enter a valid email address"
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [txtEmail becomeFirstResponder];
        [alert show];
        return NO;
    } else {
        if (![JustinHelper StringIsValidEmail:txtEmail.text]) {
            alert = [[UIAlertView alloc] initWithTitle:@""
                                               message:@"Please enter a valid email address"
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [txtEmail becomeFirstResponder];
            [alert show];
            return NO;
        }
    }
    
    if (![txtPassword.text length]) {
        alert = [[UIAlertView alloc] initWithTitle:@""
                                           message:@"Please enter a password"
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [txtPassword becomeFirstResponder];
        [alert show];
        return NO;
    }

    return YES;
}

@end
