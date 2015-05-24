//
//  CBLocationServices.h
//  Corpboard
//
//  Created by Justin Moore on 5/23/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBLocationProtocol <NSObject>
@required
-(void)allowLocation;
-(void)denyLocation;
@end

@interface CBLocationServices : UIView {
    id delegate;
}

@property (nonatomic, strong) UIVisualEffectView *viewBlur;
@property (nonatomic, strong) IBOutlet UIButton *btnAllowLocation;
@property (nonatomic, strong) UINavigationController *parentNav;

-(void)show;
-(void)setDelegate:(id)newDelegate;

@end
