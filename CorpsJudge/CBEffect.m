//
//  CBEffect.m
//  CorpBoard
//
//  Created by Justin Moore on 1/17/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBEffect.h"

@implementation CBEffect
SKEmitterNode *emitter;

CGPoint snowLocation;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        self.backgroundColor = [SKColor blackColor];
        snowLocation = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 50);
    }
    return self;
}

-(void)startSnowing {
    
    [self addChild:[self newSnow:@"Snow"]];
}

-(void)startCadetSnowing {
    
    [self addChild:[self newSnow:@"CadetSnow"]];
}

-(void)stop {
    [emitter setParticleBirthRate:0];
    [emitter setParticleLifetime:0];
}

//particle explosion - uses MyParticle.sks
- (SKEmitterNode *) newSnow:(NSString *)type {
    
    if ([type isEqualToString:@"Snow"]) {
        emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Snow" ofType:@"sks"]];
    } else if ([type isEqualToString:@"CadetSnow"]) {
        emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"CadetSnow" ofType:@"sks"]];
    }
    
    emitter.position = snowLocation;
    emitter.name = @"Snow";
    emitter.targetNode = self.scene;
    emitter.numParticlesToEmit = 0;
    emitter.particleLifetime = 20;
    emitter.zPosition=2.0;
    return emitter;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

}

@end
