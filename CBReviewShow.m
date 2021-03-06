//
//  CBReviewShow.m
//  CorpBoard
//
//  Created by Justin Moore on 5/12/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBReviewShow.h"

@implementation CBReviewShow

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        self.tableRecap.canCancelContentTouches = YES;

    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent {
    
    [self.tableRecap reloadData];
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         for (UIView *view in self.subviews) {
                             view.hidden = NO;
                             view.alpha = 1;
                         }
                     } completion:^(BOOL finished) {
               
                         [self.tableRecap reloadData];
                     }];
}

-(IBAction)btnYes_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(submitReview)]) {
        [delegate submitReview];
    }
}

-(IBAction)btnNo_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(cancelSubmitReview)]) {
        [delegate cancelSubmitReview];
    }
}

@end
