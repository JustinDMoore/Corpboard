//
//  CBNicknameView.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNicknameView.h"
#import "Parse/Parse.h"

@implementation CBNicknameView

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
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
    self.txtNickname.delegate = self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

- (IBAction)btnDone_clicked:(id)sender {
    //check for unique nickname in delegate
    if (![self.txtNickname.text length]) {
        return;
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Users"];
        [query whereKey:@"nickname" equalTo:self.txtNickname.text];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                if (count > 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This nickname is already taken." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    PFUser *user = [PFUser currentUser];
                    user[@"nickname"] = self.txtNickname.text;
                    [user saveInBackground];
                    [self.txtNickname resignFirstResponder];
                    [delegate nicknameChosen];
                }
            } else {
                // The request failed
            }
        }];
    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if  (self.viewToScroll.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length]) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
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
