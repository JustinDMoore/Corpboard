//
//  CBNewFeedbackViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 5/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBFeedback.h"
#import "CBFeedbackCell.h"

@interface CBNewFeedbackViewController : UIViewController <feedbackProtocol, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CBFeedback *viewFeedback;
@property (nonatomic, strong) NSMutableArray *arrayOfFeedbackItems;
@end
