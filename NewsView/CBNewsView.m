//
//  CBNewsView.m
//  CorpBoard
//
//  Created by Justin Moore on 11/11/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNewsView.h"

@implementation CBNewsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}


-(void)setupView {
    NSArray *colors = @[self.startColor, self.endColor];
    self.gradientLayer.colors = colors;
    self.gradientLayer.cornerRadius = self.corners;
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    [self setNeedsDisplay];
}

-(void)setStartColor:(UIColor *)startColor {
    [self setupView];
}

-(void)setEndColor:(UIColor *)endColor {
    [self setupView];
}

-(void)setCorners:(CGFloat *)corners {
    [self setupView];
}

@end
