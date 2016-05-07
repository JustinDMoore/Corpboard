//
//  CadetsAnimation.m
//  CorpBoard
//
//  Created by Justin Moore on 5/6/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

#import "CadetsAnimation.h"

@implementation CadetsAnimation



- (void)doMaskAnimation:(UIView *)waretoLogoLarge {
    
    
    animationCompletionBlock theBlock;
    waretoLogoLarge.hidden = FALSE;//Show the image view
    
    //Create a shape layer that we will use as a mask for the waretoLogoLarge image view
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    
    
    CGFloat maskHeight = waretoLogoLarge.layer.bounds.size.height;
    CGFloat maskWidth = waretoLogoLarge.layer.bounds.size.width;
    
    
    CGPoint centerPoint;
    centerPoint = CGPointMake( maskWidth/2, maskHeight/2);
    
    //Make the radius of our arc large enough to reach into the corners of the image view.
    CGFloat radius = sqrtf(maskWidth * maskWidth + maskHeight * maskHeight)/2;
    //  CGFloat radius = MIN(maskWidth, maskHeight)/2;
    
    //Don't fill the path, but stroke it in black.
    maskLayer.fillColor = [[UIColor clearColor] CGColor];
    maskLayer.strokeColor = [[UIColor blackColor] CGColor];
    
    maskLayer.lineWidth = radius; //Make the line thick enough to completely fill the circle we're drawing
    //  maskLayer.lineWidth = 10; //Make the line thick enough to completely fill the circle we're drawing
    
    CGMutablePathRef arcPath = CGPathCreateMutable();
    
    //Move to the starting point of the arc so there is no initial line connecting to the arc
    CGPathMoveToPoint(arcPath, nil, waretoLogoLarge.frame.size.width, centerPoint.y-radius/2);
    
    //Create an arc at 1/2 our circle radius, with a line thickess of the full circle radius
    CGPathAddArc(arcPath,
                 nil,
                 centerPoint.x,
                 centerPoint.y,
                 radius/2,
                 3*M_PI/2,
                 -M_PI/2,
                 YES);
    
    maskLayer.path = arcPath;
    
    //Start with an empty mask path (draw 0% of the arc)
    maskLayer.strokeEnd = 0.0;
    
    
    CFRelease(arcPath);
    
    //Install the mask layer into out image view's layer.
    waretoLogoLarge.layer.mask = maskLayer;
    
    //Set our mask layer's frame to the parent layer's bounds.
    waretoLogoLarge.layer.mask.frame = waretoLogoLarge.layer.bounds;
    
    //Create an animation that increases the stroke length to 1, then reverses it back to zero.
    CABasicAnimation *swipe = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    swipe.duration = 1.4;
    swipe.delegate = self;
    [swipe setValue: theBlock forKey: kAnimationCompletionBlock];
    
    swipe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    swipe.fillMode = kCAFillModeForwards;
    swipe.removedOnCompletion = NO;
    swipe.autoreverses = NO;
    
    swipe.toValue = [NSNumber numberWithFloat: 1.0];
    
    //Set up a completion block that will be called once the animation is completed.
    theBlock = ^void(void)
    {
//        stopAnimationButton.enabled = FALSE;
//        
//        waretoLogoLarge.layer.mask = nil;
//        self.animationInFlight = FALSE;
//        animateButton.enabled = TRUE;
//        viewAnimationButton.enabled = TRUE;
//        maskAnimationButton.enabled = TRUE;
//        tapInstructionsLabel.hidden = TRUE;
//        
//        
//        waretoLogoLarge.hidden = TRUE;
//        doingMaskAnimation = FALSE;
//        
//        if (myContainerView.layer.speed == 0)
//            [self removePauseForLayer: myContainerView.layer];
    };
    
    /*
     Install the completion block in the animation using the key kAnimationCompletionBlock
     The completion block will be run by in the animation's animationDidStop:finished delegate method.
     This approach doesn't work for animations that are part of a group, unfortunately, since an animation's
     delegate methods don't get called when the animation is part of an animation group
     */
    
    [swipe setValue: theBlock forKey: kAnimationCompletionBlock];
    
    //doingMaskAnimation = TRUE;
    [maskLayer addAnimation: swipe forKey: @"strokeEnd"];
    
}



@end
