//
//  CBCartEditItem.m
//  Corpboard
//
//  Created by Isaias Favela on 8/22/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBCartEditItem.h"

@implementation CBCartEditItem
BOOL startedRight;
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
    }
    return self;
}

- (IBAction)decrementQty:(UIButton *)sender {
}

- (IBAction)incrementQty:(UIButton *)sender {
}

- (IBAction)removeItem:(UIButton *)sender {
}

- (IBAction)cancel:(UIButton *)sender {
    [self closeView];
}

int moveSpace = 165;
-(void)showAtRect:(CGRect)rect animateRight:(BOOL)right {
    self.alpha = 0;
    self.frame = rect;
    startedRight = right;
    [UIView animateWithDuration:.75 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:1 options:0 animations:^{
        self.alpha = 1;
        if (right) {
            self.frame = CGRectMake(self.frame.origin.x + moveSpace, self.frame.origin.y, 150, 150);
        } else {
            self.frame = CGRectMake(self.frame.origin.x - moveSpace, self.frame.origin.y, 150, 150);
        }
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)closeView {
    if ([delegate respondsToSelector:@selector(itemCancelAnimationWillStart)]) {
        [delegate itemCancelAnimationWillStart];
    }
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:1 options:0 animations:^{
        
        if (startedRight) {
            self.frame = CGRectMake(self.frame.origin.x - moveSpace, self.frame.origin.y, 150, 150);
        } else {
            self.frame = CGRectMake(self.frame.origin.x + moveSpace, self.frame.origin.y, 150, 150);
        }
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        if ([delegate respondsToSelector:@selector(itemCancelAnimationComplete)]) {
            [self removeFromSuperview];
            [delegate itemCancelAnimationComplete];
        }
    }];
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

@end
