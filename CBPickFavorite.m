//
//  CBPickFavorite.m
//  Corpboard
//
//  Created by Justin Moore on 5/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBPickFavorite.h"

@implementation CBPickFavorite

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
    
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

-(void)showInParent:(NSString *)header {
    
    self.lblHeader.text = header;
    
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

- (IBAction)btnOK_tapped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(favoritePicked)]) {
        [delegate favoritePicked];
    }
}


@end
