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
        self.progressView.progress = 0;
        self.theBool = false;
        //0.01667 is roughly 1/60, so it will update at 60 FPS


    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)timerCallback {
    if (self.theBool) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.myTimer invalidate];
        }
        else {
            self.progressView.progress += 0.005;
        }
    }
    else {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.90) {
            self.progressView.progress = 0.90;
        }
    }
}

-(void)startProgress {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                    target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}
-(void)stopProgress {
    
    self.theBool = true;
    [self.myTimer invalidate];
    self.myTimer = nil;
    self.progressView.progress = 100;
}

@end
