//
//  CBMakeFinalsPrediction.m
//  CorpBoard
//
//  Created by Isaias Favela on 5/14/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBMakeFinalsPrediction.h"

@implementation CBMakeFinalsPrediction

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)show {

    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.backgroundColor = [UIColor clearColor];
    
    self.btnMakePrediction.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnMakePrediction.layer.borderWidth = 1;
    self.btnMakePrediction.layer.cornerRadius = 5;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self.viewBlur = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    self.viewBlur.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self.parentNav.view addSubview:self.viewBlur];
    [self.parentNav.view bringSubviewToFront:self.viewBlur];
    [self.viewBlur addSubview:self];
    [self.parentNav.view bringSubviewToFront:self];
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:.9
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                     } completion:nil];
}


-(void)dismissView:(BOOL)makePrediction {
    
    [UIView animateWithDuration:0.25
                          delay:0.09
         usingSpringWithDamping:1
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.viewBlur.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
                     } completion:^(BOOL finished){
                         
                         [self.viewBlur removeFromSuperview];
                         if (makePrediction) {
                             if ([delegate respondsToSelector:@selector(makePrediction)]) {
                                 [delegate makePrediction];
                             }
                         }
                     }];
}

#pragma mark
#pragma mark - Actions
#pragma mark

- (IBAction)btnNotNow_tapped:(id)sender {
    
    [self dismissView:NO];
}

- (IBAction)btnMakePrediction_tapped:(id)sender {
    
    [self dismissView:YES];
}

@end
