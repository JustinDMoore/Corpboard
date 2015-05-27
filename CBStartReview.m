//
//  CBStartReview.m
//  Corpboard
//
//  Created by Justin Moore on 5/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBStartReview.h"

@implementation CBStartReview

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        
        self.loaded = NO;
        for (UIView *view in self.subviews) {
            view.alpha = 0;
            view.hidden = YES;
        }
    }
    return self;
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

-(void)showInParent {
    
    [self.tableReview reloadData];
    [self.tableReview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         for (UIView *view in self.subviews) {
                             view.hidden = NO;
                             view.alpha = 1;
                         }
                         [self.tableReview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                  atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                     } completion:^(BOOL finished) {
                         self.loaded = YES;
                         [self.tableReview reloadData];
                     }];
}

- (IBAction)btnCancelReview_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(reviewCancelled)]) {
        [delegate reviewCancelled];
    }
}

- (IBAction)btnSend_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(reviewSent)]) {
        [delegate reviewSent];
    }
}

@end
