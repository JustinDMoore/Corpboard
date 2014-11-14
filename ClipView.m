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
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView* child = nil;
    if ((child = [super hitTest:point withEvent:event]) == self)
        return self.scrollview;
    return child;
}

@end
