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

@implementation CBEmailLogin {
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
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
    }
    return self;
}

-(void)initUI {
    
    self.clipsToBounds = YES;
    txtEmail.delegate = self;
    txtPassword.delegate = self;
    txtPassword.secureTextEntry = YES;

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
    txtEmail.text = @"";
    txtPassword.text = @"";
    cancelled = YES;
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    
}

- (IBAction)btnSignUp_clicked:(id)sender {
    if ([self checkForEmailAndPassword:nil]) {
        if (newUser) {
            [txtEmail resignFirstResponder];
            [txtPassword resignFirstResponder];
            [self createAccountWithEmail:txtEmail.text Password:txtPassword.text];
        } else {
            [self signIntoAccountWithEmail:txtEmail.text andPassword:txtPassword.text];
        }
    }
}

-(void)createAccountWithEmail:(NSString *)email Password:(NSString *) pw {
    
    PFUser *user = [PFUser user];
    user.username = email;
    user.password = pw;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [delegate newUserCreatedFromEmail:email pw:pw];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"Error creating account: %@", errorString);
            
 
        }
    }];
}

-(void)signIntoAccountWithEmail:(NSString *)email andPassword:(NSString *)pw {
    
    [PFUser logInWithUsernameInBackground:email password:pw
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"email login good");
                                            [delegate successfulLoginFromEmail];
                                        } else {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[ParseErrors getErrorStringForCode:error.code] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                            [alert show];
                                            NSLog(@"%@", error);
                                            // The login failed. Check error to see why.
                                        }
                                    }];
}

#pragma mark
#pragma mark - UITextField Delegates
#pragma mark

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    currentResponder = textField;

        //move the main view, so that the keyboard does not hide it.
        if  (self.viewToScroll.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    
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
            [self signIntoAccountWithEmail:txtEmail.text andPassword:txtPassword.text];
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

#pragma mark
#pragma mark - Keyboard Notifications
#pragma mark

#define kOFFSET_FOR_KEYBOARD 50.0

-(void)keyboardWillShow:(NSNotification*)aNotification {
    // Animate the current view out of the way
    cancelled = NO;
    if (self.viewToScroll.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.viewToScroll.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide:(NSNotification*)aNotification {

    if (self.viewToScroll.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.viewToScroll.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    

    
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = self.viewToScroll.frame;
        if (movedUp)
        {
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            rect.size.height += kOFFSET_FOR_KEYBOARD;
        }
        else
        {
            // revert back to the normal state.
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
            rect.size.height -= kOFFSET_FOR_KEYBOARD;
        }
        self.viewToScroll.frame = rect;
        UIScrollView *sc = (UIScrollView*)self.superview;
        [sc scrollRectToVisible:self.frame animated:YES];
    } completion:^(BOOL finished) {
        
//        if (cancelled) {
//            [delegate emailCancelled];
//        }
    }];

}

@end
