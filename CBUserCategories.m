//
//  CBUserCategories.m
//  CorpBoard
//
//  Created by Isaias Favela on 12/11/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBUserCategories.h"
#import <Parse/Parse.h>
#import "KVNProgress.h"
#import "Configuration.h"

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
        [self.dict setObject:@"NO" forKey:@"Percussionist"];
        [self.dict setObject:@"NO" forKey:@"Color Guard"];
        [self.dict setObject:@"NO" forKey:@"Volunteer"];
        
        self.arrayOfCategories = [[NSArray alloc] initWithObjects: @"Fan", @"Alumni", @"Active Member", @"Staff", @"Former Staff", @"Family of Member", @"Brass Player", @"Percussionist", @"Color Guard", @"Volunteer", nil];

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

-(void)showInParent:(CGRect)parent {
    
    self.frame = CGRectMake(CGRectGetMidX(parent) - (self.frame.size.width / 2), CGRectGetMidY(parent) - (self.frame.size.height / 2), self.frame.size.width, self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:0 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
    }];
}
- (IBAction)btnCancel_clicked:(id)sender {
    [self closeView:YES];
}

- (IBAction)btnSave_clicked:(id)sender {
    
    [self closeView:NO];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });

    
    PFUser *user = [PFUser currentUser];
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    for (NSString *key in self.dict) {
        NSString *s = [self.dict objectForKey:key];
        if ([s isEqualToString:@"YES"]) {
            [mArr addObject:key];
        }
    }

    user[@"arrayOfCategories"] = mArr;
    [user saveInBackgroundWithTarget:self selector:@selector(saved)];
    
}

-(void)saved {
    
    [delegate savedCategories];
}

-(void)closeView:(BOOL)cancelled {
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
                             [delegate categoriesClosed];
                         }];
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

@end
