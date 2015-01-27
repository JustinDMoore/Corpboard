//
//  CBEffect.h
//  CorpBoard
//
//  Created by Justin Moore on 1/17/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CBEffect : SKScene

-(void)stop;
-(void)startCadetSnowing;
-(void)startSnowing;
-(void)perilousSkies:(CGRect)rect;
-(void)launchToSpace;

@end
