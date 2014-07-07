//
//  ClipView.m
//  CorpBoard
//
//  Created by Justin Moore on 7/3/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "ClipView.h"

@implementation ClipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *hitView = [super hitTest:point withEvent:event];
//    while (hitView && hitView.superview != self)
//        hitView = hitView.superview;
//    return [self pointInside:point withEvent:event] ? self.scrollview : nil;
//}

@end
