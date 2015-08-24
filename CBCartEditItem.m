//
//  CBCartEditItem.m
//  Corpboard
//
//  Created by Isaias Favela on 8/22/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBCartEditItem.h"

@implementation CBCartEditItem
BOOL isShowing;
CGRect startRect;
CGRect endRect;
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
    }
    return self;
}

- (IBAction)decrementQty:(UIButton *)sender {
    self.quantity--;
}

- (IBAction)incrementQty:(UIButton *)sender {
    self.quantity++;
}

- (IBAction)removeItem:(UIButton *)sender {
}

- (IBAction)cancel:(UIButton *)sender {
    [self closeView];
}

int moveSpace = 165;
-(void)showAtRect:(CGRect)sRect endAtRect:(CGRect)eRect withQty:(int)qty {
    self.quantity = qty;
    startRect = sRect;
    endRect = eRect;
    isShowing = YES;
    self.alpha = 0;
    self.frame = sRect;
    [UIView animateWithDuration:.75 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        self.frame = endRect;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)closeView {
    isShowing = NO;
    if ([delegate respondsToSelector:@selector(itemCancelAnimationWillStart)]) {
        [delegate itemCancelAnimationWillStart];
    }
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:1 options:0 animations:^{
        self.frame = startRect;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (!isShowing) {
            if ([delegate respondsToSelector:@selector(itemCancelAnimationComplete)]) {
                [self removeFromSuperview];
                [delegate itemCancelAnimationComplete];
            }
        }
    }];
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

-(void)setQuantity:(int)quantity {
    if (quantity < 1) quantity = 1;
    else if (quantity > 9) quantity = 9;
    _quantity = quantity;
    self.lblQty.text = [NSString stringWithFormat:@"%i", quantity];
    if ([delegate respondsToSelector:@selector(newQuantity:)]) {
        [delegate newQuantity:quantity];
    }
}

@end
