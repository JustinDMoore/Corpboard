//
//  CBChooseCorp.m
//  CorpBoard
//
//  Created by Justin Moore on 12/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBChooseCorp.h"
#import "CBSingle.h"

@implementation CBChooseCorp {

}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {

        // CUSTOM INITIALIZATION HERE
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
        
        self.txtPosition.delegate = self;
        self.txtCorpsName.delegate = self;
        self.txtYear.delegate = self;
        
        
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

-(void)showInParent:(CGRect)parent {
   
     self.btnCorps.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2), CGRectGetMidY(parent) - (self.frame.size.height / 1.1), self.frame.size.width, self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [self.txtCorpsName becomeFirstResponder];
        
        self.arrayOfPositions = [NSArray arrayWithObjects:@"Staff", @"Volunteer", @"Drum Major", @"Trumpet", @"Mellophone", @"Baritone", @"Euphonium", @"Tuba"
                                 @"Snare", @"Tenor", @"Bass", @"Front Ensemble", @"Colorguard", nil];
        int year = 2015;
        while (year > 1971) {
            [self.arrayOfYears addObject:[NSString stringWithFormat:@"%i", year]];
            year--;
        }
        
       
        
    }];
}



-(void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

- (IBAction)btnCancel_clicked:(id)sender {
    [self closeView:YES];
}

- (IBAction)btnSave_clicked:(id)sender {
    
    if ([self.txtCorpsName.text length] && [self.txtYear.text length] && [self.txtPosition.text length]) {
        PFObject *obj = [PFObject objectWithClassName:@"userCorpExperience"];
        NSString *corpsName;
        if (self.selectedCorp) {
            corpsName = self.selectedCorp[@"corpsName"];
            [obj setObject:self.selectedCorp forKey:@"corps"];
        } else {
            corpsName = self.txtCorpsName.text;
        }
    
        
        obj[@"corpsName"] = self.txtCorpsName.text;
        obj[@"user"] = [PFUser currentUser];
        obj[@"position"] = self.txtPosition.text;
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * year = [f numberFromString:self.txtYear.text];
        
        obj[@"year"] = year;
        
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self saved: obj];
        }];
    }
    
}

-(void)saved:(PFObject *)obj {
    [self closeView:NO];
    [delegate savedCorpExperience: obj];
}
- (IBAction)btnCorpNotListed_clicked:(UIButton*)sender {
    [self.txtCorpsName resignFirstResponder];
    self.txtCorpsName.text = @"";
    self.selectedCorp = nil;
    
    if (sender.tag == 0) { //default
        sender.tag = 1;
        [sender setTitle:@"Back to List" forState:UIControlStateNormal];
        [sender setTitle:@"Back to List" forState:UIControlStateSelected];
        self.txtCorpsName.inputView = nil;
        self.txtCorpsName.caretEnabled = YES;
    } else {
        sender.tag = 0;
        [sender setTitle:@"Corp Not Listed?" forState:UIControlStateNormal];
        [sender setTitle:@"Corp Not Listed?" forState:UIControlStateSelected];
        self.txtCorpsName.inputView = self.corpPicker;
        self.txtCorpsName.caretEnabled = NO;
    }
    
    [self.txtCorpsName becomeFirstResponder];
}

-(void)closeView:(BOOL)cancelled {
    [self.txtCorpsName resignFirstResponder];
    [self.txtYear resignFirstResponder];
    [self.txtPosition resignFirstResponder];
    
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
                             [delegate closedCorpExperience];
                         }];
    }];
    
}

-(NSArray *)arrayOfPositions {
    if (!_arrayOfPositions) {
        _arrayOfPositions = [[NSArray alloc] init];
    }
    
    return _arrayOfPositions;
}

-(NSMutableArray *)arrayOfYears {
    if (!_arrayOfYears) {
        _arrayOfYears = [[NSMutableArray alloc] init];
    }
    return _arrayOfYears;
}

@end
