//
//  CBNewLoginViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 11/20/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBSingle.h"
#import "CBIsNewUser.h"
#import "CBViewSignIn.h"
#import "CBEmailLogin.h"
#import "CBNicknameView.h"
#import "CBProgressView.h"
#import "CBNewsSingleton.h"
#import "CBPushNotifications.h"

@interface CBNewLoginViewController : UIViewController <dataProtocol, NewUserProtocol, SignInProtocol, EmailProtocol, NicknameProtocol, ProgressProtocol, UIScrollViewDelegate, newsProtocol, CBPushNotificationProtocol>


//swift
@property (weak, nonatomic) IBOutlet UILabel *lblCorpboard;
@property (nonatomic, weak) IBOutlet UIImageView *imgCadetsText;
@property (weak, nonatomic) IBOutlet UIView *viewCadets;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow1;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow2;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow3;
//

@end
