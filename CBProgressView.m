//
//  CBProgressView.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBProgressView.h"

@implementation CBProgressView

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;

        self.backgroundColor = [UIColor orangeColor];
        self.customConfiguration = [self customKVNProgressUIConfiguration];
        [KVNProgress setConfiguration:self.customConfiguration];
        [self progress];

    }
    return self;
}

- (KVNProgressConfiguration *)customKVNProgressUIConfiguration
{
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    // See the documentation of KVNProgressConfiguration
    configuration.statusColor = [UIColor whiteColor];
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    configuration.circleStrokeForegroundColor = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:237/255.0 alpha:1];
    configuration.circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    configuration.circleFillBackgroundColor = [UIColor clearColor];
    configuration.backgroundFillColor = [UIColor clearColor];
    configuration.backgroundTintColor = [UIColor clearColor];
    configuration.successColor = [UIColor greenColor];
    configuration.errorColor = [UIColor redColor];
    configuration.circleSize = 75.0f;
    configuration.lineWidth = 2.0f;
    configuration.backgroundType = KVNProgressBackgroundTypeSolid;
    configuration.fullScreen = NO;
    configuration.minimumSuccessDisplayTime = .5;

    return configuration;
}

-(void)progress {
    
    //[KVNProgress showProgress:0];
    [KVNProgress showProgress:0
                       status:nil
                       onView:self.viewProgress];
    [self updateProgress];

}

-(void)showSuccess {
    
    [KVNProgress showSuccessWithStatus:nil
                                onView:self.viewProgress
                            completion:^{
                                [self complete];
                            }];
//    [KVNProgress showSuccessWithCompletion:^{
//        [self complete];
//    }];
}

-(void)complete {
    [delegate progressComplete];
}

#define ARC4RANDOM_MAX 0x100000000
float currentProgress = 0;
-(double)getRandomProgressWithMin {

    double val = ((double)arc4random() / ARC4RANDOM_MAX)
    * ((currentProgress + .25) - currentProgress)
    + currentProgress;
    if (val > .85) {
        val = .85;
    }
    currentProgress = val;
    return val;
}

- (void)updateProgress
{
    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC);
    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
        [self updateWithProgress:[self getRandomProgressWithMin]];
    });
    
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC);
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        [self updateWithProgress:[self getRandomProgressWithMin]];
    });
    
    dispatch_time_t popTime4 = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
    dispatch_after(popTime4, dispatch_get_main_queue(), ^(void){
        [self updateWithProgress:[self getRandomProgressWithMin]];
    });
    
}

-(void)updateWithProgress:(double)progress {
    
    if (!isComplete) {
        [KVNProgress updateProgress:progress
                           animated:YES];
    }
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)startProgress {
    [self progress];
}

BOOL isComplete = NO;
-(void)completeProgress {
    
    isComplete = YES;
    [KVNProgress updateProgress:1.0f
                       animated:YES];
    [self performSelector:@selector(showSuccess) withObject:self afterDelay:.4];
}

-(void)setFact:(NSString*)fact {
    self.lblFact.alpha = 0;
    self.lblFactHeader.alpha = 0;
    self.lblFact.text = fact;
    self.lblFact.hidden = NO;
    self.lblFactHeader.hidden = NO;
    [self.lblFact sizeToFit];
    [self bringSubviewToFront:self.lblFactHeader];
    [self performSelector:@selector(animateLabel:) withObject:self.lblFactHeader afterDelay:0];
    
    [self performSelector:@selector(animateLabel:) withObject:self.lblFact afterDelay:.1];
    
    
    
}

-(void)animateLabel:(UILabel *)label {
    
    [UIView animateWithDuration:.6
                     animations:^{
                         label.alpha = 1;
                         label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y - 5, label.frame.size.width, label.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)errorProgress:(NSString *)error {

    [KVNProgress showErrorWithStatus:error
                              onView:self];
}
@end
