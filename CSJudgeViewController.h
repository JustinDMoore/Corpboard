//
//  CSJudgeViewController.h
//  CorpsJudge
//
//  Created by Justin Moore on 6/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CSShowDetailsViewController.h"

@protocol CSJudgeViewControllerDelegate <NSObject>
- (void)voted;
@end

@interface CSJudgeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITabBarDelegate>

@property (nonatomic, strong) PFObject *show;
@property (nonatomic, strong) NSMutableArray *arrayOfWorldClassScores;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenClassScores;

@property (nonatomic, weak) id <CSJudgeViewControllerDelegate> delegate;


@end
