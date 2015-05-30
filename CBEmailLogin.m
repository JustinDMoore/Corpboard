//
//  CBEmailLogin.m
//  CorpBoard
//
//  Created by Justin Moore on 11/21/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBEmailLogin.h"
#import "JustinHelper.h"
#import <Parse/Parse.h>
#import "ParseErrors.h"
#import "KVNProgress.h"
#import "AppConstant.h"
#import "pushnotification.h"

@implementation CBEmailLogin {
    UIView *parent;
    IBOutlet UIButton *btnSignUp;
    id currentResponder;
}

-(void)awakeFromNib {
    
    [self initUI];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        //[self initUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        self.backgroundColor = [UIColor clearColor];
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        visualEffectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self addSubview:visualEffectView];
        [self sendSubviewToBack:visualEffectView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        [self addGestureRecognizer:tap];
    
    }
    return self;
}

-(void)close:(BOOL)overRideKeyboard {
    
    BOOL check = keyboardVis;
    [self.txtEmail resignFirstResponder];
    [self.txtName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    if (!check || overRideKeyboard) {
        [UIView animateWithDuration:.3
                         animations:^{
                             parent.transform = CGAffineTransformIdentity;
                         }];
        
        
        [UIView animateWithDuration:.5
                         animations:^{
                             self.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}

-(void)initUI {
    
    self.clipsToBounds = YES;
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
    self.txtPassword.secureTextEntry = YES;
    [self.activity stopAnimating];
    self.activity.hidden = YES;
}

-(void)setIsNewUser:(BOOL)isNewUser {
    newUser = isNewUser;
    if (isNewUser) {
        self.lblTitle.text = @"CREATE NEW ACCOUNT";
    } else {
        self.lblTitle.text = @"SIGN INTO EXISTING ACCOUNT";
    }
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

BOOL cancelled;
- (IBAction)btnCancel_clicked:(id)sender {
    self.txtEmail.text = @"";
    self.txtPassword.text = @"";
    cancelled = YES;
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    if (![self.txtEmail isFirstResponder] && ![self.txtPassword isFirstResponder]) {
        [delegate emailCancelled];
    }
}

- (IBAction)btnSignUp_clicked:(id)sender {
    if ([self checkForEmailAndPassword:nil]) {
        
        self.activity.hidden = NO;
        [self.activity startAnimating];
        
        [self.txtEmail resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        if (newUser) {
            [self createAccount];
        } else {
            [self signIntoAccountWithEmail:[self.txtEmail.text lowercaseString] andPassword:self.txtPassword.text];
        }
    }
}

-(void)createAccount {
    
//    PFUser *user = [PFUser user];
//    user.username = email;
//    user.password = pw;
//    user.email = email;
//    
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // Hooray! Let them use the app now.
//            [delegate newUserCreatedFromEmail:email pw:pw];
//            
//        } else {
//            NSString *errorString = [error userInfo][@"error"];
//            // Show the errorString somewhere and let the user try again.
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//            NSLog(@"Error creating account: %@", errorString);
//            
// 
//        }
//    }];
    [delegate loggingIn];
    NSString *name		= self.txtName.text;
    NSString *password	= self.txtPassword.text;
    NSString *email		= [self.txtEmail.text lowercaseString];
    
    
    
    PFUser *user = [PFUser user];
    user.username = email;
    user.password = password;
    user.email = email;
    user[PF_USER_EMAILCOPY] = email;
    user[PF_USER_FULLNAME] = name;
    user[PF_USER_FULLNAME_LOWER] = [name lowercaseString];
    user[@"lastLogin"] = [NSDate date];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error == nil) {
                [self close:YES];
            ParsePushUserAssign();
            [self.activity stopAnimating];
            self.activity.hidden = YES;
            [delegate newUserCreatedFromEmail];
        } else {
            [self.activity stopAnimating];
            self.activity.hidden = YES;
            [delegate errorLoggingIn:[ParseErrors getErrorStringForCode:error.code]];
        }
    }];
}

-(void)signIntoAccountWithEmail:(NSString *)email andPassword:(NSString *)pw {
    
    [delegate loggingIn];
//    [PFUser logInWithUsernameInBackground:email password:pw
//                                    block:^(PFUser *user, NSError *error) {
//                                        if (user) {
//                                            NSLog(@"email login good");
//                                            [delegate successfulLoginFromEmail];
//                                        } else {
//                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                            [alert show];
//                                            NSLog(@"%@", error);
//                                            // The login failed. Check error to see why.
//                                        }
//                                    }];


    NSString *username = [self.txtEmail.text lowercaseString];
    NSString *password = self.txtPassword.text;

    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             [self.activity stopAnimating];
             self.activity.hidden = YES;
            [self close:YES];
             ParsePushUserAssign();
             [delegate successfulLoginFromEmail];
         } else {
             [self.activity stopAnimating];
             self.activity.hidden = YES;
             [delegate errorLoggingIn:[ParseErrors getErrorStringForCode:error.code]];
         }
     }];
}

#pragma mark
#pragma mark - UITextField Delegates
#pragma mark

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    currentResponder = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == self.txtEmail)  {
        if ([textField.text length]) {
            [textField resignFirstResponder];
            [self.txtPassword becomeFirstResponder];
            currentResponder = self.txtPassword;
        }
    }

    if (textField == self.txtPassword) {
        if ([self checkForEmailAndPassword:textField]) {
            [self signIntoAccountWithEmail:[self.txtEmail.text lowercaseString] andPassword:self.txtPassword.text];
        }
    }
    
    return NO;
}

-(BOOL)checkForEmailAndPassword: (UITextField *)textField {
    
    UIAlertView *alert;
    if (newUser) {
        if (![self.txtName.text length]) {

                alert = [[UIAlertView alloc] initWithTitle:@"Required"
                                               message:@"Please enter your name"
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [self.txtName becomeFirstResponder];
            [alert show];
            return NO;
        }
    }
    
    if (![self.txtEmail.text length]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Required"
                                           message:@"Please enter a valid email address"
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [self.txtEmail becomeFirstResponder];
        [alert show];
        return NO;
    } else {
        if (![JustinHelper StringIsValidEmail:[self.txtEmail.text lowercaseString]]) {
            alert = [[UIAlertView alloc] initWithTitle:@"Required"
                                               message:@"Please enter a valid email address"
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [self.txtEmail becomeFirstResponder];
            [alert show];
            return NO;
        }
    }
    
    if (![self.txtPassword.text length]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Required"
                                           message:@"Please enter a password"
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [self.txtPassword becomeFirstResponder];
        [alert show];
        return NO;
    }

    return YES;
}

#pragma mark
#pragma mark - Keyboard Notifications
#pragma mark

-(void)showInParent:(UIView *)par {
    parent = par;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.alpha = 0;
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.alpha = 1;
                     } completion:^(BOOL finished) {

                     }];
    
//    [UIView animateWithDuration:.3
//                          delay:.2
//                        options:0
//                     animations:^{
//                         parent.transform = CGAffineTransformScale(parent.transform, 1.30, 1.30);
//                     } completion:^(BOOL finished) {
//                         
//                     }];
}

BOOL keyboardVis;

-(void)keyboardWillShow:(NSNotification*)aNotification {

    if (!keyboardVis) {
     
        keyboardVis = YES;
        //self.viewToScroll = self;
//        self.viewToScroll.frame = CGRectMake(0, 0, self.viewToScroll.frame.size.width, self.viewToScroll.frame.size.height);
//        
//        NSDictionary *userInfo = [aNotification userInfo];
//        
//        CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        NSTimeInterval animationDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        NSInteger curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
//        
//        [UIView animateWithDuration:animationDuration delay:0.0 options:curve animations:^{
//            self.viewToScroll.frame = CGRectMake(self.viewToScroll.frame.origin.x, self.viewToScroll.frame.origin.y - rect.size.height, self.viewToScroll.frame.size.width, self.viewToScroll.frame.size.height);
//            //self.viewToScroll.frame = CGRectMake(self.viewToScroll.frame.origin.x, self.viewToScroll.frame.origin.y - (rect.size.height / (newUser ? 1.3 : 1.7)), self.viewToScroll.frame.size.width, self.viewToScroll.frame.size.height);
//        } completion:nil];
    }
}

-(void)keyboardWillHide:(NSNotification*)aNotification {

    keyboardVis = NO;
    
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSTimeInterval animationDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    NSInteger curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
//    
//    [UIView animateWithDuration:animationDuration delay:0.0 options:curve animations:^{
//        self.viewToScroll.frame = CGRectMake(self.viewToScroll.frame.origin.x, 0, self.viewToScroll.frame.size.width, self.viewToScroll.frame.size.height);
//    } completion:nil];
}

- (IBAction)btnForgotPassword_clicked:(id)sender {
    
    if ([self.txtEmail.text length]) {
        //make sure it's a valid email
        if (![JustinHelper StringIsValidEmail:[self.txtEmail.text lowercaseString]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.txtEmail becomeFirstResponder];
        } else {
            //valid email, check to make sure we have account for it
            [PFUser requestPasswordResetForEmailInBackground:[self.txtEmail.text lowercaseString] block:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    if (succeeded) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"An email will be sent to %@ with instructions to reset your password.", [self.txtEmail.text lowercaseString]                                                       ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Unable to reset password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            //[PFUser requestPasswordResetForEmailInBackground:@"email@example.com"];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter your email address to reset your password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
