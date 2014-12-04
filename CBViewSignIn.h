//
//  CBViewSignIn.h
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInProtocol <NSObject>
@required
-(void)loggingIn;
-(void)errorLoggingIn;
-(void)loginSuccessful:(BOOL)needsNickName;
-(void)emailSelected;
-(void)SignInCancelled;
@end

@interface CBViewSignIn : UIView {
    id delegate;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;

-(void)setDelegate:(id)newDelegate;
-(void)setTitleMessage:(NSString *)message;
@end
