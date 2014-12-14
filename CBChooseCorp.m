//
//  CBChooseCorp.m
//  CorpBoard
//
//  Created by Justin Moore on 12/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBChooseCorp.h"
#import "Parse/Parse.h"
#import "CBSingle.h"

@implementation CBChooseCorp {
    CBSingle *data;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        data = [CBSingle data];
        
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        
        // Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.y"
         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        // Add both effects to your view
        [self addMotionEffect:group];
        
    }
    return self;
}

-(void)showInParent:(CGRect)parent {
   
    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2), CGRectGetMidY(parent) - (self.frame.size.height / 2), self.frame.size.width, self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

@end
