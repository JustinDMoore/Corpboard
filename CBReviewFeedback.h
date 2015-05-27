//
//  CBReviewFeedback.h
//  Corpboard
//
//  Created by Justin Moore on 5/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextViewPlaceholder.h"

@protocol CBReviewFeedbackProtocol <NSObject>
@required
-(void)feedbackGiven:(NSString *)feedback;
@end

@interface CBReviewFeedback : UIView {
    id delegate;
}

@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtFeedback;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(NSString *)feedback;

@end
