//
//  CBEndShowViewController.h
//  CorpBoard
//
//  Created by Isaias Favela on 1/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol endShowProtocol <NSObject>
-(void)showCompleted;
@end

@interface CBEndShowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) PFObject *show;
@property (nonatomic, strong) NSMutableArray *arrayOfWorldClassScores;
@property (nonatomic, strong) NSMutableArray *arrayOfOpenClassScores;
@property (nonatomic, strong) NSMutableArray *arrayOfAllAgeClassScores;

@end
