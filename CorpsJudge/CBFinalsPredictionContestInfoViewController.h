//
//  CBFinalsPredictionContestInfoViewController.h
//  CorpsBoard
//
//  Created by Isaias Favela on 6/30/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBFinalsPredictionViewController.h"

@interface CBFinalsPredictionContestInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, predictionProtocol, CBMakeFinalsPredictionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblAveragePredictions;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmitPrediction;
@property (weak, nonatomic) IBOutlet UITableView *tablePredictions;
@property (nonatomic, strong) NSMutableArray *arrayOfAllPredictions;

@end
