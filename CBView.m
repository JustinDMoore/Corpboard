//
//  CBView.m
//  CorpBoard
//
//  Created by Isaias Favela on 12/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBView.h"

@implementation CBView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    
    return nil;
}

@end
