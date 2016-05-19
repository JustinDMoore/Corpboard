//
//  CreateAccount.h
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol delegateCreateAccount <NSObject>
-(void)proceed;
@end

@interface CreateAccount : UIView {
    id delegate;
}

//new account
@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;

//nickname
@property (weak, nonatomic) IBOutlet UIView *viewContainerNickname;
@property (weak, nonatomic) IBOutlet UIView *viewDialogNickname;
@property (weak, nonatomic) IBOutlet UIButton *btnImageNickname;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageNickname;
@property (weak, nonatomic) IBOutlet UITextField *txtNickname;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckName;
@property (weak, nonatomic) IBOutlet UILabel *lblNicknameTitle;


-(void)showView:(NSString *)view InParent:(UINavigationController *)parentNav;
-(void)setDelegate:(id)newDelegate;

@end
