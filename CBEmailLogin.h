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
-(void)newUserCancelled;
-(void)newUserCreated:(NSString *)email pw:(NSString *)password;
@end

@interface CBEmailLogin : UIView <UITextFieldDelegate> {
    id delegate;
}

@property (nonatomic, strong) UIView *viewToScroll;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent withEmail:(NSString *)email;

@end
