//
//  CBIsNewUser.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBIsNewUser.h"
#import "CBWebViewController.h"

@implementation CBIsNewUser

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        [self initUI];
    }
    return self;
}

-(void)initUI {
    self.clipsToBounds = YES;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

- (IBAction)btnNewUser_clicked:(id)sender {
    [delegate isNewUser:YES];
}

- (IBAction)btnExistingUser_clicked:(id)sender {
    [delegate isNewUser:NO];
}
- (IBAction)btnPrivacyPolicy_tapped:(id)sender { 
    
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"web";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    CBWebViewController * web = (CBWebViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    web.webURL = @"http://yea.org/privacy-general";
    web.websiteTitle = @"Youth Education in the Arts";
    web.websiteSubTitle = @"Privacy Policy";
    
    [self.parent presentViewController:web animated:YES completion:nil];
}

@end
