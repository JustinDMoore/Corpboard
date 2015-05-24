//
//  CBPushNotifications.h
//  Corpboard
//
//  Created by Justin Moore on 5/23/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CBPushNotificationProtocol <NSObject>
@required
-(void)allowPush;
-(void)denyPush;
@end

@interface CBPushNotifications : UIView {
    id delegate;
}

@property (nonatomic, strong) UIVisualEffectView *viewBlur;
@property (nonatomic, strong) IBOutlet UIButton *btnAllowPush;
@property (nonatomic, strong) UIView *parentNav;

-(void)show;
-(void)setDelegate:(id)newDelegate;

@end
