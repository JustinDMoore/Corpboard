////
////  CBLocationServicesDisabled.m
////  Corpboard
////
////  Created by Justin Moore on 5/23/15.
////  Copyright (c) 2015 Justin Moore. All rights reserved.
////
//
//#import "CBLocationServicesDisabled.h"
//
//@implementation CBLocationServicesDisabled
//
//-(id)initWithCoder:(NSCoder *)aDecoder {
//    
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//    }
//    return self;
//}
//
//-(void)setDelegate:(id)newDelegate{
//    delegate = newDelegate;
//}
//
//-(void)show {
//    
//    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    
//    self.backgroundColor = [UIColor clearColor];
//    
//    self.btnGotIt.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.btnGotIt.layer.borderWidth = 1;
//    self.btnGotIt.layer.cornerRadius = 5;
//    
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    
//    self.viewBlur = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    self.viewBlur.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    
//    [self.parentNav.view addSubview:self.viewBlur];
//    [self.parentNav.view bringSubviewToFront:self.viewBlur];
//    [self.viewBlur addSubview:self];
//    [self.parentNav.view bringSubviewToFront:self];
//    [UIView animateWithDuration:0.25
//                          delay:0
//         usingSpringWithDamping:.9
//          initialSpringVelocity:.7
//                        options:0
//                     animations:^{
//                         self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//                         self.center = self.viewBlur.center;
//                     } completion:nil];
//}
//
//
//-(void)dismissView{
//    
//    [UIView animateWithDuration:0.25
//                          delay:0.09
//         usingSpringWithDamping:1
//          initialSpringVelocity:.7
//                        options:0
//                     animations:^{
//                         self.viewBlur.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
//                     } completion:^(BOOL finished){
//                         [self.viewBlur removeFromSuperview];
//                     }];
//}
//
//#pragma mark
//#pragma mark - Actions
//#pragma mark
//
//- (IBAction)btnGotIt_tapped:(id)sender {
//    
//    [self dismissView];
//}
//
//
//@end
