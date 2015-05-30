//
//  CBEmailLogin.h
//  CorpBoard
//
//  Created by Justin Moore on 11/21/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmailProtocol <NSObject>
@required
-(void)emailCancelled;
-(void)newUserCreatedFromEmail;
-(void)successfulLoginFromEmail;
-(void)loggingIn;
-(void)errorLoggingIn:(NSString *)error;
@end

@interface CBEmailLogin : UIView <UITextFieldDelegate> {
    id delegate;
    BOOL newUser;
}
@property (nonatomic, strong) IBOutlet UITextField *txtName;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
-(void)setIsNewUser:(BOOL)isNewUser;
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(UIView *)par;

@end
