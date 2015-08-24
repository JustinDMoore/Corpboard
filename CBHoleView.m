//
//  CBHoleView.m
//  Corpboard
//
//  Created by Isaias Favela on 8/23/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBHoleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CBHoleView

-(id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)color andTransparentRects:(NSArray *)rects {

    backgroundColor = color;
    rectsArray = rects;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rect {
    // Drawing code
    [backgroundColor setFill];
    UIRectFill(rect);
    
    // clear the background in the given rectangles
    for (NSValue *holeRectValue in rectsArray) {
        CGRect holeRect = [holeRectValue CGRectValue];
        CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
        [[UIColor clearColor] setFill];
        UIRectFill(holeRectIntersection);
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // If the hitView is THIS view, return nil and allow hitTest:withEvent: to
    // continue traversing the hierarchy to find the underlying view.
    if (hitView == self) {
        return nil;
    }
    // Else return the hitView (as it could be one of this view's buttons):
    return hitView;
}

@end
