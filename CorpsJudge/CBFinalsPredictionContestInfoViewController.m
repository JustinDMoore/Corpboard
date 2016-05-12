//
//  CBFinalsPredictionContestInfoViewController.m
//  CorpsBoard
//
//  Created by Isaias Favela on 6/30/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBFinalsPredictionContestInfoViewController.h"
#import "UserScore.h"
#import <ParseUI/ParseUI.h>
#import "KVNProgress.h"
#import "Configuration.h"
#import "Corpsboard-Swift.h"

@interface CBFinalsPredictionContestInfoViewController () {
    Configuration *config;
    PFQuery *queryPredictions;
    PFQuery *queryUserPredictions;
    BOOL actualDone;
    BOOL averageDone;
    BOOL userDone;
}

@end

@implementation CBFinalsPredictionContestInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    actualDone = NO;
    averageDone = NO;
    userDone = NO;

    self.tablePredictions.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    for (PFObject *corp in Server.sharedInstance.arrayOfWorldClass) {
        [self.dictOfCorps setObject:@"NO" forKey:corp[@"corpsName"]];
        [self.arrayOfCorps addObject:corp];
    }
    self.viewLine.hidden = YES;
    
    for (PFObject *corp in Server.sharedInstance.arrayOfWorldClass) {
        UserScore *us = [[UserScore alloc] init];
        us.corps = corp;
        us.score = [corp[@"lastScore"] doubleValue];
        [self.arrayOfActualRankings addObject:us];
    }
    
    NSSortDescriptor *sortCorps = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortCorpsDescriptor = [NSArray arrayWithObject: sortCorps];
    
    if ([self.arrayOfActualRankings count]) [self.arrayOfActualRankings sortUsingDescriptors:sortCorpsDescriptor];
    
    actualDone = YES;

}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UISingleton.sharedInstance getBackButton];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    PFUser *user = [PFUser currentUser];
    BOOL predicted = [user[@"predictionEntered"] boolValue];
    if (!predicted) {
        BOOL allowPredictions = [Server.sharedInstance.objAdmin[@"allowPredictions"] boolValue];
        if (allowPredictions) {
            UIVisualEffect *blurEffect;
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            
            self.viewEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            
            self.viewEffect.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            self.view.backgroundColor = [UIColor clearColor];
            [self.navigationController.view addSubview:self.viewEffect];
            [self.view bringSubviewToFront:self.viewEffect];
        } else {
            [self showPredictions];
        }
    } else {
        [self showPredictions];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    PFUser *user = [PFUser currentUser];
    BOOL predicted = [user[@"predictionEntered"] boolValue];
    if (!predicted) {
        BOOL allowPredictions = [Server.sharedInstance.objAdmin[@"allowPredictions"] boolValue];
        if (allowPredictions) {
            
            self.viewCorps = [[[NSBundle mainBundle] loadNibNamed:@"CBMakeFinalsPredictionTable"
                                                            owner:self
                                                          options:nil]
                              objectAtIndex:0];
            
            
            [self.navigationController.view addSubview:self.viewCorps];
            [self.viewCorps show];
            [self.viewCorps setDelegate:self];
            self.viewCorps.tableCorps.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            self.viewCorps.tableCorps.delegate = self;
            self.viewCorps.tableCorps.dataSource = self;
            self.viewCorps.btnSend.hidden = YES;
            self.currentPhase = pick;
            [self.arrayOfScores removeAllObjects];
            for (int i = 0; i < 12; i++) {
                NSString *str = @"0";
                [self.arrayOfScores addObject:str];
            }
        }
    }
}

-(void)setCurrentPhase:(phase)newPhase {

    _currentPhase = newPhase;
    switch (self.currentPhase) {
        case pick:
            [self.viewCorps.btnSend setTitle:@"Next" forState:UIControlStateNormal];
            [self changeText:@"Select 12 Finalists" forLabel:self.viewCorps.lblHeader];
            self.viewCorps.tableCorps.allowsMultipleSelection = YES;
            self.viewCorps.btnCancel.hidden = NO;
            self.viewCorps.btnBack.hidden = YES;
            [self.viewCorps.tableCorps setEditing:NO animated:YES];
            break;
        case sort:
            [self.viewCorps.btnSend setTitle:@"Next" forState:UIControlStateNormal];
            [self changeText:@"Order Finalists" forLabel:self.viewCorps.lblHeader];
            //self.viewCorps.tableCorps.allowsSelection = NO;
            self.viewCorps.btnCancel.hidden = YES;
            self.viewCorps.btnBack.hidden = NO;
            [self.viewCorps.tableCorps setEditing:YES animated:YES];
            break;
        case score:
            [self.viewCorps.btnSend setTitle:@"Send" forState:UIControlStateNormal];
            [self.viewCorps.tableCorps setEditing:NO animated:YES];
            [self changeText:@"Score Finalists" forLabel:self.viewCorps.lblHeader];
            //self.viewCorps.tableCorps.allowsSelection = NO;
            self.viewCorps.btnCancel.hidden = YES;
            self.viewCorps.btnBack.hidden = NO;
            break;
    }
    
    [self.viewCorps reload];
}

-(void)makePrediction {
    
    self.tablePredictions.hidden = YES;
    self.lblActualScores.hidden = YES;
    self.lblYourPrediction.hidden = YES;
    self.lblFansPrediction.hidden = YES;
    self.viewLine.hidden = YES;

}

-(void)showPredictions {
    loop = 0;
    [self.arrayOfUserPrediction removeAllObjects];
    [self.arrayOfAllPredictions removeAllObjects];
    self.view.backgroundColor = [UIColor blackColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress showWithStatus:@"Getting Current Predictions"];
    });
    
    [self getPredictions];
    [self getUserPredictions];
    self.tablePredictions.hidden = YES;
    self.lblYourPrediction.hidden = YES;
    self.lblFansPrediction.hidden = YES;
    self.lblActualScores.hidden = YES;
}


-(void)getPredictions {

    for (PFObject *corp in Server.sharedInstance.arrayOfWorldClass) {
        [self getRankForCorps:corp];
    }
}

-(void)getUserPredictions {
    
    queryUserPredictions = [PFQuery queryWithClassName:@"predictions"];
    [queryUserPredictions whereKey:@"user" equalTo:[PFUser currentUser]];
    [queryUserPredictions includeKey:@"corp"];
    [queryUserPredictions findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if ([array count]) {
            
            for (PFObject *obj in array) {
                
                UserScore *score = [[UserScore alloc] init];
                score.corps = obj[@"corp"];
                score.score = [obj[@"score"] doubleValue];
                [self.arrayOfUserPrediction addObject:score];
            }
            
            NSSortDescriptor *sortUserRankings = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
            NSArray *sortUserRankingsDescriptor = [NSArray arrayWithObject: sortUserRankings];
            
            if ([self.arrayOfUserPrediction count]) [self.arrayOfUserPrediction sortUsingDescriptors:sortUserRankingsDescriptor];
            
            userDone = YES;
            [self areWeDone];
        } else {
            userDone = YES;
            [self areWeDone];
        }
    }];
}

int loop = 0;

-(void)getRankForCorps:(PFObject *)corp {
    
    queryPredictions = [PFQuery queryWithClassName:@"predictions"];
    [queryPredictions whereKey:@"corp" equalTo:corp];
    [queryPredictions includeKey:@"corp"];
    
    [queryPredictions findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        loop++;
        if ([array count]) {
            
            double scoresTotal = 0;
            for (PFObject *obj in array) {
                double i = [obj[@"score"] doubleValue];
                scoresTotal += i;
            }
            double grand = scoresTotal / [array count];
            PFObject *pred = [array objectAtIndex:0];
            UserScore *us = [[UserScore alloc] init];
            us.corps = pred[@"corp"];
            us.score = grand;
            
            [self.arrayOfAllPredictions addObject:us];
           
            if (loop == [Server.sharedInstance.arrayOfWorldClass count]) {
                // we're done
                averageDone = YES;
                [self areWeDone];
            }
        } else {
            if (loop == [Server.sharedInstance.arrayOfWorldClass count]) {
                averageDone = YES;
                [self areWeDone];
            }
        }
    }];
}

-(void)areWeDone {
    if (averageDone && userDone && actualDone) {
        [self sortPredictions];
    }
}

-(void)sortPredictions {
    
    NSSortDescriptor *sortUserRankings = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortUserRankingsDescriptor = [NSArray arrayWithObject: sortUserRankings];
    
    if ([self.arrayOfAllPredictions count]) [self.arrayOfAllPredictions sortUsingDescriptors:sortUserRankingsDescriptor];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.viewLine.hidden = NO;
        self.lblActualScores.hidden = NO;
        self.lblFansPrediction.hidden = NO;
        self.lblYourPrediction.hidden = NO;
        self.tablePredictions.hidden = NO;
        [self.tablePredictions reloadData];
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress dismiss];
    });
}

- (void)goback {
    
    [queryPredictions cancel];
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress dismiss];
    });
    [self.viewEffect removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UITableView Datasource & Delegates
#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.viewCorps.tableCorps) {
        switch (self.currentPhase) {
            case pick: return [self.arrayOfCorps count];
                break;
            case sort: return [self.arrayOfIndexes count];
                break;
            case score: return [self.arrayOfIndexes count];
                break;
        }
    }
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == self.viewCorps.tableCorps) {
        
        PFObject *corp;
        NSMutableArray *array;
        UILabel *lblPlacement;
        PFImageView *imgLogo;
        UILabel *lblName;
        UITextField *txtScore;
        
        switch (self.currentPhase) {
                
            case pick:
                
                cell = (CBPredictionSelectCell *)[self.viewCorps.tableCorps dequeueReusableCellWithIdentifier:@"selectCell"];
                if (!cell) {
                    [self.viewCorps.tableCorps registerNib:[UINib nibWithNibName:@"CBPredictionSelectCell" bundle:nil] forCellReuseIdentifier:@"selectCell"];
                    cell = [self.viewCorps.tableCorps dequeueReusableCellWithIdentifier:@"selectCell"];
                }
                
                array = self.arrayOfCorps;
                if ([array count]) corp = array[indexPath.row];
                lblPlacement = (UILabel *)[cell viewWithTag:1];
                imgLogo = (PFImageView *)[cell viewWithTag:2];
                lblName = (UILabel *)[cell viewWithTag:3];
                
                break;
            case sort:
                
                cell = (CBPredictionOrderCell *)[self.viewCorps.tableCorps dequeueReusableCellWithIdentifier:@"orderCell"];
                if (!cell) {
                    [self.viewCorps.tableCorps registerNib:[UINib nibWithNibName:@"CBPredictionOrderCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];
                    cell = [self.viewCorps.tableCorps dequeueReusableCellWithIdentifier:@"orderCell"];
                }
                array = self.arrayOfIndexes;
                if ([array count]) corp = array[indexPath.row];
                lblPlacement = (UILabel *)[cell viewWithTag:1];
                imgLogo = (PFImageView *)[cell viewWithTag:2];
                lblName = (UILabel *)[cell viewWithTag:3];
                
                
                break;
            case score:
                
                cell = (CBPredictionScoreCell *)[self.viewCorps.tableCorps dequeueReusableCellWithIdentifier:@"scoreCell"];
                if (!cell) {
                    [self.viewCorps.tableCorps registerNib:[UINib nibWithNibName:@"CBPredictionScoreCell" bundle:nil] forCellReuseIdentifier:@"scoreCell"];
                    cell = [self.viewCorps.tableCorps dequeueReusableCellWithIdentifier:@"scoreCell"];
                }
                array = self.arrayOfIndexes;
                if ([array count]) corp = array[indexPath.row];
                lblPlacement = (UILabel *)[cell viewWithTag:1];
                imgLogo = (PFImageView *)[cell viewWithTag:2];
                lblName = (UILabel *)[cell viewWithTag:3];
                txtScore = (UITextField *)[cell viewWithTag:4];
                txtScore.delegate = self;
                [txtScore setUserInteractionEnabled:YES];
                [txtScore setUserInteractionEnabled:YES];
                [txtScore addTarget:self
                             action:@selector(textFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];
                
                break;
        }
        
        
        
        if (corp) {
            
            
            if ([lblPlacement isKindOfClass:[UILabel class]]) lblPlacement.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1];
            if (imgLogo) {
                PFFile *imageFile = corp[@"logo_light"];
                if (!imageFile) {
                    imageFile = corp[@"logo"];
                }
                if (imageFile) {
                    [imgLogo setFile:imageFile];
                    [imgLogo loadInBackground];
                }
            }
            
            if (lblName) lblName.text = corp[@"corpsName"];
            
            if ([self.arrayOfScores count] && txtScore) {
                NSString *score = [NSString stringWithFormat:@"%@", self.arrayOfScores[indexPath.row]];
                if ([score isEqualToString:@"0"]) score = @"";
                if (txtScore) txtScore.text = score;
            }
            
            if (self.currentPhase == pick) {
                
                NSString *str = [self.dictOfCorps objectForKey:corp[@"corpsName"]];
                if ([str isEqualToString:@"YES"]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    [self.viewCorps.tableCorps selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
                    //[self selectCell:cell atIndexPath:indexPath onOrOff:YES fromMethod:NO];
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    [self.viewCorps.tableCorps deselectRowAtIndexPath:indexPath animated:NO];
                    //[self selectCell:cell atIndexPath:indexPath onOrOff:NO fromMethod:NO];
                }
            }
        }
    } else {
        
        cell = [self.tablePredictions dequeueReusableCellWithIdentifier:@"rank"];
        
        UILabel *lblRank = (UILabel *)[cell viewWithTag:20];
        
        //average predictions for all users
        UILabel *lblName1 = (UILabel *)[cell viewWithTag:2];
        UILabel *lblScore1 = (UILabel *)[cell viewWithTag:3];
        PFImageView *imgLogo1 = (PFImageView *)[cell viewWithTag:1];
        
        //actual current rankings
        UILabel *lblName2 = (UILabel *)[cell viewWithTag:5];
        UILabel *lblScore2 = (UILabel *)[cell viewWithTag:6];
        PFImageView *imgLogo2 = (PFImageView *)[cell viewWithTag:4];
        
        //user predictions
        UILabel *lblName3 = (UILabel *)[cell viewWithTag:8];
        UILabel *lblScore3 = (UILabel *)[cell viewWithTag:9];
        PFImageView *imgLogo3 = (PFImageView *)[cell viewWithTag:7];
        
        
        lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
        
        UserScore *us1;
        if ([self.arrayOfUserPrediction count]) us1 = [self.arrayOfUserPrediction objectAtIndex:indexPath.row];
        if (us1) {
            PFFile *imageFile1 = us1.corps[@"logo"];
            if (imageFile1) {
                [imgLogo1 setFile:imageFile1];
                [imgLogo1 loadInBackground];
            }
            
            lblName1.text = [self abbreviateName:us1.corps[@"corpsName"]];
            lblScore1.text = [NSString stringWithFormat:@"%.3f", us1.score];
        } else {
            lblName1.text = @"";
            lblScore1.text = @"";
        }
        
        UserScore *us2;
        if ([self.arrayOfAllPredictions count]) us2 = [self.arrayOfAllPredictions objectAtIndex:indexPath.row];
        if (us2) {
            PFFile *imageFile2 = us2.corps[@"logo"];
            if (imageFile2) {
                [imgLogo2 setFile:imageFile2];
                [imgLogo2 loadInBackground];
            }
            
            lblName2.text = [self abbreviateName:us2.corps[@"corpsName"]];
            lblScore2.text = [NSString stringWithFormat:@"%.3f", us2.score];
        }
        
        UserScore *us3;
        if ([self.arrayOfActualRankings count]) us3 = [self.arrayOfActualRankings objectAtIndex:indexPath.row];
        if (us3) {
            PFFile *imageFile3 = us3.corps[@"logo"];
            if (imageFile3) {
                [imgLogo3 setFile:imageFile3];
                [imgLogo3 loadInBackground];
            }
            
            lblName3.text = [self abbreviateName:us3.corps[@"corpsName"]];
            lblScore3.text = [NSString stringWithFormat:@"%.3f", us3.score];
        }
    }
    
    return cell;
}

-(NSString *)abbreviateName:(NSString *)name {
    
    NSString *newName;
    
    if ([name isEqualToString:@"Santa Clara Vanguard"]) newName = @"Santa Clara";
    else if ([name isEqualToString:@"Phantom Regiment"]) newName = @"Phantom";
    else if ([name isEqualToString:@"Carolina Crown"]) newName = @"Crown";
    else if ([name isEqualToString:@"Madison Scouts"]) newName = @"Madison";
    else if ([name isEqualToString:@"Spirit of Atlanta"]) newName = @"Spirit";
    else if ([name isEqualToString:@"Oregon Crusaders"]) newName = @"Oregon";
    else if ([name isEqualToString:@"Boston Crusaders"]) newName = @"Boston";
    else newName = name;
    
    return newName;
    
}

-(void)selectCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)path onOrOff:(BOOL)on fromMethod:(BOOL)method {
    
    if (on) {
        if ([self.arrayOfIndexes count] < 12) {
            if (!method) [self.viewCorps.tableCorps selectRowAtIndexPath:path animated:NO scrollPosition: UITableViewScrollPositionNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            PFObject *corp = self.arrayOfCorps[path.row];
            if ([self.dictOfCorps objectForKey:corp[@"corpsName"]]) {
                [self.dictOfCorps setObject:@"YES" forKey:corp[@"corpsName"]];
                if (self.currentPhase == pick) {
                    if (![self.arrayOfIndexes containsObject:corp]) {
                        [self.arrayOfIndexes addObject:corp];
                    }
                }
            }
        }
    } else {
        if (!method) [self.viewCorps.tableCorps deselectRowAtIndexPath:path animated:NO];
        cell.accessoryType = UITableViewCellAccessoryNone;
        PFObject *corp = self.arrayOfCorps[path.row];
        if ([self.dictOfCorps objectForKey:corp[@"corpsName"]]) {
            [self.dictOfCorps setObject:@"NO" forKey:corp[@"corpsName"]];
            if (self.currentPhase == pick) {
                if ([self.arrayOfIndexes containsObject:corp]) {
                    [self.arrayOfIndexes removeObject:corp];
                }
            }
        }
    }
    
    [self checkSelectedCorps];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:YES fromMethod:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:NO fromMethod:YES];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    //move the corp
    PFObject *corpToMove = [self.arrayOfIndexes objectAtIndex:sourceIndexPath.row];
    [self.arrayOfIndexes removeObjectAtIndex:sourceIndexPath.row];
    [self.arrayOfIndexes insertObject:corpToMove atIndex:destinationIndexPath.row];
    [self.viewCorps.tableCorps reloadData];
    
    //move the score associated with the corp
    NSString *scoreToMove = [self.arrayOfScores objectAtIndex:sourceIndexPath.row];
    [self.arrayOfScores removeObjectAtIndex:sourceIndexPath.row];
    [self.arrayOfScores insertObject:scoreToMove atIndex:destinationIndexPath.row];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark
#pragma mark - Helpers
#pragma mark

-(void)checkSelectedCorps {
    
    if (self.currentPhase == pick) {
        int count = (int)[self.arrayOfIndexes count];
        if (count < 12) {
            self.viewCorps.btnSend.hidden = YES;
            int needs = 12 - count;
            if (needs == 1) [self changeText:@"Select 1 Finalist" forLabel:self.viewCorps.lblHeader];
            else [self changeText:[NSString stringWithFormat:@"Select %i Finalists", needs] forLabel:self.viewCorps.lblHeader];
            self.navigationItem.rightBarButtonItem = nil;
        } else if (count == 12) {
            [self changeText:@"Select Next" forLabel:self.viewCorps.lblHeader];
            [self showRightButton:NO];
        }
    }
}

-(void)showRightButton:(BOOL)done {
    
    if (self.viewCorps.btnSend.hidden) {
        self.viewCorps.btnSend.hidden = NO;
        self.viewCorps.btnSend.enabled = YES;
        self.viewCorps.btnSend.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        [UIView animateWithDuration:.3
                              delay:0
             usingSpringWithDamping:.3
              initialSpringVelocity:10
                            options:0
                         animations:^{
                             self.viewCorps.btnSend.transform = CGAffineTransformIdentity;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
    if (done) {
        [self.viewCorps.btnSend setTitle:@"Send" forState:UIControlStateNormal];
    } else {
        [self.viewCorps.btnSend setTitle:@"Next" forState:UIControlStateNormal];
    }
}

-(void)changeText:(NSString *)text forLabel:(UILabel *)label {
    
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.35;
    [label.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    // This will fade:
    label.text = text;
}

-(BOOL)areAllScoresEntered {
    
    if ([self.arrayOfScores count] != 12) return NO;
    
    for (NSString *score in self.arrayOfScores) {
        if ([score isEqualToString:@"0"]) return NO;
    }
    
    return YES;
}

-(void)predictionBackTapped {
    
    //this is the back button and cancel button depending on the
    //current phase
    
    switch (self.currentPhase) {
        case pick: [self.viewCorps closeView];
            break;
        case sort: self.currentPhase = pick;
            break;
        case score: self.currentPhase = sort;
            break;
    }
    
}

-(void)predictionClosed {
    
    [self goback];
}

-(void)predictionNext {
    
    [self next];
}

-(void)predictionThankYou {
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:8 options:0 animations:^{
        
        self.viewCorps.transform = CGAffineTransformScale(self.viewCorps.transform, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:8
                            options:0
                         animations:^{
                             self.viewCorps.transform = CGAffineTransformScale(self.viewCorps.transform, 0.1f, 0.1f);
                             self.viewCorps.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self.viewCorps removeFromSuperview];
                             [self.viewEffect removeFromSuperview];
                             [self showPredictions];
                         }];
    }];
}

-(void)next {
    
    if (self.currentPhase == pick) {

        self.currentPhase = sort;
        
    } else if (self.currentPhase == sort) {

        self.currentPhase = score;
        
    } else if (self.currentPhase == score) {
        
        //check to make sure all scores are entered
        if ([self areAllScoresEntered]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit Prediction"
                                                            message:@"Are you happy with your prediction? You will not be able to change it."
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Scores"
                                                            message:@"Not all scores have been entered."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    };
}

#pragma mark
#pragma mark - Properties
#pragma mark

-(NSMutableArray *)arrayOfCorps {
    if (!_arrayOfCorps) {
        _arrayOfCorps = [[NSMutableArray alloc] init];
    }
    return _arrayOfCorps;
}

-(NSMutableArray *)arrayOfIndexes {
    if (!_arrayOfIndexes) {
        _arrayOfIndexes = [[NSMutableArray alloc] init];
    }
    return _arrayOfIndexes;
}

-(NSMutableArray *)arrayOfScores {
    if (!_arrayOfScores) {
        _arrayOfScores = [[NSMutableArray alloc] init];
    }
    return _arrayOfScores;
}

-(NSMutableDictionary *)dictOfCorps {
    if (!_dictOfCorps) {
        _dictOfCorps = [[NSMutableDictionary alloc] init];
    }
    return _dictOfCorps;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"prediction"]) {
        CBFinalsPredictionViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}

-(void)predictionMade {
    
    [self showPredictions];
}

#pragma mark
#pragma mark - UITextField Delegates
#pragma mark

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSString *txt = textField.text;
    textField.text = nil;
    textField.text = txt;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.currentResponder = textField;
}

int previouslen;
bool backspaced;

-(void)textFieldDidChange:(UITextField *)theTextField {
    
    if (theTextField) {
        if (theTextField.text.length < previouslen) {
            backspaced = YES;
        }
        
        if([theTextField.text hasSuffix:@"."]) {
            if (theTextField.text.length == 2) {
                
                NSRange ran = NSMakeRange(0, 1);
                NSString *txt = [theTextField.text substringWithRange:ran];
                theTextField.text = txt;
                return;
            }
        }
        
        if (theTextField.text.length == 3) {
            NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"."];
            NSRange range = [theTextField.text rangeOfCharacterFromSet:cset];
            if (range.location == NSNotFound) {
                NSRange range = NSMakeRange(0, 2);
                NSRange range2 = NSMakeRange(1, 1);
                NSString *one = [theTextField.text substringWithRange:range];
                NSString *two = [theTextField.text substringWithRange:range2];
                theTextField.text = [NSString stringWithFormat:@"%@.%@", one, two];
            }
        }
        
        if (theTextField.text) {
            NSString *regex;
            if (theTextField.tag == 4) regex = @"^[0-9]{0,2}[\\.]{0,1}[0-9]{0,3}$";
            else regex = @"^[0-9]{0,2}[\\.]{0,1}[0-9]{0,2}$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if (![pred evaluateWithObject:theTextField.text])
            { // Error, input not matching! Remove last added character.
                int len = (int)theTextField.text.length-((theTextField.text.length-1 == 3) ? 2 : 1);
                theTextField.text = [theTextField.text substringWithRange:NSMakeRange(0, len)];
                // Now checks if the new length, i.e. the length when the last digit has been deleted is 3, which means that the decimal dot is the last character. If so remove 2 instead of only 1 character!
            }
            else
            { // OKay here, do whatever
                if (!backspaced) {
                    if(theTextField.text.length == 2) // Add decimal dot if two digits have been entered!
                    {
                        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"."];
                        NSRange range = [theTextField.text rangeOfCharacterFromSet:cset];
                        if (range.location == NSNotFound) {
                            theTextField.text = [NSString stringWithFormat:@"%@.", theTextField.text];
                        }
                    }
                }
            }
        }
        
        previouslen = (int)theTextField.text.length;
        backspaced = NO;
    }
}

- (void)resignOnTap:(id)iSender {
    
    if (self.currentResponder) {
        [self.currentResponder resignFirstResponder];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField) {
        CGPoint location = [textField.superview convertPoint:textField.center toView:self.viewCorps.tableCorps];
        
        NSIndexPath *indexPath = [self.viewCorps.tableCorps indexPathForRowAtPoint:location];
        
        if (textField.text.length == 1) textField.text = @"";
        if (textField.text.length == 2) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @".00"];
        if (textField.text.length == 3) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @"00"];
        if (textField.text.length == 4) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @"0"];
        
        [self.arrayOfScores replaceObjectAtIndex:indexPath.row withObject:textField.text];
    }
}

#pragma mark
#pragma mark - UIAlertView Delegate
#pragma mark

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) { //submit prediction and close
        
        
        self.viewPredictionSubmitted =
        [[[NSBundle mainBundle] loadNibNamed:@"CBPredictionSubmitted"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        for (UIView *view in [self.viewCorps subviews]) {
            [view removeFromSuperview];
        }
        [UIView animateWithDuration:.25
                              delay:0
                            options:0
                         animations:^{
                             self.viewCorps.frame = CGRectMake(self.viewCorps.frame.origin.x, self.viewCorps.frame.origin.y, self.viewPredictionSubmitted.frame.size.width, self.viewPredictionSubmitted.frame.size.height);
                             self.viewCorps.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
                         } completion:^(BOOL finished) {
                             [self.viewPredictionSubmitted show];
                         }];
        [self.viewCorps addSubview:self.viewPredictionSubmitted];
        [self.viewPredictionSubmitted setDelegate:self];
        

        PFUser *user = [PFUser currentUser];
        [user setObject:[NSNumber numberWithBool:YES] forKey:@"predictionEntered"];
        [user saveEventually];
        
        for (int i = 0; i < 12; i++) {
            PFObject *corps = self.arrayOfIndexes[i];
            NSString *score = self.arrayOfScores[i];
            
            PFObject *predictionScore = [PFObject objectWithClassName:@"predictions"];
            [predictionScore setObject:corps forKey:@"corp"];
            [predictionScore setObject:score forKey:@"score"];
            [predictionScore setObject:[NSNumber numberWithInt:i+1] forKey:@"placement"];
            [predictionScore setObject:[PFUser currentUser] forKey:@"user"];
            [predictionScore setObject:corps[@"corpsName"] forKey:@"corpName"];
            [predictionScore saveEventually];
        }
    }
}

-(NSMutableArray *)arrayOfActualRankings {
    if (!_arrayOfActualRankings) {
        _arrayOfActualRankings = [[NSMutableArray alloc] init];
    }
    return _arrayOfActualRankings;
}

-(NSMutableArray *)arrayOfUserPrediction {
    if (!_arrayOfUserPrediction) {
        _arrayOfUserPrediction = [[NSMutableArray alloc] init];
    }
    return _arrayOfUserPrediction;
}

-(NSMutableArray *)arrayOfAllPredictions {
    if (!_arrayOfAllPredictions) {
        _arrayOfAllPredictions = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllPredictions;
}

@end
