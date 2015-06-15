//
//  CBNicknameView.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNicknameView.h"
#import "Parse/Parse.h"

@implementation CBNicknameView {

}

-(void)awakeFromNib {
    [self initUI];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        
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
    
    if (![self.txtNickname.text length]) {
        return;
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
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

-(void)keyboardWillShow:(NSNotification*)aNotification {
    
    self.viewToScroll.frame = CGRectMake(0, 0, self.viewToScroll.frame.size.width, self.viewToScroll.frame.size.height);
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:curve animations:^{
        NSLog(@"%@", self.viewToScroll);
        self.viewToScroll.frame = CGRectMake(self.viewToScroll.frame.origin.x, self.viewToScroll.frame.origin.y - (rect.size.height / 2), self.viewToScroll.frame.size.width, self.viewToScroll.frame.size.height);
    } completion:nil];
    
}

-(void)keyboardWillHide:(NSNotification*)aNotification {
    
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSTimeInterval animationDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:curve animations:^{
        NSLog(@"%@", self.viewToScroll);
        self.viewToScroll.frame = CGRectMake(self.viewToScroll.frame.origin.x, 0, self.viewToScroll.frame.size.width, self.viewToScroll.frame.size.height);
    } completion:nil];
}
@end
