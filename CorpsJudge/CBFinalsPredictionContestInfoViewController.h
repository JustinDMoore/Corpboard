//
//  CBFinalsPredictionContestInfoViewController.h
//  CorpsBoard
//
//  Created by Isaias Favela on 6/30/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBFinalsPredictionViewController.h"
#import "CBMakeFinalsPredictionTable.h"
#import "CBPredictionSelectCell.h"
#import "CBPredictionOrderCell.h"
#import "CBPredictionScoreCell.h"
#import "CBPredictionSubmitted.h"

typedef enum : NSUInteger {
    pick,
    sort,
    score,
} phase;

@interface CBFinalsPredictionContestInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, predictionProtocol, UITextFieldDelegate, makePredictionProtocol, predictionThankYouProtocol>

@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (nonatomic, strong) UIVisualEffectView *viewEffect;
@property (nonatomic) phase currentPhase;
@property (nonatomic, strong) CBMakeFinalsPredictionTable *viewCorps;
@property (nonatomic, strong) CBPredictionSubmitted *viewPredictionSubmitted;

@property (nonatomic, strong) IBOutlet UILabel *lblYourPrediction;
@property (nonatomic, strong) IBOutlet UILabel *lblFansPrediction;
@property (nonatomic, strong) IBOutlet UILabel *lblActualScores;

@property (weak, nonatomic) IBOutlet UITableView *tablePredictions;


@property (nonatomic, strong) NSMutableArray *arrayOfAllPredictions;
@property (nonatomic, strong) NSMutableArray *arrayOfActualRankings;
@property (nonatomic, strong) NSMutableArray *arrayOfUserPrediction;

@property (nonatomic, strong) NSMutableArray *arrayOfCorps;
@property (nonatomic, strong) NSMutableArray *arrayOfIndexes;
@property (nonatomic, strong) NSMutableArray *arrayOfScores;
@property (nonatomic, strong) NSMutableDictionary *dictOfCorps;
@property (nonatomic, assign) UITextField *currentResponder;

@end
