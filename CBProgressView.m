//
//  CBProgressView.m
//  CorpBoard
//
//  Created by Isaias Favela on 11/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBProgressView.h"
#import "Configuration.h"

@implementation CBProgressView {
    
}

float minimumLoadTime = 3; //seconds


-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        
    }
    return self;
}

int x = 0;

-(void)tickTock:(NSTimer *)timer {
    
    if ([delegate respondsToSelector:@selector(tick)]) {
        [delegate tick];
    }
    
    x++;
    NSLog(@"%i", x);
    
    if (isComplete && (x > minimumLoadTime)) {
        NSLog(@"+ - %i", x);
        x = 0;
        [self.tmrProgress invalidate];
        self.tmrProgress = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [KVNProgress updateProgress:1.0f
                               animated:YES];
            [self performSelector:@selector(showSuccess) withObject:self afterDelay:.4];
        });
    }
}

-(void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.viewProgress.backgroundColor = [UIColor clearColor];
    //[self progress];
}

-(void)progress {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress showProgress:0
                           status:nil
                           onView:self.viewProgress];
        [self updateProgress];
    });
}

-(void)showSuccess {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress showSuccessWithStatus:nil
                                    onView:self.viewProgress
                                completion:^{
                                    [self complete];
                                }];
    });
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

-(void)updateProgress {
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress updateProgress:progress
                           animated:YES];
    });
}

-(void)setDelegate:(id)newDelegate {
    
    delegate = newDelegate;
}

-(void)startProgress {
    
    if (!isComplete) {
        x = 0;
        [self progress];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tmrProgress = [NSTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(tickTock:)
                                                              userInfo:nil
                                                               repeats:YES];
        });
    }
}

BOOL isComplete = NO;
-(void)completeProgress {
    
    isComplete = YES;
}

-(void)setFact:(NSString*)fact {
    
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        NSLog(@"3.5 inch screen");
    } else {
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration errorProgressConfig]];
        [KVNProgress showErrorWithStatus:error
                                  onView:self];
        [self.tmrProgress invalidate];
        self.tmrProgress = nil;
    });
}
@end
