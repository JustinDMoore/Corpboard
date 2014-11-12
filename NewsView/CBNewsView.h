//
//  CBNewsView.h
//  CorpBoard
//
//  Created by Justin Moore on 11/11/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface CBNewsView : UIView
IBInspectable @property (nonatomic, strong) UIColor *startColor;
IBInspectable @property (nonatomic, strong) UIColor *endColor;
IBInspectable @property (nonatomic) CGFloat corners;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end
