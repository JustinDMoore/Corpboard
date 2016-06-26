//
//  CBPredictionSubmitted.m
//  CorpBoard
//
//  Created by Justin Moore on 5/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBPredictionSubmitted.h"
#import "Corpsboard-swift.h"

@implementation CBPredictionSubmitted

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
       
    }
    return self;
}

-(void)setDelegate:(id)newDelegate {
    
    delegate = newDelegate;
}

-(void)showInParent:(UINavigationController *)parentNav {
    self.viewContainer.backgroundColor = UIColor.clearColor;
    self.viewContainer.alpha = 0;

    [parentNav.view addSubview:self];
    
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
                                              
                                              [self showButton:self.btnSignUp];
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

-(void)showButton:(UIButton *)button {
    button.alpha = 1;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + self.btnSignUp.frame.size.height, button.frame.size.width, button.frame.size.height);
}


-(IBAction)btnOK_tapped:(id)sender {
    [UIView animateWithDuration:0.25
                          delay:0.09
         usingSpringWithDamping:1
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.viewContainer.transform = CGAffineTransformScale(self.viewContainer.transform, 0.0, 0.0);
 
                     } completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         if ([delegate respondsToSelector:@selector(predictionThankYou)]) {
                             [delegate predictionThankYou];
                         }
                     }];
}

@end
