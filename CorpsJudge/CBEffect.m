//
//  CBEffect.m
//  CorpBoard
//
//  Created by Justin Moore on 1/17/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBEffect.h"

@interface CBEffect()
@property (nonatomic, strong) SKEmitterNode *rainEmitter;
@end

@implementation CBEffect

CGPoint snowLocation;

// outer space
BOOL inOuterSpace = NO;
SKEmitterNode *starEmitter1;
SKEmitterNode *starEmitter2;
SKEmitterNode *starEmitter3;

// perilous skies
BOOL skiesArePerilous = NO;
SKSpriteNode *plane;

// blizard
BOOL coldOutside = NO;
SKEmitterNode *snowEmitter;

//christmas time
BOOL isChristmas = NO;
SKEmitterNode *snowFlakeEmitter;

//wet
BOOL isRaining = NO;

//grass
BOOL hasGrass = NO;
SKSpriteNode *spriteGrass;

//machine
BOOL machineOn = NO;
SKSpriteNode *spriteGearLarge;
SKSpriteNode *spriteGearSmall;

//planets
BOOL planetsOn = NO;
SKSpriteNode *spriteMars;
SKSpriteNode *spriteMercury;
SKSpriteNode *spriteVenus;
SKSpriteNode *spriteJupiter;

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
       
        self.backgroundColor = [SKColor blackColor];
    }
    return self;
}

-(void)stop {
    
    if (inOuterSpace) [self landFromOuterSpace];
    if (skiesArePerilous) [self tameThePerilousSkies];
    if (coldOutside) [self stopSnowing];
    if (isChristmas) [self stopCadetSnowing];
    if (isRaining) [self stopRaining];
    if (hasGrass) [self killGrass];
    if (machineOn) [self killTheMachine];
    if (planetsOn) [self hidePlanets];
}

#pragma mark
#pragma mark - Cadet Christmas
#pragma mark

-(void)startCadetSnowing {
    
    if (!isChristmas) {
        [self stop];
        isChristmas = YES;
        [snowFlakeEmitter removeFromParent];
        snowFlakeEmitter = nil;
        snowFlakeEmitter = [self newEmitter:@"CadetSnow"];
        [self addChild:snowFlakeEmitter];
    }
}

-(void)stopCadetSnowing {
    
    snowFlakeEmitter.particleBirthRate = 0;
    snowFlakeEmitter.particleLifetime = 0;
    snowFlakeEmitter.particleLifetimeRange = 0;
    isChristmas = NO;
}

#pragma mark
#pragma mark - Wet day
#pragma mark

-(void)startRaining {
    
    if (!isRaining) {
        [self stop];
        isRaining = YES;
        [self.rainEmitter removeFromParent];
        if (self.rainEmitter) {
            self.rainEmitter = nil;
        }
        self.rainEmitter = [self newEmitter:@"Rain"];
        [self addChild:self.rainEmitter];
    }
}

-(void)stopRaining {
    
    self.rainEmitter.particleBirthRate = 0;
    self.rainEmitter.particleLifetime = 0;
    self.rainEmitter.particleLifetimeRange = 0;
    isRaining = NO;
}

#pragma mark
#pragma mark - Planets
#pragma mark

-(void)showPlanets {
    
    if (!planetsOn) {
        [self stop];
        planetsOn = YES;
        
        spriteMars = [SKSpriteNode spriteNodeWithImageNamed:@"mars"];
        spriteMars.size = CGSizeMake(50, 50);
        spriteMars.position = CGPointMake(300, 400);
        spriteMars.alpha = 0;
        spriteMars.name = @"Mars";
        
        spriteMercury = [SKSpriteNode spriteNodeWithImageNamed:@"mercury1"];
        spriteMercury.size = CGSizeMake(20, 20);
        spriteMercury.position = CGPointMake(300, 400);
        spriteMercury.alpha = 0;
        spriteMercury.name = @"Mercury";
        
        spriteVenus = [SKSpriteNode spriteNodeWithImageNamed:@"venus"];
        spriteVenus.size = CGSizeMake(30, 30);
        spriteVenus.position = CGPointMake(300, 400);
        spriteVenus.alpha = 0;
        spriteVenus.name = @"Venus";
        
        spriteJupiter = [SKSpriteNode spriteNodeWithImageNamed:@"jupiter"];
        spriteJupiter.size = CGSizeMake(65, 65);
        spriteJupiter.position = CGPointMake(300, 400);
        spriteJupiter.alpha = 0;
        spriteJupiter.name = @"Jupiter";
        
        if (planetsOn) [self rotatePlanet:spriteMars];
    }
}

-(void)rotatePlanet:(SKSpriteNode *)planet {
    
    [self addChild:planet];
    
    SKAction *show = [SKAction fadeAlphaTo:1 duration:.5];
    
    SKAction *moveleft = [SKAction moveToX:85 duration:3];
    moveleft.timingMode = SKActionTimingEaseOut;
    
    SKAction *moveright = [SKAction moveToX:230 duration:4];
    moveright.timingMode = SKActionTimingEaseIn;
    
    SKAction *moveGroup = [SKAction sequence:@[moveleft, moveright]];
    
    SKAction *movedown;
    if ([planet.name isEqualToString:@"Jupiter"]) {
        movedown = [SKAction moveToY:-400 duration:6]; //has to move more because she's bigger
    } else {
        movedown = [SKAction moveToY:-200 duration:6];
    }

    SKAction *grow = [SKAction scaleBy:10 duration:6];
    SKAction *group = [SKAction group:@[show, moveGroup, movedown, grow]];

    [planet runAction:group completion:^{
        [planet removeFromParent];
        if (planetsOn) {
            if ([planet.name isEqualToString:@"Mars"]) [self rotatePlanet:spriteVenus];
            if ([planet.name isEqualToString:@"Venus"]) [self rotatePlanet:spriteMercury];
            if ([planet.name isEqualToString:@"Mercury"]) [self rotatePlanet:spriteJupiter];
        }
    }];
}

-(void)hidePlanets {
    
    planetsOn = NO;
    SKAction *kill = [SKAction fadeAlphaTo:0 duration:1.5];
    
    [spriteMars runAction:kill
               completion:^{
                   [spriteMars removeFromParent];
               }];
    
    [spriteMercury runAction:kill
               completion:^{
                   [spriteMercury removeFromParent];
               }];
    
    [spriteVenus runAction:kill
               completion:^{
                   [spriteVenus removeFromParent];
               }];
    
    [spriteJupiter runAction:kill
               completion:^{
                   [spriteJupiter removeFromParent];
               }];
}

#pragma mark
#pragma mark - Always Greener
#pragma mark

-(void)growGrass {
    
    if (!hasGrass) {
        [self stop];
        hasGrass = YES;
        
        spriteGrass = [SKSpriteNode spriteNodeWithImageNamed:@"grass"];
        spriteGrass.size = CGSizeMake(self.size.width, 100);

        spriteGrass.position = CGPointMake(CGRectGetMidX(self.frame), 0 - spriteGrass.size.height);
        
        spriteGrass.alpha = 0;
        [self addChild:spriteGrass];
        SKAction *show = [SKAction fadeAlphaTo:1 duration:.5];
        SKAction *move = [SKAction moveToY:0 + (spriteGrass.size.height / 2) duration:.5];
        SKAction *group = [SKAction group:@[show, move]];
        [spriteGrass runAction:group];
    }
}

-(void)killGrass {
    
    hasGrass = NO;
    SKAction *kill = [SKAction fadeAlphaTo:0 duration:3];
    SKAction *kill2 = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:2];
    SKAction *move = [SKAction moveToY:0 duration:3];
    SKAction *group = [SKAction group:@[kill, kill2, move]];
    [spriteGrass runAction:group completion:^{
        [spriteGrass removeFromParent];
    }];
}

#pragma mark
#pragma mark - Machine
#pragma mark

-(void)startTheMachine {
    
    if (!machineOn) {
        [self stop];
        machineOn = YES;
        
        spriteGearLarge = [SKSpriteNode spriteNodeWithImageNamed:@"gear_large"];
        spriteGearSmall = [SKSpriteNode spriteNodeWithImageNamed:@"gear_small"];
        
        spriteGearLarge.size = CGSizeMake(100, 100);
        spriteGearSmall.size = CGSizeMake(75, 75);
        spriteGearLarge.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        spriteGearSmall.position = CGPointMake(CGRectGetMidX(self.frame) + 60, CGRectGetMidY(self.frame) - 55);
        
        spriteGearLarge.alpha = 0;
        spriteGearSmall.alpha = 0;
        
        [self addChild:spriteGearSmall];
        [self addChild:spriteGearLarge];
        
        SKAction *show = [SKAction fadeAlphaTo:.2 duration:2];
        
        SKAction *oneRevolutionLarge = [SKAction rotateByAngle:-M_PI*2 duration: 7.0];
        SKAction *repeatLarge = [SKAction repeatActionForever:oneRevolutionLarge];
        
        SKAction *oneRevolutionSmall = [SKAction rotateByAngle:M_PI*2 duration: 4.44];
        SKAction *repeatSmall = [SKAction repeatActionForever:oneRevolutionSmall];
        
        [spriteGearLarge runAction:repeatLarge];
        [spriteGearSmall runAction:repeatSmall];
        
        [spriteGearLarge runAction:show];
        [spriteGearSmall runAction:show];
    }
}

-(void)killTheMachine {
    
    machineOn = NO;
    SKAction *kill = [SKAction fadeAlphaTo:0 duration:3];

    [spriteGearLarge runAction:kill completion:^{
        if (!machineOn) [spriteGearLarge removeAllActions];
        if (!machineOn) [spriteGearLarge removeFromParent];
    }];
    [spriteGearSmall runAction:kill completion:^{
        if (!machineOn) [spriteGearSmall removeAllActions];
        if (!machineOn) [spriteGearSmall removeFromParent];
    }];
}

#pragma mark
#pragma mark - Cold Outside
#pragma mark

-(void)startSnowing {
    
    if (!coldOutside) {
        [self stop];
        coldOutside = YES;
        [snowEmitter removeFromParent];
        snowEmitter = nil;
        snowEmitter = [self newEmitter:@"Snow"];
        [self addChild:snowEmitter];
    }
}

-(void)stopSnowing {
    
    snowEmitter.particleBirthRate = 0;
    snowEmitter.particleLifetime = 0;
    snowEmitter.particleLifetimeRange = 0;
    coldOutside = NO;
}

#pragma mark
#pragma mark - Perilous Skies
#pragma mark

-(void)perilousSkies:(CGRect)rect {
    
    if (!skiesArePerilous) {
        [self stop];
        skiesArePerilous = YES;
        
        plane = [SKSpriteNode spriteNodeWithImageNamed:@"plane4"];
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
}

-(SKSpriteNode *)getProp {
    
    SKSpriteNode *prop = [SKSpriteNode spriteNodeWithImageNamed:@"prop"];
    prop.size = CGSizeMake(90, 90);
    SKAction *oneRevolution = [SKAction rotateByAngle:M_PI*2 duration: .4];
    SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
    [prop runAction:repeat];
    return prop;
}

-(void)tameThePerilousSkies {
    
    [plane runAction:[SKAction fadeOutWithDuration:2] completion:^{
        [plane removeFromParent];
        plane = nil;
        skiesArePerilous = NO;
    }];
}

#pragma mark
#pragma mark - Outer Space
#pragma mark

-(void)launchToSpace {

    if (!inOuterSpace) {
        [self stop];
        inOuterSpace = YES;
        
        [self shootingStar];
        
        double lifetime;
        starEmitter1 = [self starFieldEmitter:[SKColor lightGrayColor] starSpeedY:1 starsPerSecond:.1 starScaleFactor:0.08];
        
        lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / 1;
        [starEmitter1 advanceSimulationTime:lifetime];
        starEmitter1.zPosition = -10;
        starEmitter1.name = @"starfield";
        [self addChild:starEmitter1];
        
        starEmitter2 = [self starFieldEmitter:[SKColor lightGrayColor] starSpeedY:.8 starsPerSecond:.08 starScaleFactor:0.06];
        starEmitter2.zPosition = -11;
        lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / .8;
        [starEmitter2 advanceSimulationTime:lifetime];
        starEmitter2.name = @"starfield";
        [self addChild:starEmitter2];
        
        starEmitter3 = [self starFieldEmitter:[SKColor grayColor] starSpeedY:.5 starsPerSecond:.5 starScaleFactor:0.03];
        starEmitter3.zPosition = -12;
        lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / .5;
        [starEmitter3 advanceSimulationTime:lifetime];
        starEmitter3.name = @"starfield";
        [self addChild:starEmitter3];
        
        id wait = [SKAction waitForDuration:2];
        id run = [SKAction runBlock:^{
            [self shootingStar];
        }];
        [self.scene runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait, run]]] withKey:@"shootingStars"];
    }
}

-(SKEmitterNode *)starFieldEmitter:(SKColor *)color starSpeedY:(CGFloat)starSpeedY starsPerSecond:(CGFloat)starsPerSecond starScaleFactor:(CGFloat) starScaleFactor {
    
    SKEmitterNode *emitterNode = [SKEmitterNode node];
    
    CGFloat lifetime = self.frame.size.height * [[UIScreen mainScreen] scale] / starSpeedY;
    
    emitterNode.particleTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"Stars"]];
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
    shootingstar =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"shootingStar" ofType:@"sks"]];
    
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
    }];
}

-(void)landFromOuterSpace {
    
    [self.scene removeActionForKey:@"shootingStars"];
    
    [starEmitter1 removeFromParent];
    starEmitter1 = nil;
    
    [starEmitter2 removeFromParent];
    starEmitter2 = nil;
    
    [starEmitter3 removeFromParent];
    starEmitter3 = nil;
    
    for (SKEmitterNode *emitter in self.children) {
        if ([emitter.name isEqualToString:@"shootingStar"]) {
            emitter.particleBirthRate = 0;
        }
    }
    
    inOuterSpace = NO;
}

-(SKEmitterNode *)newEmitter:(NSString *)type {
    
    snowLocation = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 50);
    
    SKEmitterNode *emitter = [SKEmitterNode node];
    
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

-(float)randFloatBetween:(float)low and:(float)high {
    
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

-(BOOL)getYesOrNo {
    
    int tmp = (arc4random() % 30)+1;
    if(tmp % 5 == 0)
        return YES;
    return NO;
}

@end
