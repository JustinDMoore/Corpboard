//
//  CBJudgeViewController.h
//  CorpsBoard
//
//  Created by Justin Moore on 6/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CBShowDetailsViewController.h"

@protocol CBJudgeViewControllerDelegate <NSObject>
- (void)voted;
@end

@interface CBJudgeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITabBarDelegate>

@property (nonatomic, strong) PFObject *show;
@property (nonatomic, strong) NSMutableArray *arrayOfWorldClassScores;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenClassScores;

@property (nonatomic, weak) id <CBJudgeViewControllerDelegate> delegate;


@end
