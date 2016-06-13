//
//  CBCorpExperienceList.m
//  CorpBoard
//
//  Created by Justin Moore on 12/17/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBCorpExperienceList.h"
#import "Corpsboard-Swift.h"

@implementation CBCorpExperienceList

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
    }
    return self;
}

-(void)showInParent:(UINavigationController *)parentNav {
    
    for (UIView *view in self.tableExperience.subviews) {
        view.alpha = 0;
        view.hidden = YES;
    }
    
    self.tableExperience.delegate = self;
    self.tableExperience.dataSource = self;
    
    self.alpha = 0;
    [parentNav.view addSubview:self];
    
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
    [self.viewDialog.layer insertSublayer:shapeLayer2 below:self.tableExperience.layer];
    
    self.viewDialog.backgroundColor = UIColor.clearColor;
    //[self bringSubviewToFront:self.lblMessage];
    
    //BUTTON
    //set button bottom corners round
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:self.btnSave.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.btnSave.bounds;
    shapeLayer.path = shapePath.CGPath;
    shapeLayer.fillColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.strokeColor = UISingleton.sharedInstance.gold.CGColor;
    shapeLayer.lineWidth = 1.0;
    [self.btnSave.layer insertSublayer:shapeLayer below:self.btnSave.imageView.layer];
    
    //set image and button tint colors to match app
    
    self.btnIcon.tintColor = UISingleton.sharedInstance.gold;
    self.btnSave.tintColor = UISingleton.sharedInstance.maroon;
    [self.btnSave setBackgroundColor:UIColor.clearColor];
    
    //add top border line on button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.btnSave.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.btnSave addSubview:lineView];
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.backgroundColor = [UIColor clearColor];
    
    self.viewContainer.alpha = 0;
    self.btnSave.alpha = 0;
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.alpha = 0;
    
    
    [self.tableExperience reloadData];
    [self.tableExperience scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    //1
    [UIView animateWithDuration:0.50
                          delay:0.0
         usingSpringWithDamping:.9
          initialSpringVelocity:.7
                        options:0
                     animations:^{
                         
                     } completion:^(BOOL finished){
                         
                         self.viewContainer.transform = CGAffineTransformScale(self.viewDialog.transform, 0.8, 0.8);
                         
                         //2
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
                                              
                                          }]; // end 2
                         
                         self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.btnSave.frame.origin.y - self.btnSave.frame.size.height, self.btnSave.frame.size.width, self.btnSave.frame.size.height);
                         
                         //3
                         [UIView animateWithDuration:0.25
                                               delay:0.05
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              [UIView animateWithDuration:.35
                                                                    delay:.10
                                                                  options:0
                                                               animations:^{
                                                                   
                                                                   for (UIView *view in self.tableExperience.subviews) {
                                                                       view.hidden = NO;
                                                                       view.alpha = 1;
                                                                   }
                                                                   
                                                                   [self.tableExperience scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                                                               atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                                               } completion:^(BOOL finished) {
                                                                   
                                                                   //4
                                                                   [UIView animateWithDuration:.35
                                                                                         delay:0
                                                                                       options:0
                                                                                    animations:^{
                                                                                        
                                                                                        [self showButton:self.btnSave];
                                                                                    } completion:^(BOOL finished) {
                                                                                        
                                                                                    }];
                                                               }];
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
}

-(void)showButton:(UIButton *)button {
    
    button.alpha = 1;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + self.btnSave.frame.size.height, button.frame.size.width, button.frame.size.height);
}


-(void)closeView {
    
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
//
//- (IBAction)btnClose:(id)sender {
//    [self closeView:NO];
//}
//
//-(void)setDelegate:(id)newDelegate {
//    delegate = newDelegate;
//}


@end
