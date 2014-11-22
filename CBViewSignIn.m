//
//  CBViewSignIn.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBViewSignIn.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation CBViewSignIn

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        
    }
    return self;
}

-(void)setTitleMessage:(NSString *)message {
    self.lblTitle.text = message;
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

- (IBAction)btnBack_clicked:(id)sender {
    [delegate SignInCancelled];
}

- (IBAction)btnFacebook_clicked:(id)sender {
    NSArray *permissions = @[@"email", @"public_profile"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [delegate loginSuccessful:YES];
        } else {
            NSLog(@"User logged in through Facebook!");
            [delegate loginSuccessful:NO];
        }
    }];
}

- (IBAction)btnTwitter_clicked:(id)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [delegate loginSuccessful:YES];
        } else {
            NSLog(@"User logged in with Twitter!");
            [delegate loginSuccessful:NO];
        }
    }];
}

- (IBAction)btnEmail_clicked:(id)sender {
    
    [delegate emailSelected];
}

@end
