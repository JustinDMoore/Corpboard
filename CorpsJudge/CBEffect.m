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

-(void)shootingStar {
    
    SKEmitterNode *shootingstar = [SKEmitterNode node];
    shootingstar =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"ShootingStar" ofType:@"sks"]];

    int test = self.frame.size.height;
    int y = 1 + arc4random() % (test - 1);
    
    snowLocation = CGPointMake(-10, y);
    shootingstar.position = snowLocation;
    shootingstar.name = @"shootingStar";
    shootingstar.targetNode = self.scene;
    //emitter.numParticlesToEmit = 0;
    //emitter.particleLifetime = 20;
    shootingstar.zPosition = 2.0;
    [self addChild:shootingstar];
    SKAction *move = [SKAction moveByX:500 y:130 duration:2];
    int waitDuration = 2 + arc4random() % (10 - 2);
    SKAction *wait = [SKAction waitForDuration:waitDuration];
    SKAction *sequence = [SKAction sequence:@[wait, move]];
    [shootingstar runAction:sequence completion:^{
        [shootingstar removeFromParent];
        [self shootingStar];
    }];
}

-(void)goToSpace {
    [self shootingStar];
    SKEmitterNode *emitterNode = [self starFieldEmitter:[SKColor lightGrayColor] starSpeedY:1 starsPerSecond:.1 starScaleFactor:0.08];
    emitterNode.zPosition = -10;
    [self addChild:emitterNode];

    emitterNode = [self starFieldEmitter:[SKColor lightGrayColor] starSpeedY:.8 starsPerSecond:.08 starScaleFactor:0.06];
    emitterNode.zPosition = -11;
    [self addChild:emitterNode];

    emitterNode = [self starFieldEmitter:[SKColor grayColor] starSpeedY:.5 starsPerSecond:.5 starScaleFactor:0.03];
    emitterNode.zPosition = -12;
    [self addChild:emitterNode];
}

-(SKEmitterNode *)starFieldEmitter:(SKColor *)color starSpeedY:(CGFloat)starSpeedY starsPerSecond:(CGFloat)starsPerSecond starScaleFactor:(CGFloat) starScaleFactor {
    
    SKEmitterNode *emitterNode = [SKEmitterNode node];
    
    CGFloat lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / starSpeedY;
    
    emitterNode.particleTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"stars"]];
    emitterNode.particleBirthRate = starsPerSecond;
    emitterNode.particleColor = [SKColor lightGrayColor];
    emitterNode.particleSpeed = starSpeedY * -1;
    emitterNode.particleScale = starScaleFactor;
    emitterNode.particleColorBlendFactor = 1;
    emitterNode.particleLifetime = lifetime;
    
    int rndValue = 1 + arc4random() % (45 - 1);
    emitterNode.particleRotation = rndValue;
    
    emitterNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
    emitterNode.particlePositionRange = CGVectorMake(self.frame.size.width, self.frame.size.height);
    [emitterNode advanceSimulationTime:lifetime];
    return emitterNode;
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
