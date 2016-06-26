//
//  CBMakeFinalsPredictionTable.m
//  CorpBoard
//
//  Created by Justin Moore on 5/20/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBMakeFinalsPredictionTable.h"
#import "Corpsboard-Swift.h"

@implementation CBMakeFinalsPredictionTable

int x = 0;

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

-(void)showViewInParent:(UINavigationController *)parentNav {
    self.alpha = 0;
    [parentNav.view addSubview:self];
    
    self.viewContainer.alpha = 0;
    self.viewContainer.backgroundColor = [UIColor clearColor];
    
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
    [self.viewDialog.layer insertSublayer:shapeLayer2 below:self.lblHeader.layer];
    
    self.viewDialog.backgroundColor = UIColor.clearColor;
    //[self bringSubviewToFront:self.lblMessage];
    
    //BUTTON
    //set button bottom corners round
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:self.btnSubmit.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.btnSubmit.bounds;
    shapeLayer.path = shapePath.CGPath;
    shapeLayer.fillColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.strokeColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.lineWidth = 1.0;
    [self.btnSubmit.layer insertSublayer:shapeLayer below:self.tableCorps.layer];
    
    //set image and button tint colors to match app
    self.btnImage.tintColor = UISingleton.sharedInstance.gold;
    [self.btnSubmit setBackgroundColor:UIColor.clearColor];
    self.btnSubmit.tintColor = UISingleton.sharedInstance.maroon;
    
    //add top border line on button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.btnSubmit.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.btnSubmit addSubview:lineView];
    
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.backgroundColor = [UIColor clearColor];
    
   // self.viewContainer.alpha = 0;
    self.btnSubmit.alpha = 0;
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
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
                         
                         self.btnSubmit.frame = CGRectMake(self.btnSubmit.frame.origin.x, self.btnSubmit.frame.origin.y - self.btnSubmit.frame.size.height, self.btnSubmit.frame.size.width, self.btnSubmit.frame.size.height);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0.05
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              
                                              
                                          } completion:^(BOOL finished) {
                                              [self bringSubviewToFront:self.lblHeader];
                                              [self reload];
                                          }];
                     }];
}

-(void)showButton {
    if (self.btnSubmit.tag == 0) {
        self.btnSubmit.tag = 1;
        [UIView animateWithDuration:0.25 delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.btnSubmit.alpha = 1;
            self.btnSubmit.frame = CGRectMake(self.btnSubmit.frame.origin.x, self.btnSubmit.frame.origin.y + self.btnSubmit.frame.size.height, self.btnSubmit.frame.size.width, self.btnSubmit.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)hideButton {
    if (self.btnSubmit.tag == 1) {
        self.btnSubmit.tag = 0;
        [UIView animateWithDuration:0.25 delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.btnSubmit.alpha = 0;
            self.btnSubmit.frame = CGRectMake(self.btnSubmit.frame.origin.x, self.btnSubmit.frame.origin.y - self.btnSubmit.frame.size.height, self.btnSubmit.frame.size.width, self.btnSubmit.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)shake {

    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 3.0f ;
    anim.duration = 0.04f ;
    
    [self.viewContainer.layer addAnimation:anim forKey:nil] ;
}

-(void)reload {
    
    self.tableCorps.alpha = 0;
    [self.tableCorps reloadData];
    [self.tableCorps scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         self.tableCorps.alpha = 1;
                         [self.tableCorps scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                     } completion:nil];
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)closeView {
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:8 options:0 animations:^{
        
        self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:8
                            options:0
                         animations:^{
                             self.transform = CGAffineTransformScale(self.transform, 0.1f, 0.1f);
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             if ([delegate respondsToSelector:@selector(predictionClosed)]) {
                                 [delegate predictionClosed];
                             }
                         }];
    }];
}

- (IBAction)btnBack_didTap:(UIButton *)sender {
    if (x == 2) {
        [self hideButton];
    }
    if ([delegate respondsToSelector:@selector(predictionBackTapped)]) {
        [delegate predictionBackTapped];
    }
    x--;
    [self setLabel];
}

- (IBAction)btnNext_didTap:(UIButton *)sender {
    if (x == 1 ) {
        [self showButton];
    }
    if ([delegate respondsToSelector:@selector(predictionNext)]) {
        [delegate predictionNext];
    }
    x++;
    [self setLabel];
}

-(void)setLabel {
    if (x ==1) {
        self.lblMessage.text = @"Drag to reorder";
    } else if (x == 2) {
        self.lblMessage.text = @"Give scores";
    }
}

- (IBAction)btnSubmit_didTap:(UIButton *)sender {
    [delegate predictionSubmit];
}


- (IBAction)btnClose_didTap:(UIButton *)sender {
    [UIView animateWithDuration:0.25
                          delay:0.09
         usingSpringWithDamping:1
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.viewContainer.transform = CGAffineTransformScale(self.viewContainer.transform, 0.0, 0.0);
                         
                     } completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [delegate predictionClosed];
                         
                     }];
}

-(void)close {
    [UIView animateWithDuration:0.25
                          delay:0.09
         usingSpringWithDamping:1
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         self.viewContainer.transform = CGAffineTransformScale(self.viewContainer.transform, 0.0, 0.0);
                         
                     } completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                     
                         
                     }];
}

@end
