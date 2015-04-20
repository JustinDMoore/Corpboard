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
#import "KVNProgress.h"
#import "NSDate+Utilities.h"
#import <ParseUI/ParseUI.h>
#import <SpriteKit/SpriteKit.h>
#import "CBEffect.h"
#import "Configuration.h"

CBSingle *data;
int votedScore;
int votedFavorites;

@interface CBShowDetailsViewController() <CBJudgeViewControllerDelegate> {
    PFQuery *queryVoteScores, *queryVoteFavorites;
    PFQuery *queryScores;
}

@property (strong, nonatomic) NSMutableArray *arrayOfWorldClassScores;
@property (strong, nonatomic) NSMutableArray *arrayOfOpenClassScores;
@property (strong, nonatomic) NSMutableArray *arrayOfAllAgeClassScores;

@property (weak, nonatomic) IBOutlet UILabel *lblShowDate;
@property (weak, nonatomic) IBOutlet UILabel *lblShowName;
@property (weak, nonatomic) IBOutlet UILabel *lblShowLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnViewRecap;
@property (strong, nonatomic) IBOutlet UITableView *tableCorps;
@property (weak, nonatomic) IBOutlet UIButton *btnReviewShow;
@property (weak, nonatomic) IBOutlet UILabel *lblEndShow;
@property (weak, nonatomic) IBOutlet UIButton *btnEndShow;
@property (weak, nonatomic) IBOutlet UIButton *btnRecapLink;
@property (weak, nonatomic) IBOutlet UILabel *lblRecapLink;
@property IBOutlet SKView *skView;
@property (nonatomic, strong) CBEffect *scene;

- (IBAction)btnViewRecap_tapped:(id)sender;
- (IBAction)btnReviewShow_tapped:(id)sender;
- (IBAction)btnEndShow_tapped:(id)sender;
- (IBAction)btnRecapLink_tapped:(id)sender;

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
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)goback {
    
    [queryScores cancel];
    [queryVoteFavorites cancel];
    [queryVoteScores cancel];
    [self.scene stop];
    [self.scene removeAllActions];
    [self.scene removeAllChildren];
    self.scene = nil;
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress dismiss];
    });
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Configure the SKView
    SKView * skView = _skView;
    
    // Create and configure the scene.
    
    
    // Present the scene.
    skView.allowsTransparency = YES;
    [skView presentScene:self.scene];
    self.tableCorps.backgroundColor = [UIColor clearColor];
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });
    [self setup];
    
    
}

-(void)setup {
    
    [self initVariables];
    [self initUI];
    [self loadShow];
    [self didUserVoteForShow];
}

-(void)initVariables {
    
    [self.arrayOfWorldClassScores removeAllObjects];
    [self.arrayOfOpenClassScores removeAllObjects];
    [self.arrayOfAllAgeClassScores removeAllObjects];
    self.title = @"Show Details";
    
}

-(void)initUI {
    
    if (data.adminMode) {
        self.btnEndShow.hidden = NO;
        self.lblEndShow.hidden = NO;
        self.btnRecapLink.hidden = NO;
        self.lblRecapLink.hidden = NO;
    } else {
        self.btnEndShow.hidden = YES;
        self.lblEndShow.hidden = YES;
        self.btnRecapLink.hidden = YES;
        self.lblRecapLink.hidden = YES;
    }
    
    self.btnViewRecap.enabled = NO;
    self.tableCorps.hidden = YES;
    self.btnReviewShow.enabled = NO;
    self.tableCorps.backgroundColor = [UIColor clearColor];
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
        self.btnReviewShow.enabled = NO;
        
    } else {
        NSDate *showD = self.show[@"showDate"];
        if ([showD isInFuture]) {
            self.btnReviewShow.enabled = NO;
        } else {
            NSString *exception = self.show[@"exception"];
            if ([exception length]) {
                self.btnReviewShow.enabled = NO;
            } else {
                self.btnReviewShow.enabled = YES;
            }
        }
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
    
    queryVoteFavorites = [PFQuery queryWithClassName:@"scores"];
    [queryVoteFavorites whereKey:@"user" equalTo:[PFUser currentUser]];
    [queryVoteFavorites whereKey:@"show" equalTo:self.show];
    [queryVoteFavorites whereKey:@"isOfficial" equalTo:[NSNumber numberWithBool:NO]];
    [queryVoteFavorites countObjectsInBackgroundWithTarget:self selector:@selector(votedScore:error:)];
    
    queryVoteFavorites = [PFQuery queryWithClassName:@"favorites"];
    [queryVoteFavorites whereKey:@"user" equalTo:[PFUser currentUser]];
    [queryVoteFavorites whereKey:@"show" equalTo:self.show];
    [queryVoteFavorites countObjectsInBackgroundWithTarget:self selector:@selector(votedFavorites:error:)];
}

-(void)voted {
    
    self.btnReviewShow.enabled = NO;
}

-(void)showUIAfterLoad {
    
    [self.tableCorps reloadData];
    self.tableCorps.hidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
}


-(void)loadShow {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM d"];
    NSString *dateString = [format stringFromDate:self.show[@"showDate"]];
    self.lblShowDate.text = dateString;
    self.lblShowName.text = self.show[@"showName"];
    self.lblShowLocation.text = self.show[@"showLocation"];
    
    [self getScoresForShow];
    
    NSString *exc = self.show[@"exception"];
    if ([exc isEqualToString:@"Rained Out"]) {
        [self.scene startRaining];
    }
}

-(void)getScoresForShow {
    
    if (![self.arrayOfWorldClassScores count] && ![self.arrayOfOpenClassScores count] && ![self.arrayOfAllAgeClassScores count] ) {
        
        queryScores = [PFQuery queryWithClassName:@"scores"];
        [queryScores whereKey:@"show" equalTo:self.show];
        [queryScores whereKey:@"isOfficial" equalTo:[NSNumber numberWithBool:YES]];
        [queryScores setLimit:1000];
        [queryScores includeKey:@"corps"];
        
        BOOL isShowOver = [self.show[@"isShowOver"] boolValue];
        NSString *exc = self.show[@"exception"];
        if (isShowOver) {
            if (![exc length]) {
                [queryScores orderByDescending:@"score"]; //order by score if show complete, and no exception (rain)
            }
        } else {
            NSSortDescriptor *time = [[NSSortDescriptor alloc] initWithKey:@"performanceTime" ascending:YES];
            NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:@"corpsName" ascending:YES];
            [queryScores orderBySortDescriptors:@[time, name]];
        }
        
        [queryScores findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count]) {
                    for (PFObject *score in objects) {
                        PFObject *corps = score[@"corps"];
                        
                        if ([corps[@"class"] isEqualToString:@"World"]) {
                            
                            [self.arrayOfWorldClassScores addObject:score];
                            
                        } else if ([corps[@"class"] isEqualToString:@"Open"]) {
                            
                            [self.arrayOfOpenClassScores addObject:score];
                            
                        } else if ([corps[@"class"] isEqualToString:@"All Age"]) {
                            
                            [self.arrayOfAllAgeClassScores addObject:score];
                            
                        }
                    }
                } else {
                    NSLog(@"No scores for show");
                }
                [self showUIAfterLoad];
            } else {
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
    
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return @"World Class";
        case 1: return @"Open Class";
        case 2: return @"All Age Class";
        default: return @"Error";
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    // Background color
    view.tintColor = [UIColor darkGrayColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor lightGrayColor]];
    [header.textLabel setFont:[UIFont systemFontOfSize:16]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            if ([self.arrayOfWorldClassScores count]) return [self.arrayOfWorldClassScores count];
            else return 0;
        case 1:
            if ([self.arrayOfOpenClassScores count]) return [self.arrayOfOpenClassScores count];
            else return 0;
        case 2:
            if ([self.arrayOfAllAgeClassScores count]) return [self.arrayOfAllAgeClassScores count];
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
    
    PFObject *corps;
    PFObject *score;
    
    switch (indexPath.section) {
        case 0: //world
            if ([self.arrayOfWorldClassScores count]) score = [self.arrayOfWorldClassScores objectAtIndex:[indexPath row]];
            break;
        case 1: //open
            if ([self.arrayOfOpenClassScores count]) score = [self.arrayOfOpenClassScores objectAtIndex:[indexPath row]];
            break;
        case 2: //all age
            if ([self.arrayOfAllAgeClassScores count]) score = [self.arrayOfAllAgeClassScores objectAtIndex:[indexPath row]];
            break;
            
        default:
            break;
    }
    
    NSString *exc = score[@"exception"];
    
    if (isOver) {
        if ([exc length]) {
            
            cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"time"];
            
            lblCorpsName = (UILabel *)[cell viewWithTag:1];
            lblTime = (UILabel *)[cell viewWithTag:2];
        } else {
            
            cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"score"];
            lblPosition = (UILabel *)[cell viewWithTag:2];
            lblScore = (UILabel *)[cell viewWithTag:3];
            lblCorpsName = (UILabel *)[cell viewWithTag:1];
        }
        
    } else {
        cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"time"];
        
        lblCorpsName = (UILabel *)[cell viewWithTag:1];
        lblTime = (UILabel *)[cell viewWithTag:2];
    }
    
    imgLogo = (PFImageView *)[cell viewWithTag:4];
    
    if (score) {
        corps = score[@"corps"];
        if (isOver) {
            lblCorpsName.text = corps[@"corpsName"];
            if ([exc length]) {
                lblTime.text = exc;
            } else {
                lblPosition.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1];
                lblScore.text = score[@"score"];
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

-(NSMutableArray *)arrayOfAllAgeClassScores {
    
    if (!_arrayOfAllAgeClassScores) {
        _arrayOfAllAgeClassScores = [[NSMutableArray alloc] init];
    }
    return _arrayOfAllAgeClassScores;
}

- (IBAction)btnEndShow_tapped:(id)sender {
    
    [self performSegueWithIdentifier:@"endShow" sender:self];
}

- (IBAction)btnRecapLink_tapped:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recap Link" message:@"Tap to paste the full web link for show recap." delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* textField = [alert textFieldAtIndex:0];
    textField.text = self.show[@"recapURL"];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length]) {
            self.show[@"recapURL"] = textField.text;
            [self.show saveInBackground];
        }
    }
}

-(IBAction)btnReviewShow_tapped:(id)sender {
    
    [self performSegueWithIdentifier:@"judge" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"judge"]) {
        
        // Get reference to the destination view controller
        CBJudgeViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        // Pass any objects to the view controller here, like...
        vc.show = self.show;
        vc.arrayOfWorldClassScores = self.arrayOfWorldClassScores;
        vc.arrayOfOpenClassScores = self.arrayOfOpenClassScores;
        vc.arrayOfAllAgeClassScores = self.arrayOfAllAgeClassScores;
        
    } else if ([segue.identifier isEqualToString:@"endShow"]) {
        
        CBEndShowViewController *vc = [segue destinationViewController];
        vc.show = self.show;
        vc.arrayOfWorldClassScores = self.arrayOfWorldClassScores;
        vc.arrayOfOpenClassScores = self.arrayOfOpenClassScores;
        vc.arrayOfAllAgeClassScores = self.arrayOfAllAgeClassScores;
        vc.delegate = self;
    }
}

- (IBAction)btnViewRecap_tapped:(id)sender {
    
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"web";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    CBWebViewController * web = (CBWebViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    web.webURL = self.show[@"recapURL"];
    web.websiteTitle = [NSString stringWithFormat:@"%@ Recap", self.show[@"showName"]];
    web.websiteSubTitle = web.webURL;
    
    [self presentViewController:web animated:YES completion:nil];
}

-(CBEffect *)scene {
    if (!_scene) {
        _scene = [CBEffect sceneWithSize:[[UIScreen mainScreen] bounds].size];
        _scene.scaleMode = SKSceneScaleModeAspectFill;
        _scene.backgroundColor = [UIColor blackColor];
    }
    return _scene;
}


#pragma mark
#pragma mark - End Show Delegate Methods
#pragma mark

-(void)showCompleted {
    
    [self setup];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress dismiss];
    });
}

@end
