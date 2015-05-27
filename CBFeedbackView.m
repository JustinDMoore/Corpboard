//
//  CBFeedbackView.m
//  CorpBoard
//
//  Created by Justin Moore on 5/2/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBFeedbackView.h"

@implementation CBFeedbackView

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
    }
    return self;
}

-(void)showInParent {
    
    self.txtFeedback.backgroundColor = [UIColor clearColor];
    self.txtFeedback.placeholder = @"How can we improve?";
    self.txtFeedback.delegate = self;
    [self.txtFeedback becomeFirstResponder];
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

#pragma mark
#pragma mark - Actions
#pragma mark
- (IBAction)btnCancel_tapped:(id)sender {
    if ([delegate respondsToSelector:@selector(feedbackCancelled:)]) {
        [delegate feedbackCancelled:self.numberOfStars];
    }
}

- (IBAction)btnSend_tapped:(id)sender {
    if ([delegate respondsToSelector:@selector(feedbackSent:feedback:)]) {
        [delegate feedbackSent:self.numberOfStars feedback:self.txtFeedback.text];
    }
}

#pragma mark
#pragma mark - UITextView Delegate
#pragma mark
-(void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text length]) {
        self.btnSend.enabled = YES;
    } else {
        self.btnSend.enabled = NO;
    }
}

@end
