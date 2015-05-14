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
#import <ParseUI/ParseUI.h>
#import "CBReviewShow.h"
#import "CBReviewSubmitted.h"
#import "CBAlertView.h"

@protocol CBJudgeViewControllerDelegate <NSObject>
- (void)voted;
@end

@interface CBJudgeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITabBarDelegate, reviewShowProtocol, showReviewProtocol, CBAlertDelegate>

@property (nonatomic, strong) PFObject *show;
@property (nonatomic, strong) NSMutableArray *arrayOfWorldClassScores;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenClassScores;
@property (nonatomic, strong) NSMutableArray *arrayOfAllAgeClassScores;
@property (nonatomic, strong) CBReviewShow *viewRecap;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, weak) id <CBJudgeViewControllerDelegate> delegate;
@property (nonatomic, strong) CBReviewSubmitted *viewReviewSubmitted;

@end
