//
//  CBPush.m
//  Corpboard
//
//  Created by Justin Moore on 5/27/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBPush.h"
#import <AudioToolbox/AudioServices.h>

int tick;

@implementation CBPush


-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

-(void)showPush:(NSString *)push inParent:(UIView *)parent {
    
    self.lblMessage.text = push;
    
    tick = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(closePush)
                                           userInfo:nil
                                            repeats:YES];
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);

    
    self.clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - self.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.frame.size.height * 2)];
    self.clearView.backgroundColor = [UIColor clearColor];
    [parent addSubview:self.clearView];
    
    [self.clearView addSubview:self];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.clearView];
    
    UIGravityBehavior* gravityBehavior =
    [[UIGravityBehavior alloc] initWithItems:@[self]];
    [gravityBehavior setMagnitude:.8];
    [self.animator addBehavior:gravityBehavior];
    
    UICollisionBehavior* collisionBehavior =
    [[UICollisionBehavior alloc] initWithItems:@[self]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *elasticityBehavior =
    [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    elasticityBehavior.elasticity = 0.3f;
    [self.animator addBehavior:elasticityBehavior];
    
    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
    });
}

-(void)closePush {

    tick++;
    if (tick >= 4) {
        tick = 0;
        [self.timer invalidate];
        self.animator = nil;
        
        [UIView animateWithDuration:.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.frame = CGRectMake(0, 0-self.frame.size.height, self.frame.size.width, self.frame.size.height);
                            } completion:^(BOOL finished) {
                                [self removeFromSuperview];
                                [self.clearView removeFromSuperview];
                            }];
    }
}

@end
