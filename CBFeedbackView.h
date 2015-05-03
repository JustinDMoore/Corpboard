//
//  CBFeedbackView.h
//  CorpBoard
//
//  Created by Justin Moore on 5/2/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextViewPlaceHolder.h"

@protocol feedbackProtocol <NSObject>
@required
-(void)feedbackCancelled:(int)numberOfStars;
-(void)feedbackSent:(int)numberOfStars feedback:(NSString *)feedback;
@end

@interface CBFeedbackView : UIView <UITextViewDelegate> {
    id delegate;
}

@property (nonatomic) int numberOfStars;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) IBOutlet UIButton *btnSend;
@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtFeedback;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent;
@end
