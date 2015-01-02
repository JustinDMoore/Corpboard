//
//  CBShowDetailsViewController.m
//  CorpsBoard
//
//  Created by Justin Moore on 6/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBShowDetailsViewController.h"
#import "CBWebViewController.h"
#import "CBJudgeViewController.h"
#import "CBSingle.h"

#import <ParseUI/ParseUI.h>

CBSingle *data;

int votedScore;
int votedFavorites;

@interface CBShowDetailsViewController() <CBJudgeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfWorldClassScores;
@property (strong, nonatomic) NSMutableArray *arrayOfOpenClassScores;

@property (weak, nonatomic) IBOutlet UILabel *lblShowDate;
@property (weak, nonatomic) IBOutlet UILabel *lblShowName;
@property (weak, nonatomic) IBOutlet UILabel *lblShowLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnViewRecap;

@property (strong, nonatomic) IBOutlet UITableView *corpsTable;

@property (weak, nonatomic) IBOutlet UILabel *lblLoading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInicator;

@property (weak, nonatomic) IBOutlet UIButton *btnAddRecap;
@property (weak, nonatomic) IBOutlet UITextField *txtRecapURL;

- (IBAction)btnJudge_Clicked:(id)sender;
- (IBAction)submitRecapURL:(id)sender;

@end

@implementation CBShowDetailsViewController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"BackArrow"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {

    [super viewDidLoad];
    [self setup];
}

-(void)setup {
    
    [self initVariables];
    [self initUI];
    [self loadShow];
    [self didUserVoteForShow];
}

-(void)initVariables {
    
    self.title = @"Show Details";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)initUI {
    
    [self.activityInicator startAnimating];
    
    if (data.adminMode) {
        self.btnAddRecap.hidden = NO;
        self.txtRecapURL.hidden = NO;
    } else {
        self.btnAddRecap.hidden = YES;
        self.txtRecapURL.hidden = YES;
    }
    
    self.btnViewRecap.enabled = NO;
    self.corpsTable.hidden = YES;
    self.activityInicator.hidden = NO;
    self.lblLoading.hidden = NO;
    self.btnJudge.enabled = NO;
    
}

-(void)votedFavorites:(NSNumber *)result error:(NSError *)error {
    
    votedFavorites = [result intValue];
    [self checkVote];
}

-(void)votedScore:(NSNumber *)result error:(NSError *)error {

    votedScore = [result intValue];
    [self checkVote];
}

-(void)checkVote {
    
    if ((votedScore > 0) || (votedFavorites > 0)) {
        self.btnJudge.enabled = NO;
    } else {
        self.btnJudge.enabled = YES;
    }
    
    NSString *recap = self.show[@"recapURL"];
    if (recap) {
        if (![recap isEqualToString:@""]){
            self.btnViewRecap.enabled = YES;
        }
    } else {
        self.btnViewRecap.enabled = NO;
    }
}

-(void)didUserVoteForShow {

    PFQuery *query = [PFQuery queryWithClassName:@"scores"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"show" equalTo:self.show];
    [query whereKey:@"isOfficial" equalTo:[NSNumber numberWithBool:NO]];
    [query countObjectsInBackgroundWithTarget:self selector:@selector(votedScore:error:)];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"favorites"];
    [query1 whereKey:@"user" equalTo:[PFUser currentUser]];
    [query1 whereKey:@"show" equalTo:self.show];
    [query1 countObjectsInBackgroundWithTarget:self selector:@selector(votedFavorites:error:)];
}

-(void)voted {
    
    self.btnJudge.enabled = NO;
}

-(void)showUIAfterLoad {
    
    [self.corpsTable reloadData];
    [self.activityInicator stopAnimating];
    self.activityInicator.hidden = YES;
    self.lblLoading.hidden = YES;
    self.corpsTable.hidden = NO;
}


-(void)loadShow {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM d"];
    NSString *dateString = [format stringFromDate:self.show[@"showDate"]];
    self.lblShowDate.text = dateString;
    self.lblShowName.text = self.show[@"showName"];
    self.lblShowLocation.text = self.show[@"showLocation"];
    
    [self getScoresForShow];

}

-(void)getScoresForShow {

    if (![self.arrayOfWorldClassScores count] && ![self.arrayOfOpenClassScores count]) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"scores"];
        [query whereKey:@"show" equalTo:self.show];
        [query whereKey:@"isOfficial" equalTo:[NSNumber numberWithBool:YES]];
        [query setLimit:1000];
        [query includeKey:@"corps"];
        
        BOOL isShowOver = [self.show[@"isShowOver"] boolValue];
        if (isShowOver) {
            [query orderByDescending:@"score"];
        } else {
            NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"performanceTime" ascending:YES];
            NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:@"corpsName" ascending:YES];
            [query orderBySortDescriptors:@[desc, name]];
        }
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count]) {
                    for (PFObject *score in objects) {
                        PFObject *corps = score[@"corps"];
                        BOOL isWorld = [corps[@"isWorldClass"] boolValue];
                        if (isWorld) {
                            [self.arrayOfWorldClassScores addObject:score];
                        } else {
                            [self.arrayOfOpenClassScores addObject:score];
                        }
                    }
                } else {
                    NSLog(@"No scores for show");
                }
                [self showUIAfterLoad];
            } else {
                // Log details of the failure
                NSLog(@"Error getting official scores: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UITableview Delegates
#pragma mark

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return @"World Class";
        case 1: return @"Open Class";
        default: return @"Error";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        switch (section) {
            case 0:
                if ([self.arrayOfWorldClassScores count]) return [self.arrayOfWorldClassScores count];
                else return 0;
            case 1:
                if ([self.arrayOfOpenClassScores count]) return [self.arrayOfOpenClassScores count];
                else return 0;
            default: return 0;
        }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isOver = [self.show[@"isShowOver"] boolValue];
    
    UITableViewCell *cell;
    
    UILabel *lblCorpsName;
    UILabel *lblPosition;
    UILabel *lblScore;
    UILabel *lblTime;
    PFImageView *imgLogo;
    
    if (isOver) {
         cell = [self.corpsTable dequeueReusableCellWithIdentifier:@"score"];
        lblPosition = (UILabel *)[cell viewWithTag:2];
        lblScore = (UILabel *)[cell viewWithTag:3];
        lblCorpsName = (UILabel *)[cell viewWithTag:1];
    } else {
         cell = [self.corpsTable dequeueReusableCellWithIdentifier:@"time"];
        
        lblCorpsName = (UILabel *)[cell viewWithTag:1];
        lblTime = (UILabel *)[cell viewWithTag:2];
    }
   
    imgLogo = (PFImageView *)[cell viewWithTag:4];

    PFObject *corps;
    PFObject *score;

        if ([indexPath section] == 0) {
            if ([self.arrayOfWorldClassScores count]) score = [self.arrayOfWorldClassScores objectAtIndex:[indexPath row]];
        } else {
            if ([self.arrayOfOpenClassScores count]) score = [self.arrayOfOpenClassScores objectAtIndex:[indexPath row]];
        }
    if (score) {
        corps = score[@"corps"];

        if (isOver) {
            lblCorpsName.text = corps[@"corpsName"];
            lblPosition.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1];
            NSNumber *totalscore = score[@"score"];
            if (totalscore) {
                lblScore.text = [NSString stringWithFormat:@"%@", totalscore];
            } else {
                lblScore.text = @"";
            }
        } else {
            lblCorpsName.text = corps[@"corpsName"];
            lblTime.text = score[@"performanceTime"];
        }
    }
    
    PFFile *imageFile = corps[@"logo"];
    if (imageFile) {
        [imgLogo setFile:imageFile];
        [imgLogo loadInBackground];
    }
    
    return cell;
}

-(NSMutableArray *)arrayOfWorldClassScores {
    
    if (!_arrayOfWorldClassScores) {
        _arrayOfWorldClassScores = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldClassScores;
}

-(NSMutableArray *)arrayOfOpenClassScores {
    
    if (!_arrayOfOpenClassScores) {
        _arrayOfOpenClassScores = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenClassScores;
}

- (IBAction)btnJudge_Clicked:(id)sender {
    
    [self performSegueWithIdentifier:@"judge" sender:self];
    
}

- (IBAction)submitRecapURL:(id)sender {
    
    if (![self.txtRecapURL.text isEqualToString:@""]) {
        self.show[@"recapURL"] = self.txtRecapURL.text;
        [self.show saveInBackground];
        self.txtRecapURL.text = @"Success";
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"judge"])
    {
        // Get reference to the destination view controller
        CBJudgeViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        // Pass any objects to the view controller here, like...
        vc.show = self.show;
        vc.arrayOfWorldClassScores = self.arrayOfWorldClassScores;
        vc.arrayOfOpenClassScores = self.arrayOfOpenClassScores;
    } else if ([[segue identifier] isEqualToString:@"web"]) {
        CBWebViewController *vc = [segue destinationViewController];
        vc.webURL = self.show[@"recapURL"];
        vc.websiteTitle = [NSString stringWithFormat:@"%@ Recap", self.show[@"showName"]];
        vc.websiteSubTitle = vc.webURL;
    } 
}

@end
