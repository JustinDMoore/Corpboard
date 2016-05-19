//
//  LocationServicesPermission.m
//  CorpBoard
//
//  Created by Justin Moore on 5/17/16.
//  Copyright © 2016 Justin Moore. All rights reserved.
//

#import "LocationServicesPermission.h"
#import "Corpsboard-Swift.h"

@implementation LocationServicesPermission

- (IBAction)btnNotNow:(id)sender {
    [self dismissView];
}

- (IBAction)btnAllowLocation:(id)sender {
    [self dismissView];
    if ([delegate respondsToSelector:@selector(locationAllowed)]) {
        [delegate locationAllowed];
    }
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

-(void)showInParent:(UINavigationController *)parentNav {
    self.viewContainer.backgroundColor = UIColor.clearColor;
    
    //DIALOG VIEW
    //set dialog top rounded corners
    UIBezierPath *shapePath2 = [UIBezierPath bezierPathWithRoundedRect:self.viewDialog.bounds
                                                     byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    
    
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.frame = self.viewDialog.bounds;
    shapeLayer2.path = shapePath2.CGPath;
    shapeLayer2.strokeColor = UIColor.whiteColor.CGColor;
    shapeLayer2.fillColor = UISingleton.sharedInstance.maroon.CGColor;
    [self.viewDialog.layer insertSublayer:shapeLayer2 below:self.lblMessage.layer];
    
    self.viewDialog.backgroundColor = UIColor.clearColor;
    //[self bringSubviewToFront:self.lblMessage];
    
    //BUTTON
    //set button bottom corners round
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:self.btnSignUp.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.btnSignUp.bounds;
    shapeLayer.path = shapePath.CGPath;
    shapeLayer.fillColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.strokeColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.lineWidth = 1.0;
    [self.btnSignUp.layer insertSublayer:shapeLayer below:self.btnSignUp.imageView.layer];
    
    //set image and button tint colors to match app
    self.btnImage.tintColor = UISingleton.sharedInstance.gold;
    [self.btnSignUp setBackgroundColor:UIColor.clearColor];
    self.btnSignUp.tintColor = UISingleton.sharedInstance.maroon;
    
    //add top border line on button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.btnSignUp.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.btnSignUp addSubview:lineView];
    
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.backgroundColor = [UIColor clearColor];
    
    self.viewContainer.alpha = 0;
    self.btnSignUp.alpha = 0;
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.alpha = 0;
    
    [parentNav.view addSubview:self];
    [UIView animateWithDuration:0.50
                          delay:0.0
         usingSpringWithDamping:.9
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         
                     } completion:^(BOOL finished){
                         
                         self.viewContainer.transform = CGAffineTransformScale(self.viewDialog.transform, 0.8, 0.8);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0
                              usingSpringWithDamping:0.6
                               initialSpringVelocity:0.7
                                             options:0
                                          animations:^{
                                              self.alpha = 1;
                                              self.viewContainer.alpha = 1;
                                              self.viewContainer.transform = CGAffineTransformIdentity;
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                         
                         self.btnSignUp.frame = CGRectMake(self.btnSignUp.frame.origin.x, self.btnSignUp.frame.origin.y - self.btnSignUp.frame.size.height, self.btnSignUp.frame.size.width, self.btnSignUp.frame.size.height);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0.05
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              self.btnSignUp.alpha = 1;
                                              self.btnSignUp.frame = CGRectMake(self.btnSignUp.frame.origin.x, self.btnSignUp.frame.origin.y + self.btnSignUp.frame.size.height, self.btnSignUp.frame.size.width, self.btnSignUp.frame.size.height);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

-(void)dismissView {
    
    [UIView animateWithDuration:0.25
                          delay:0.09
         usingSpringWithDamping:1
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
                     } completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         
                     }];
}

@end
