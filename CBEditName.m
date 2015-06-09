//
//  CBEditName.m
//  CorpBoard
//
//  Created by Justin Moore on 12/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBEditName.h"

@implementation CBEditName

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
        
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


-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

-(void)showInParent:(CGRect)parent {
    
    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2), CGRectGetMidY(parent) - (self.frame.size.height / 1.1), self.frame.size.width, self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        self.userProfile = [PFUser currentUser];
        self.lblusername.text = self.userProfile[@"fullname"];
        self.txtNickname.text = self.userProfile[@"nickname"];
        self.txtLocation.text = self.userProfile[@"location"];
        
        
    }];
}

-(void)closeView:(BOOL)cancelled {
    [self.txtLocation resignFirstResponder];
    [self.txtNickname resignFirstResponder];
    
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
                             if (!cancelled) {
                                [delegate savedName];
                             } else {
                                 [delegate cancelledSaveName];
                             }
                             
                         }];
    }];
    
}


- (IBAction)btnCancel:(id)sender {
    
    [self closeView:YES];
}

- (IBAction)btnSave:(id)sender {
    
    if ([self.txtNickname.text length]) {
        
        //make sure the nickname has changed before checking for duplicates
        if (![self.txtNickname.text isEqualToString:self.userProfile[@"nickname"]]) {
            
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            [query whereKey:@"nickname" equalTo:self.txtNickname.text];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                if (!error) {
                    if (count > 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This nickname is already taken." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    } else {
                        [self saveInfo];
                    }
                }
            }];
        } else {
            [self saveInfo];
        }
    } else {
        direction = 1;
        shakes = 0;
        [self shake:self.txtNickname];
    }
}

-(void)saveInfo {
    
    self.userProfile[@"nickname"] = self.txtNickname.text;
    if ([self.txtLocation.text length]) {
        self.userProfile[@"location"] = self.txtLocation.text;
    }
    [[PFUser currentUser] saveInBackground];
    [self closeView:NO];
}

int direction = 1;
int shakes = 0;

-(void)shake:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 10)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             [self.txtNickname becomeFirstResponder];
             return;
         }
         shakes++;
         direction = direction * -1;
         [self shake:theOneYouWannaShake];
     }];
}

@end
