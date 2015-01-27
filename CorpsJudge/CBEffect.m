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
        [self clean];
    }
    return self;
}

-(void)clean {
    [self removeAllActions];
    [self removeAllChildren];
}

-(void)startSnowing {
    [self clean];
    [self addChild:[self newSnow:@"Snow"]];
}

-(void)startCadetSnowing {
    [self clean];
    [self addChild:[self newSnow:@"CadetSnow"]];
}

-(void)startRaining {
    [self clean];
    [self addChild:[self newSnow:@"Rain"]];
}

-(void)stop {
    
    for (SKEmitterNode *child in self.children) {
        [child setParticleBirthRate:0];
        [child setParticleLifetime:0];
    }
    [self clean];
}

-(void)prop {
    
    SKSpriteNode *plane = [SKSpriteNode spriteNodeWithImageNamed:@"plane2"];
    plane.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    SKAction *scale = [SKAction scaleBy:0.2 duration:0];
    [plane runAction:scale];
    
    SKSpriteNode *prop1 = [self getProp];
    prop1.position = CGPointMake(-355, -75);
    [plane addChild:prop1];
    
    SKSpriteNode *prop2 = [self getProp];
    prop2.position = CGPointMake(-170, -75);
    [plane addChild:prop2];
    
    SKSpriteNode *prop3 = [self getProp];
    prop3.position = CGPointMake(160, -75);
    [plane addChild:prop3];
    
    SKSpriteNode *prop4 = [self getProp];
    prop4.position = CGPointMake(350, -75);
    [plane addChild:prop4];

    [self addChild:plane];
}

-(SKSpriteNode *)getProp {
    
    SKSpriteNode *prop = [SKSpriteNode spriteNodeWithImageNamed:@"prop"];
    prop.size = CGSizeMake(90, 90);
    SKAction *oneRevolution = [SKAction rotateByAngle:M_PI*2 duration: .4];
    SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
    [prop runAction:repeat];
    return prop;
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
    
#define ARC4RANDOM_MAX      0x100000000
    
    double val = ((double)arc4random() / ARC4RANDOM_MAX);
    
    SKAction *scale = [SKAction scaleBy:val duration:0];
    [shootingstar runAction: scale completion:nil];
    SKAction *move = [SKAction moveByX:500 y:180 duration:2];
    int waitDuration = 2 + arc4random() % (10 - 2);
    SKAction *wait = [SKAction waitForDuration:waitDuration];
    SKAction *sequence = [SKAction sequence:@[wait, move]];
    [shootingstar runAction:sequence completion:^{
        [shootingstar removeFromParent];
        [self shootingStar];
    }];
}

-(void)goToSpace {
    [self clean];
    [self shootingStar];
    
    CGFloat lifetime;
    SKEmitterNode *emitterNode1 = [self starFieldEmitter:[SKColor lightGrayColor] starSpeedY:1 starsPerSecond:.1 starScaleFactor:0.08];
    emitterNode1.zPosition = -10;
    lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / 1;
    [emitterNode1 advanceSimulationTime:lifetime];
    [self addChild:emitterNode1];

    emitterNode1 = [self starFieldEmitter:[SKColor lightGrayColor] starSpeedY:.8 starsPerSecond:.08 starScaleFactor:0.06];
    emitterNode1.zPosition = -11;
    lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / .8;
    [emitterNode1 advanceSimulationTime:lifetime];
    [self addChild:emitterNode1];

    emitterNode1 = [self starFieldEmitter:[SKColor grayColor] starSpeedY:.5 starsPerSecond:.5 starScaleFactor:0.03];
    emitterNode1.zPosition = -12;
    lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / .5;
    [emitterNode1 advanceSimulationTime:lifetime];
    [self addChild:emitterNode1];
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
