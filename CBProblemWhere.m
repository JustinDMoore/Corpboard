//
//  CBProblemWhere.m
//  CorpBoard
//
//  Created by Isaias Favela on 1/4/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBProblemWhere.h"

@implementation CBProblemWhere {
    CGRect parentRect;
}


-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.arrayOfProblemAreas = @[@"About the Corps",
                                     @"Friends or Profiles",
                                     @"Live Chat",
                                     @"News",
                                     @"Private Messages",
                                     @"Rankings",
                                     @"Scores",
                                     @"Show Information",
                                     @"Show Reviews",
                                     @"Other"];
        
        self.layer.cornerRadius = 8;
        
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

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent:(CGRect)parent {
    parentRect = parent;
    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2),
                            CGRectGetMidY(parent) - (self.frame.size.height / 1.5),
                            self.frame.size.width,
                            self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);

    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)btnCancel_clicked:(id)sender {
    [self closeView:YES];
}

-(void)closeView:(BOOL)cancelled {
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:8 options:0 animations:^{
        
        self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:8
                            options:0
                         animations:^{
                             self.transform = CGAffineTransformScale(self.transform, 0.1f, 0.1f);
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             if ([delegate respondsToSelector:@selector(problemWhereCanceled)]) {
                                 [delegate problemWhereCanceled];
                             }
                         }];
    }];
    
}

-(NSArray *)arrayOfProblemAreas {
    if (!_arrayOfProblemAreas) {
        _arrayOfProblemAreas = [NSArray array];
    }
                                return _arrayOfProblemAreas;
}
@end
