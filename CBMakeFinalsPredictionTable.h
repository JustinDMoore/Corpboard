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
-(void)predictionSubmit;
@end

@interface CBMakeFinalsPredictionTable : UIView {
    id delegate;
}

@property (weak, nonatomic) IBOutlet UIView *viewDialog;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnNotNow;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaader;




@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UILabel *lblHeader;
@property (nonatomic, strong) IBOutlet UITableView *tableCorps;
@property (nonatomic, strong) IBOutlet UIButton *btnNext;


-(void)setDelegate:(id)newDelegate;
-(void)reload;
-(void)showViewInParent:(UINavigationController *)parentNav;
-(void)showButton;
- (void)shake;
-(void)close;
@end
