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
        [self initUI];
        
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

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}


- (IBAction)btnCancel_clicked:(id)sender {
    txtEmail.text = @"";
    txtPassword.text = @"";
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [delegate newUserCancelled];
}

- (IBAction)btnSignUp_clicked:(id)sender {
    if ([self checkForEmailAndPassword:nil]) {
        [delegate newUserCreated:txtEmail.text pw:txtPassword.text];
    }
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

#define kOFFSET_FOR_KEYBOARD 95.0

-(void)keyboardWillShow:(NSNotification*)aNotification {
    // Animate the current view out of the way
    
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
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
    
    [UIView commitAnimations];
}

@end
