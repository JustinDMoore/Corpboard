//
//  CBFinalsPredictionViewController.h
//  CorpsBoard
//
//  Created by Isaias Favela on 6/30/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol predictionProtocol <NSObject>
@required
-(void)predictionMade;
@end

@interface CBFinalsPredictionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {

}

@property (nonatomic, assign) id delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblInstructions;
@property (weak, nonatomic) IBOutlet UITableView *tableCorps;
@property (nonatomic, strong) NSMutableArray *arrayOfCorps;
@property (nonatomic, strong) NSMutableArray *arrayOfIndexes;
@property (nonatomic, strong) NSMutableArray *arrayOfScores;
@property (nonatomic, strong) NSString *phase; //pick, order, score
@property (nonatomic, strong) NSMutableDictionary *dictOfCorps;
@property (nonatomic, assign) UITextField *currentResponder;
@end
