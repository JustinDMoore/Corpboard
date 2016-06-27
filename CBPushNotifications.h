//
//  CBPushNotifications.h
//  Corpboard
//
//  Created by Justin Moore on 5/23/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol delegatePushNotifications <NSObject>
@required
-(void)allowPush;
-(void)denyPush;
@end

@interface CBPushNotifications : UIView {
    id delegate;
}

@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) UIVisualEffectView *viewBlur;
@property (nonatomic, strong) UIView *parentNav;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(UINavigationController *)parentNav;

@end
