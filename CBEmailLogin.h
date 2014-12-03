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
@end

@interface CBEmailLogin : UIView <UITextFieldDelegate> {
    id delegate;
    BOOL newUser;
}

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) UIView *viewToScroll;

-(void)setIsNewUser:(BOOL)isNewUser;
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent withEmail:(NSString *)email;

@end
