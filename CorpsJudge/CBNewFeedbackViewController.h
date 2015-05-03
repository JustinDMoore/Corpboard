//
//  CBNewFeedbackViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 5/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBContactUs.h"
#import "CBFeedbackCell.h"
#import "CBRateView.h"
#import "CBFeedbackView.h"
#import <Parse/Parse.h>
#import "CBThankYou.h"
#import "CBProblemWhere.h"
#import "CBProblemWhereCell.h"

@interface CBNewFeedbackViewController : UIViewController <contactUsProtocol, UITableViewDataSource, UITableViewDelegate, RateProtocol, feedbackProtocol, thankYouProtocol>

@property (nonatomic, strong) CBContactUs *viewContactUs;
@property (nonatomic, strong) CBRateView *viewRate;
@property (nonatomic, strong) CBFeedbackView *viewFeedback;
@property (nonatomic, strong) CBThankYou *viewThankYou;
@property (nonatomic, strong) CBProblemWhere *viewProblemWhere;
@property (nonatomic, strong) NSMutableArray *arrayOfFeedbackItems;
@end
