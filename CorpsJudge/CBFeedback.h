//
//  CBFeedback.h
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
#import "CBProblemWhat.h"

@interface CBFeedback : UIVisualEffectView <contactUsProtocol, UITableViewDataSource, UITableViewDelegate, RateProtocol, feedbackProtocol, thankYouProtocol, problemWhereProtocol, problemWhatProtocol>

@property (nonatomic, strong) CBContactUs *viewContactUs;
@property (nonatomic, strong) CBRateView *viewRate;
@property (nonatomic, strong) CBFeedbackView *viewFeedback;
@property (nonatomic, strong) CBThankYou *viewThankYou;
@property (nonatomic, strong) CBProblemWhere *viewProblemWhere;
@property (nonatomic, strong) CBProblemWhat *viewProblemWhat;
@property (nonatomic, strong) NSMutableArray *arrayOfFeedbackItems;
@property (weak, nonatomic) IBOutlet UILabel *lblPrivacyPolicy;
@property (weak, nonatomic) IBOutlet UIButton *btnPrivacyPolicy;
@property (nonnull, strong) UINavigationController *parent;
@property (nonatomic) BOOL bug;

-(void)showViewInParent:(UINavigationController *)parentNav;

@end

