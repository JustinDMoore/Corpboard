//
//  CBUserCategories.m
//  CorpBoard
//
//  Created by Isaias Favela on 12/11/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBUserCategories.h"
#import <Parse/Parse.h>
#import "Corpsboard-Swift.h"

@implementation CBUserCategories {
    
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
        
        [self.dict setObject:@"NO" forKey:@"Fan"];
        [self.dict setObject:@"NO" forKey:@"Alumni"];
        [self.dict setObject:@"NO" forKey:@"Active Member"];
        [self.dict setObject:@"NO" forKey:@"Staff"];
        [self.dict setObject:@"NO" forKey:@"Former Staff"];
        [self.dict setObject:@"NO" forKey:@"Family of Member"];
        [self.dict setObject:@"NO" forKey:@"Brass Player"];
        [self.dict setObject:@"NO" forKey:@"Woodwind Player"];
        [self.dict setObject:@"NO" forKey:@"Percussionist"];
        [self.dict setObject:@"NO" forKey:@"Color Guard"];
        [self.dict setObject:@"NO" forKey:@"Volunteer"];
        
        self.tableCategories.backgroundColor = UISingleton.sharedInstance.maroon;
        self.tableCategories.tintColor = UISingleton.sharedInstance.gold;
        
        self.arrayOfCategories = [[NSArray alloc] initWithObjects: @"Fan", @"Alumni", @"Active Member", @"Staff", @"Former Staff", @"Family of Member", @"Brass Player", @"Woodwind Player", @"Percussionist", @"Color Guard", @"Volunteer", nil];

        // Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.y"
         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        // Add both effects to your view
        [self addMotionEffect:group];
    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent:(UINavigationController *)parentNav {
    
    for (UIView *view in self.tableCategories.subviews) {
        view.alpha = 0;
        view.hidden = YES;
    }
    
    self.tableCategories.delegate = self;
    self.tableCategories.dataSource = self;
    
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
    [self.viewDialog.layer insertSublayer:shapeLayer2 below:self.tableCategories.layer];
    
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
    
    
    [self.tableCategories reloadData];
    [self.tableCategories scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
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
                         
                         self.btnSave.frame = CGRectMake(self.btnSave.frame.origin.x, self.btnSave.frame.origin.y - self.btnSave.frame.size.height, self.btnSave.frame.size.width, self.btnSave.frame.size.height);
                         
                         [UIView animateWithDuration:0.25
                                               delay:0.05
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              [UIView animateWithDuration:.35
                                                                    delay:.10
                                                                  options:0
                                                               animations:^{
                                                                   
                                                                   for (UIView *view in self.tableCategories.subviews) {
                                                                       view.hidden = NO;
                                                                       view.alpha = 1;
                                                                   }
                                                                   
                                                                   [self.tableCategories scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                                                               atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                                               } completion:^(BOOL finished) {
                                                                   
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

- (IBAction)btnCancel_clicked:(id)sender {
    [self closeView];
}

- (IBAction)btnSave_clicked:(id)sender {
    
    [self closeView];

    PFUser *user = [PFUser currentUser];
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (NSString *key in self.dict) {
        NSString *s = [self.dict objectForKey:key];
        if ([s isEqualToString:@"YES"]) {
            [mArr addObject:key];
        }
    }

    user[@"arrayOfBadges"] = mArr;
    [user saveEventually];
    [delegate savedCategories];
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

-(void)setCategories:(NSArray *)arr {
    
    for (NSString *userCat in arr) {
        for (NSString *cat in self.arrayOfCategories) {
            if ([userCat isEqualToString:cat]) {
                [self.dict setObject:@"YES" forKey:cat];
                NSIndexPath *path = [NSIndexPath indexPathForRow:[self.arrayOfCategories indexOfObject:cat] inSection:0];
                [self.tableCategories selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
                break;
            }
        }
    }
    
}

-(NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfCategories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = (NSString *)[self.arrayOfCategories objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = UISingleton.sharedInstance.maroon;
    cell.textLabel.textColor = [UIColor whiteColor];
    NSString *str = [self.dict objectForKey:cell.textLabel.text];
    if ([str isEqualToString:@"YES"]) {
        [self selectCell:cell atIndexPath:indexPath onOrOff:YES fromMethod:NO];
    } else {
        [self selectCell:cell atIndexPath:indexPath onOrOff:NO fromMethod:NO];
    }
    return cell;
}

-(void)selectCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)path onOrOff:(BOOL)on fromMethod:(BOOL)method {
    
    if (on) {
        if (!method) [self.tableCategories selectRowAtIndexPath:path animated:NO scrollPosition: UITableViewScrollPositionNone];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if ([self.dict objectForKey:cell.textLabel.text]) {
            [self.dict setObject:@"YES" forKey:cell.textLabel.text];
        }
        
        //check to see if it's staff or former staff and deselect the opposite one
        if ([cell.textLabel.text isEqualToString:@"Staff"]) {
            NSIndexPath *ip = [NSIndexPath indexPathForItem:path.row+1 inSection:0];
            UITableViewCell *c = [self.tableCategories cellForRowAtIndexPath:ip];
            [self selectCell:c atIndexPath:ip onOrOff:NO fromMethod:NO];
        } else if ([cell.textLabel.text isEqualToString:@"Former Staff"]) {
            NSIndexPath *ip = [NSIndexPath indexPathForItem:path.row-1 inSection:0];
            UITableViewCell *c = [self.tableCategories cellForRowAtIndexPath:ip];
            [self selectCell:c atIndexPath:ip onOrOff:NO fromMethod:NO];
        }
        
        
    } else {
        if (!method) [self.tableCategories deselectRowAtIndexPath:path animated:NO];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([self.dict objectForKey:cell.textLabel.text]) {
            [self.dict setObject:@"NO" forKey:cell.textLabel.text];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:YES fromMethod:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:NO fromMethod:YES];
}

@end
