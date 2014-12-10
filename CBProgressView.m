//
//  CBProgressView.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBProgressView.h"
#import "KVNProgress.h"


@implementation CBProgressView

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;


        [self setupProgressUI];
        [self progress];

    }
    return self;
}

-(void) setupProgressUI{
    
    [KVNProgress appearance].statusColor = [UIColor whiteColor];
    [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:237/255.0 alpha:1];
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor blackColor];
    [KVNProgress appearance].backgroundTintColor = [UIColor blackColor];
    [KVNProgress appearance].successColor = [UIColor darkGrayColor];
    [KVNProgress appearance].errorColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleSize = 75.0f;
    [KVNProgress appearance].lineWidth = 2.0f;
    [KVNProgress appearance].successColor = [UIColor greenColor];
    [KVNProgress appearance].errorColor = [UIColor redColor];
    
    
}

-(void)progress {
  
    [KVNProgress showProgress:0 parameters:
     @{KVNProgressViewParameterFullScreen: @(NO),
       KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
       KVNProgressViewParameterStatus: @"Loading",
       KVNProgressViewParameterSuperview: self
       }];
    
    [self updateProgress];

}

-(void)showSuccess {
    [self setupProgressUI];
    [KVNProgress showSuccessWithParameters:
     @{KVNProgressViewParameterFullScreen: @(NO),
       KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
       KVNProgressViewParameterStatus: @"Welcome",
       KVNProgressViewParameterSuperview: self
       }];
    [self performSelector:@selector(complete) withObject:self afterDelay:2];
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
        [KVNProgress updateProgress:[self getRandomProgressWithMin]
                           animated:YES];
    });
    
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC);
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        [KVNProgress updateProgress:[self getRandomProgressWithMin]
                           animated:YES];
    });
    
    dispatch_time_t popTime4 = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
    dispatch_after(popTime4, dispatch_get_main_queue(), ^(void){
        [KVNProgress updateProgress:[self getRandomProgressWithMin]
                           animated:YES];
    });
    
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)startProgress {
    [self progress];
}
-(void)stopProgress {
    
    dispatch_time_t popTime5 = dispatch_time(DISPATCH_TIME_NOW, 5.0f * NSEC_PER_SEC);
    dispatch_after(popTime5, dispatch_get_main_queue(), ^(void){
        [KVNProgress updateProgress:1.0f
                           animated:YES];
        [self showSuccess];
    });
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
    [self setupProgressUI];
    [KVNProgress showErrorWithParameters:
     @{KVNProgressViewParameterFullScreen: @(NO),
       KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
       KVNProgressViewParameterStatus: [NSString stringWithFormat:@"%@", error],
       KVNProgressViewParameterSuperview: self
       }];
}
@end
