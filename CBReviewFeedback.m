//
//  CBReviewFeedback.m
//  Corpboard
//
//  Created by Justin Moore on 5/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBReviewFeedback.h"

@implementation CBReviewFeedback

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
    }
    return self;
}

-(void)showInParent:(NSString *)feedback {
    
    self.txtFeedback.backgroundColor = [UIColor clearColor];
    if ([feedback length]) self.txtFeedback.text = feedback;
    self.txtFeedback.placeholder = @"How was the show?\n\nWhat can we improve?";
    [self.txtFeedback becomeFirstResponder];
}

-(void)setDelegate:(id)newDelegate {
    
    delegate = newDelegate;
}

-(IBAction)btnOK_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(feedbackGiven:)]) {
        [delegate feedbackGiven:self.txtFeedback.text];
    }
}

@end
