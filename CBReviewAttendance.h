//
//  CBReviewAttendance.h
//  Corpboard
//
//  Created by Justin Moore on 5/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBReviewAttendanceProtocol <NSObject>
@required
-(void)userAttended:(BOOL)attended;
@end

@interface CBReviewAttendance : UIView {
    id delegate;
}

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
-(void)closeView:(BOOL)completely;

@end
