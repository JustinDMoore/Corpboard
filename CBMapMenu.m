//
//  CBMapMenu.m
//  CorpBoard
//
//  Created by Justin Moore on 4/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBMapMenu.h"

@implementation CBMapMenu {
    CGRect parentRect;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        visualEffectView.frame = self.bounds;
        [self addSubview:visualEffectView];
        [self sendSubviewToBack:visualEffectView];
    }
    return self;
}


-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent:(CGRect)parent {
    
    parentRect = parent;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.alpha = 0;
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)closeView {
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
