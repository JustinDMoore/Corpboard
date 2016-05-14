//
//  CadetsAnimation.h
//  CorpBoard
//
//  Created by Justin Moore on 5/6/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^animationCompletionBlock)(void);
#define kAnimationCompletionBlock @"animationCompletionBlock"

@interface CadetsAnimation : NSObject
-(void)doMaskAnimation:(UIView *)waretoLogoLarge;
@end