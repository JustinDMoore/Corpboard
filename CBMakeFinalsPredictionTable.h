//
//  CBMakeFinalsPredictionTable.h
//  CorpBoard
//
//  Created by Justin Moore on 5/20/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol makePredictionProtocol <NSObject>
@required
-(void)predictionBackTapped;
-(void)predictionNext;
-(void)predictionClosed;
@end

@interface CBMakeFinalsPredictionTable : UIView {
    id delegate;
}

@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UILabel *lblHeader;
@property (nonatomic, strong) IBOutlet UITableView *tableCorps;
@property (nonatomic, strong) IBOutlet UIButton *btnSend;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;

-(void)setDelegate:(id)newDelegate;
-(void)show;
-(void)closeView;
-(void)reload;

@end
