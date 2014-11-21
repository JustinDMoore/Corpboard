//
//  CBNewUserView.h
//  CorpBoard
//
//  Created by Justin Moore on 11/21/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol newUserProtocol <NSObject>
@required
-(void)newUserCancelled;
-(void)newUserCreated:(NSString *)email pw:(NSString *)password;
@end
@interface CBNewUserView : UIView <UITextFieldDelegate> {
    id delegate;
}

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
@end
