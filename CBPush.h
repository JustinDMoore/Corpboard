//
//  CBPush.h
//  Corpboard
//
//  Created by Justin Moore on 5/27/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPush : UIView

@property (nonatomic, strong) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *clearView;
@property (nonatomic, strong) NSTimer *timer;
-(void)showPush:(NSString *)push inParent:(UIView *)parent;

@end
