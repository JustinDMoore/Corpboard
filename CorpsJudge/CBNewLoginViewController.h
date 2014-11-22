//
//  CBNewLoginViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 11/20/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSingle.h"
#import "CBIsNewUser.h"
#import "CBViewSignIn.h"
#import "CBEmailLogin.h"
#import "CBNickname.h"
#import "CBProgressView.h"

@interface CBNewLoginViewController : UIViewController <dataProtocol, NewUserProtocol, SignInProtocol, EmailProtocol, NicknameProtocol, ProgressProtocol, UIScrollViewDelegate>

@end
