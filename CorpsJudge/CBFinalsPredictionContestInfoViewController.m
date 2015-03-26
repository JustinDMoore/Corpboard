//
//  CBFinalsPredictionContestInfoViewController.m
//  CorpsBoard
//
//  Created by Isaias Favela on 6/30/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBFinalsPredictionContestInfoViewController.h"
#import "CBSingle.h"
#import "CBTerms.h"
#import "UserScore.h"
#import <ParseUI/ParseUI.h>
#import "KVNProgress.h"
#import "Configuration.h"

@interface CBFinalsPredictionContestInfoViewController () {
    CBSingle *data;
    Configuration *config;
    PFQuery *queryPredictions;
}

- (IBAction)btnTerms_tapped:(id)sender;

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
    data = [CBSingle data];
    self.tablePredictions.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

    PFUser *user = [PFUser currentUser];
    BOOL predicted = [user[@"predictionEntered"] boolValue];
    if (predicted) {
        loop = 0;
        [self.arrayOfAllPredictions removeAllObjects];
        [self showPredictions];
    } else {
        [self makePrediction];
    }
}

-(void)makePrediction {
    
    self.tablePredictions.hidden = YES;
    self.lblAveragePredictions.hidden = YES;
    self.btnSubmitPrediction.hidden = NO;
}

-(void)showPredictions {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });
    [self getPredictions];
    self.tablePredictions.hidden = YES;
    self.lblAveragePredictions.hidden = NO;
    self.btnSubmitPrediction.hidden = YES;
}


-(void)getPredictions {

    for (PFObject *corp in data.arrayOfWorldClass) {
        [self getRankForCorps:corp];
    }
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
           
            if (loop == [data.arrayOfWorldClass count]) {
                // we're done
                [self sortPredictions];
            }
        } else {
            if (loop == [data.arrayOfWorldClass count]) {
                [self sortPredictions];
            }
        }
    }];
}

-(void)sortPredictions {
    
    NSSortDescriptor *sortUserRankings = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortUserRankingsDescriptor = [NSArray arrayWithObject: sortUserRankings];
    
    if ([self.arrayOfAllPredictions count]) [self.arrayOfAllPredictions sortUsingDescriptors:sortUserRankingsDescriptor];

    dispatch_async(dispatch_get_main_queue(), ^{
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTerms_tapped:(id)sender {
    
    NSString *terms = data.objAdmin[@"contestTerms"];

    CBTerms *termView =
    [[[NSBundle mainBundle] loadNibNamed:@"CBTerms"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    [self.view addSubview:termView];
    [termView showInParent:self.view.frame withHTMLString:terms];
}

#pragma mark
#pragma mark - UITableView Datasource & Delegates
#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tablePredictions dequeueReusableCellWithIdentifier:@"rank"];
    UILabel *lblRank = (UILabel *)[cell viewWithTag:1];
    UILabel *lblCorpsName = (UILabel *)[cell viewWithTag:2];
    UILabel *lblScore = (UILabel *)[cell viewWithTag:3];
    PFImageView *imgLogo = (PFImageView *)[cell viewWithTag:8];
    UserScore *us;
    if ([self.arrayOfAllPredictions count]) us = [self.arrayOfAllPredictions objectAtIndex:indexPath.row];
    if (us) {
        PFFile *imageFile = us.corps[@"logo"];
        if (imageFile) {
            [imgLogo setFile:imageFile];
            [imgLogo loadInBackground];
        }
        lblRank.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1];
        lblCorpsName.text = us.corps[@"corpsName"];
        lblScore.text = [NSString stringWithFormat:@"%.3f", us.score];
    }
    
    return cell;
}

#pragma mark
#pragma mark - Properties
#pragma mark

-(NSMutableArray *)arrayOfAllPredictions {
    if (!_arrayOfAllPredictions) {
        _arrayOfAllPredictions = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllPredictions;
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

@end
