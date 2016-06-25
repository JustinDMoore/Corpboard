//
//  CBShowDetailsViewController.h
//  CorpsBoard
//
//  Created by Justin Moore on 6/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CBEndShowViewController.h"
#import "CBStartReview.h"
#import "CBReviewCell.h"
#import "CBReviewAttendance.h"
#import "CBPickFavorite.h"
#import "UserScore.h"
#import "CBReviewScoreCell.h"
#import "CBReviewFeedback.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "CBReviewShow.h"
#import "CBReviewFavoriteCell.h"
#import "CBReviewCaptionCell.h"
#import "CBReviewSubmitted.h"

@interface CBShowDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, endShowProtocol, CBReviewAttendanceProtocol, CBShowReviewProtocol, CBShowPickFavoriteProtocol, UITextFieldDelegate, CBReviewFeedbackProtocol, reviewShowProtocol, showReviewProtocol>

@property (nonatomic, strong) CBReviewSubmitted *viewReviewSubmitted;
@property (nonatomic, strong) CBReviewShow *viewSummary;
@property (nonatomic, strong) CBReviewFeedback *viewFeedback;
@property (nonatomic, strong) CBPickFavorite *viewFavorite;
@property (nonatomic, strong) CBReviewAttendance *viewMAIN;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) CBStartReview *viewStartReview;
@property (nonatomic, strong) PFObject *show;
@property (nonatomic) BOOL fromMaps;
@end
