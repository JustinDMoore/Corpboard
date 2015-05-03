//
//  CBThankYou.m
//  CorpBoard
//
//  Created by Justin Moore on 5/2/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBThankYou.h"

@implementation CBThankYou

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        for (UIView *view in self.subviews) {
            view.alpha = 0;
        }
    }
    return self;
}

-(void)showInParent {
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         for (UIView *view in self.subviews) {
                             view.hidden = NO;
                             view.alpha = 1;
                         }
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

- (IBAction)btnOK_tapped:(id)sender {
    if ([delegate respondsToSelector:@selector(thankYou)]) {
        [delegate thankYou];
    }
}

@end
