//
//  CBVersion.h
//  Corpboard
//
//  Created by Justin Moore on 6/4/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol versionProtocol <NSObject>
@required
-(void)updateLater;
-(void)updateNow;
@end

@interface CBVersion : UIView {
    id delegate;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;

-(void)showInParent;
-(void)setDelegate:(id)newDelegate;

@end
