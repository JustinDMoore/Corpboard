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

-(void)perilousSkies:(CGRect)rect {
    
    SKSpriteNode *plane = [SKSpriteNode spriteNodeWithImageNamed:@"plane4"];
    SKAction *scale = [SKAction scaleBy:0.1 duration:0];
    [plane runAction:scale];
    plane.position = CGPointMake(CGRectGetMidX(rect), self.size.height - 160);
    
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

    plane.alpha = 0;
    [self addChild:plane];
    SKAction *show = [SKAction fadeAlphaTo:1 duration:3];
    SKAction *grow = [SKAction scaleBy:1.4 duration:3];
    SKAction *group = [SKAction group:@[show, grow]];
    [plane runAction:group];
}

-(SKSpriteNode *)getProp {
    
    SKSpriteNode *prop = [SKSpriteNode spriteNodeWithImageNamed:@"prop"];
    prop.size = CGSizeMake(90, 90);
    SKAction *oneRevolution = [SKAction rotateByAngle:M_PI*2 duration: .4];
    SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
    [prop runAction:repeat];
    return prop;
}

-(BOOL) getYesOrNo {
    
    int tmp = (arc4random() % 30)+1;
    if(tmp % 5 == 0)
        return YES;
    return NO;
}

-(void)shootingStar {
    
    BOOL left = [self getYesOrNo];
    int xPos = 0;
    int height = self.frame.size.height;
    int yPos = 1 + arc4random() % (height - 1);
    if (left) {
        xPos = -50;
    } else {
        xPos = self.frame.size.width + 50;
    }
    
    SKEmitterNode *shootingstar = [SKEmitterNode node];
    shootingstar =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"]];

    CGPoint xy = CGPointMake(xPos, yPos);
    shootingstar.position = xy;
    shootingstar.name = @"shootingStar";
    shootingstar.zPosition = -2.0;
    shootingstar.targetNode = self.scene;
    [self addChild:shootingstar];
    
    //make random size to simulate distance
    float val = [self randFloatBetween:.1 and:.5];
    SKAction *scale = [SKAction scaleBy:val duration:0];
    [shootingstar runAction: scale completion:nil];
    
    //now set speed depending on size (smaller = farther = slower)
    int dur = 0;
    if (val < .2) dur = 5;
    else if (val < .35) dur = 3;
    else dur = 2;
    
    int moveY = -500 + arc4random() % (500 - -500);
    int moveX;
    if (left) {
        moveX = 500;
    } else {
        moveX = -500;
    }
    SKAction *move = [SKAction moveByX:moveX y:moveY duration:dur];
    int waitDuration = 2 + arc4random() % (5 - 2);
    SKAction *wait = [SKAction waitForDuration:waitDuration];
    SKAction *sequence = [SKAction sequence:@[wait, move]];

    [shootingstar runAction:sequence completion:^{
        [shootingstar removeFromParent];
        //[self shootingStar];
    }];
}

-(float) randFloatBetween:(float)low and:(float)high {
    
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

-(void)goToSpace {

    [self shootingStar];
    
    double lifetime;
    SKEmitterNode *emitterNode1 = [self starFieldEmitter:[SKColor lightGrayColor] starSpeedY:1 starsPerSecond:.1 starScaleFactor:0.08];
    
    lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / 1;
    [emitterNode1 advanceSimulationTime:lifetime];
    emitterNode1.zPosition = -10;
    [self addChild:emitterNode1];

    SKEmitterNode *emitterNode2 = [self starFieldEmitter:[SKColor lightGrayColor] starSpeedY:.8 starsPerSecond:.08 starScaleFactor:0.06];
    emitterNode2.zPosition = -11;
    lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / .8;
    [emitterNode2 advanceSimulationTime:lifetime];
    [self addChild:emitterNode2];

    SKEmitterNode *emitterNode3 = [self starFieldEmitter:[SKColor grayColor] starSpeedY:.5 starsPerSecond:.5 starScaleFactor:0.03];
    emitterNode3.zPosition = -12;
    lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / .5;
    [emitterNode3 advanceSimulationTime:lifetime];
    [self addChild:emitterNode3];
    
    space = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(shootingStar) userInfo:nil repeats:YES];

}

NSTimer *space;

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
