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
    }
    return self;
}

-(void)startSnowing {
    
    [self addChild:[self newSnow:@"Snow"]];
}

-(void)startCadetSnowing {
    
    [self addChild:[self newSnow:@"CadetSnow"]];
}

-(void)startRaining {
    
    [self addChild:[self newSnow:@"Rain"]];
}

-(void)stop {
    
    for (SKEmitterNode *child in self.children) {
        [child setParticleBirthRate:0];
        [child setParticleLifetime:0];
    }
}

-(void)goToSpace {
    
    [self addChild:[self newSnow:@"Stars"]];
    emitter.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
}

//particle explosion - uses MyParticle.sks
- (SKEmitterNode *) newSnow:(NSString *)type {
    
    snowLocation = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 50);
    
    if ([type isEqualToString:@"Snow"]) {
        emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Snow" ofType:@"sks"]];
    } else if ([type isEqualToString:@"CadetSnow"]) {
        emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"CadetSnow" ofType:@"sks"]];
    } else if ([type isEqualToString:@"Rain"]) {
        emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Rain" ofType:@"sks"]];
    } else if ([type isEqualToString:@"Stars"]) {
        emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"]];
    }
    
    emitter.position = snowLocation;
    emitter.name = @"Snow";
    emitter.targetNode = self.scene;
    //emitter.numParticlesToEmit = 0;
    //emitter.particleLifetime = 20;
    emitter.zPosition=2.0;
    return emitter;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

}

@end
