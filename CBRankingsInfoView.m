//
//  CBRankingsInfoView.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/20/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBRankingsInfoView.h"

@implementation CBRankingsInfoView {
    CGRect parentRect;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.layer.cornerRadius = 8;
    }
    return self;
}

-(void)showInParent:(CGRect)parent {
    parentRect = parent;
    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2), CGRectGetMidY(parent) - (self.frame.size.height / 2), self.frame.size.width / 2, self.frame.size.height / 2);
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:8 options:0 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width * 2, self.frame.size.height * 2);
        self.center = self.superview.center;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)btnOK_clicked:(id)sender {
    
    [delegate viewDidClose];
    [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:3 options:0 animations:^{
        self.frame = CGRectMake(CGRectGetMidX(parentRect) - (self.frame.size.width), CGRectGetMidY(parentRect) - (self.frame.size.height), 0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
