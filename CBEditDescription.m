//
//  CBEditDescription.m
//  CorpBoard
//
//  Created by Justin Moore on 12/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBEditDescription.h"
#import "Corpsboard-Swift.h"

@implementation CBEditDescription

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

-(void)showInParent:(UINavigationController *)parentNav {
    
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
    [self.viewDialog.layer insertSublayer:shapeLayer2 below:self.txtDescription.layer];
    
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
    self.btnSave.tintColor = UISingleton.sharedInstance.maroon;
    [self.btnSave setBackgroundColor:UIColor.clearColor];
    self.btnImage.tintColor = UISingleton.sharedInstance.gold;
    
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
                                              
                                              self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.btnSave.frame.origin.y - self.btnSave.frame.size.height, self.btnSave.frame.size.width, self.btnSave.frame.size.height);
                                              
                                              [UIView animateWithDuration:.35
                                                                    delay:0
                                                                  options:0
                                                               animations:^{
                                                                   
                                                                   
                                                                   
                                                                   [self showButton:self.btnSave];
                                                               } completion:^(BOOL finished) {
                                                                   
                                                                   
                                                                   if ([[PUser currentUser].background length]) {
                                                                       self.txtDescription.text = [PUser currentUser].background;
                                                                   } else {
                                                                       self.txtDescription.placeholder = @"Tell us about yourself";
                                                                       self.txtDescription.placeholderColor = [UIColor lightGrayColor];
                                                                       self.txtDescription.textColor = [UIColor blackColor];
                                                                   }
                                                                   UIToolbar *toolBar = [[UIToolbar alloc] init];
                                                                   toolBar.barStyle = UIBarStyleBlackTranslucent;
                                                                   toolBar.translucent = YES;
                                                                   toolBar.tintColor = UISingleton.sharedInstance.gold;
                                                                   [toolBar sizeToFit];
                                                                   
                                                                   UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Done   "
                                                                                                                            style:UIBarButtonItemStylePlain
                                                                                                                           target:self 
                                                                                                                           action:@selector(textDone)];
                                                                   
                                                                   
                                                                   UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                                                                        target:nil
                                                                                                                                        action:nil];
                                                                   [toolBar setItems:@[space, item]];
                                                                   toolBar.userInteractionEnabled = YES;
                                                                   self.txtDescription.inputAccessoryView = toolBar;
                                                                   [self.txtDescription becomeFirstResponder];
                                                               }];
                                          }];
                        }];

}

-(void)textDone {
    [self.txtDescription resignFirstResponder];
}
     
-(void)showButton:(UIButton *)button {
    
    button.alpha = 1;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + self.btnSave.frame.size.height, button.frame.size.width, button.frame.size.height);
}


- (IBAction)btnSave:(id)sender {
    
    PUser *user = [PUser currentUser];
    if (![self.txtDescription.text isEqualToString:user.description]) {
        user.background = self.txtDescription.text;
        [user saveInBackground];
        [delegate decriptionUpdated];
    }
    [self closeView];
}

- (IBAction)btnClose:(id)sender {
    [self closeView];
}

-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

-(void)closeView {
    
    [self.txtDescription resignFirstResponder];
    [UIView animateWithDuration:0.25
                          delay:0.09
         usingSpringWithDamping:1
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.viewContainer.transform = CGAffineTransformScale(self.viewContainer.transform, 0.0, 0.0);
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
