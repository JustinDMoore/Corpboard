//
//  CBShowDetailsViewController.m
//  CorpsBoard
//
//  Created by Justin Moore on 6/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBShowDetailsViewController.h"
#import "CBWebViewController.h"
#import "CBSingle.h"
#import "KVNProgress.h"
#import "NSDate+Utilities.h"
#import <ParseUI/ParseUI.h>
#import <SpriteKit/SpriteKit.h>
#import "CBEffect.h"
#import "Configuration.h"
#import "CBTourMapViewController.h"

PFObject *favDrumsW;
PFObject *favHornlineW;
PFObject *favGuardW;
PFObject *favCorpsW;
PFObject *loudHornlineW;

PFObject *favDrumsO;
PFObject *favHornlineO;
PFObject *favGuardO;
PFObject *favCorpsO;
PFObject *loudHornlineO;

PFObject *favDrumsA;
PFObject *favHornlineA;
PFObject *favGuardA;
PFObject *favCorpsA;
PFObject *loudHornlineA;

NSInteger currentRowIndex;

NSString *feedbackString;

CBSingle *data;
int votedScore;
int votedFavorites;
NSString *currentView;

@interface CBShowDetailsViewController() {
    PFQuery *queryVoteScores, *queryVoteFavorites;
    PFQuery *queryScores;
}

typedef enum : int {
    phaseScore = 0,
    phaseBestdrums = 1,
    phaseBesthornline = 2,
    phaseLoudesthornline = 3,
    phaseBestguard = 4,
    phaseFavorite = 5,
    phaseFeedback,
    phaseSummary
} phase;

typedef enum : int {
    catdrums, cathornline, catguard, catcorps, catloud
} category;

@property (nonatomic) category cat;

//WScores and OScores are only to save user scores once they click 'next' and the table cells are lost
@property (nonatomic, strong) NSMutableArray *WScores;
@property (nonatomic, strong) NSMutableArray *OScores;
@property (nonatomic, strong) NSMutableArray *AScores;
@property (nonatomic, strong) UITextView *currentTextView;
@property (nonatomic, assign) id currentResponder;
@property (nonatomic, assign) phase scorePhase;

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
@property (weak, nonatomic) IBOutlet UIButton *btnViewMap;
@property (weak, nonatomic) IBOutlet UILabel *lblViewMap;

@property IBOutlet SKView *skView;
@property (nonatomic, strong) CBEffect *scene;

- (IBAction)btnViewRecap_tapped:(id)sender;
- (IBAction)btnReviewShow_tapped:(id)sender;
- (IBAction)btnEndShow_tapped:(id)sender;
- (IBAction)btnRecapLink_tapped:(id)sender;
- (IBAction)btnViewMap_tapped:(id)sender;

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
    
    [self resetShowReviewViews];
    self.fromMaps = NO;
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
    
    self.tableCorps.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    if (self.fromMaps) {
        self.btnViewMap.hidden = YES;
        self.lblViewMap.hidden = YES;
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
    
    if (tableView == self.viewStartReview.tableReview) {
        return 1;
    } else if (tableView == self.viewFavorite.tableCorps) {
        return 3;
    } else {
        if (![self.arrayOfWorldClassScores count] && ![self.arrayOfOpenClassScores count] && ![self.arrayOfAllAgeClassScores count]) {
            return 1;
        } else return 3;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.viewStartReview.tableReview) {
        return @"";
    } else {
        if (![self.arrayOfWorldClassScores count] && ![self.arrayOfOpenClassScores count] && ![self.arrayOfAllAgeClassScores count]) {
            return @"Performing corps to be announced"; //if no corps are listed for the show, display one row for a message
        } else {
            switch (section) {
                case 0: return @"World Class";
                case 1: return @"Open Class";
                case 2: return @"All Age Class";
                default: return @"Error";
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    // Background color
    if (tableView == self.tableCorps) {
        view.tintColor = [UIColor darkGrayColor];
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:[UIColor lightGrayColor]];
        [header.textLabel setFont:[UIFont systemFontOfSize:14]];
    } else {
        view.tintColor = [UIColor lightGrayColor];
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:[UIColor darkGrayColor]];
        [header.textLabel setFont:[UIFont systemFontOfSize:14]];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.viewStartReview.tableReview) {
        if (self.viewStartReview.loaded) return 7;
        else return 8;
    } else if (tableView == self.viewFavorite.tableCorps) {
        return [self numberOfRowsForFavorite:section];
    } else if (tableView == self.viewSummary.tableRecap) {
        switch (section) {
            case 0:
                if ([self.arrayOfWorldClassScores count]) {
                    return [self.arrayOfWorldClassScores count] + 5;
                } else return 0;
                break;
            case 1:
                if ([self.arrayOfOpenClassScores count]) {
                    return [self.arrayOfOpenClassScores count] + 5;
                } else return 0;
                break;
            case 2:
                if ([self.arrayOfAllAgeClassScores count]) {
                    return [self.arrayOfAllAgeClassScores count] + 5;
                } else return 0;
                break;
            default: return 0;
                break;
        }
    } else {
     
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
}

-(NSInteger)numberOfRowsForFavorite:(NSInteger)section {
    
    switch (section) {
        case 0:
            if ([self.arrayOfWorldClassScores count]) {
                
                if ([currentView isEqualToString:@"Summary"]) {
                    return [self.arrayOfWorldClassScores count] + 5;
                } else {
                    return [self.arrayOfWorldClassScores count];
                }
            } else return 0;
            
        case 1:
            if ([self.arrayOfOpenClassScores count]) {
                
                if ([currentView isEqualToString:@"Summary"]) {
                    return [self.arrayOfOpenClassScores count] + 5;
                } else {
                    return [self.arrayOfOpenClassScores count];
                }
            } else return 0;
        case 2:
            if ([self.arrayOfAllAgeClassScores count]) {
                
                if ([currentView isEqualToString:@"Summary"]) {
                    return [self.arrayOfAllAgeClassScores count] + 5;
                } else {
                    return [self.arrayOfAllAgeClassScores count];
                }
            } else return 0;
        default: return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.viewStartReview.tableReview) {
        return [self cellForStartReview:tableView atIndexPath:indexPath];
    } else if (tableView == self.viewFavorite.tableCorps) {
        return [self cellForFavorite:tableView atIndexPath:indexPath];
    } else if (tableView == self.viewSummary.tableRecap) {
        return [self cellForsummary:tableView atIndexPath:indexPath];
    }
    
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

-(CBReviewCaptionCell *)getCaptionCell {
    
    CBReviewCaptionCell *cell = (CBReviewCaptionCell *)[self.viewSummary.tableRecap dequeueReusableCellWithIdentifier:@"caption"];
    if (!cell) {
        [self.viewStartReview.tableReview registerNib:[UINib nibWithNibName:@"CBReviewCaptionCell" bundle:nil] forCellReuseIdentifier:@"caption"];
        cell = [self.viewStartReview.tableReview dequeueReusableCellWithIdentifier:@"caption"];
    }
    return cell;
}

-(CBReviewFavoriteCell *)getFavoriteCell {

    CBReviewFavoriteCell *cell = (CBReviewFavoriteCell *)[self.viewSummary.tableRecap dequeueReusableCellWithIdentifier:@"favorite"];
    if (!cell) {
        [self.viewStartReview.tableReview registerNib:[UINib nibWithNibName:@"CBReviewFavoriteCell" bundle:nil] forCellReuseIdentifier:@"favorite"];
        cell = [self.viewStartReview.tableReview dequeueReusableCellWithIdentifier:@"favorite"];
    }
    return cell;
}

-(UITableViewCell *)cellForsummary:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    //get the correct corps name
    UserScore *score;
    PFObject *corps;
    if ([indexPath section] == 0) {
        if ([self.WScores count]) {
            if (indexPath.row < [self.WScores count]) {
                if ([self.WScores count]) score = [self.WScores objectAtIndex:[indexPath row]];
            }
        }
    } else if ([indexPath section] == 1) {
        if ([self.OScores count]) {
            if (indexPath.row < [self.OScores count]) {
                if ([self.OScores count]) score = [self.OScores objectAtIndex:[indexPath row]];
            }
        }
    } else if ([indexPath section] == 2) {
        if ([self.AScores count]) {
            if (indexPath.row < [self.AScores count]) {
                if ([self.AScores count]) score = [self.AScores objectAtIndex:[indexPath row]];
            }
        }
    }
    
    
    if (score) corps = score.corps;
    
    //now we have the corps name for the row
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        if (indexPath.row + 1 <= [self.WScores count]) {
            cell = (CBReviewFavoriteCell *)[self getFavoriteCell];
        } else {
            cell = (CBReviewCaptionCell *)[self getCaptionCell];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row + 1 <= [self.OScores count]) {
            cell = (CBReviewFavoriteCell *)[self getFavoriteCell];
        } else {
            cell = (CBReviewCaptionCell *)[self getCaptionCell];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row + 1 <= [self.AScores count]) {
            cell = (CBReviewFavoriteCell *)[self getFavoriteCell];
        } else {
            cell = (CBReviewCaptionCell *)[self getCaptionCell];
        }
    }
    
    NSString *blank = @"None";
    NSString *mainText;
    NSString *detailText;
    
    UIImageView *img = (UIImageView *)[cell viewWithTag:8];
    
    switch ([indexPath section]) {
        case 0: // world class
            if ([self.arrayOfWorldClassScores count]) {
                if (indexPath.row < [self.arrayOfWorldClassScores count]) { //scores
                    mainText = corps[@"corpsName"];
                    UserScore *score = [self.WScores objectAtIndex:indexPath.row];
                    detailText = score.scoreString;
                    //detailText = [self.WScores objectAtIndex:indexPath.row];
                    NSString *s;
                    //s = [self.WScores objectAtIndex:indexPath.row];
                    s = detailText;
                    if (s) {
                        if ([s isEqualToString:@"0"] || [s isEqualToString:@""] || [s isEqualToString:@"0.00"])
                            detailText = @"No Score";
                    } else detailText = s;
                } else if (indexPath.row == [self.arrayOfWorldClassScores count]) { //                       best drums
                    mainText = @"Best Percussion";
                    img.image = [UIImage imageNamed:@"review_percussion"];
                    if (favDrumsW) {
                        detailText = favDrumsW[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 1) { //                  best brass
                    mainText = @"Best Brass";
                    img.image = [UIImage imageNamed:@"review_brass"];
                    if (favHornlineW) {
                        detailText = favHornlineW[@"corpsName"];
                        
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 2) { //                     best guard
                    mainText = @"Best Color Guard";
                    img.image = [UIImage imageNamed:@"review_colorguard"];
                    if (favGuardW) {
                        detailText = favGuardW[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 3) { //                    loudest brass
                    mainText = @"Loudest Brass";
                    img.image = [UIImage imageNamed:@"review_loudest"];
                    if (loudHornlineW) {
                        detailText = loudHornlineW[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 4) { //                   favorite corps
                    mainText = @"Favorite Show";
                    img.image = [UIImage imageNamed:@"review_favorite"];
                    if (favCorpsW) {
                        detailText = favCorpsW[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else {
                    //                        //cell.detailTextLabel.text = [self.WScores objectForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
                    //                        detailText = [self.WScores objectAtIndex:indexPath.row];
                }
                break;
            }
            
        case 1: // open class
            if ([self.arrayOfOpenClassScores count]) {
                if (indexPath.row < [self.arrayOfOpenClassScores count]) {
                    mainText = corps[@"corpsName"];
                    UserScore *score = [self.OScores objectAtIndex:indexPath.row];
                    detailText = score.scoreString;
                    //detailText = [self.OScores objectAtIndex:indexPath.row];
                    NSString *s;
                    //s = [self.OScores objectAtIndex:indexPath.row];
                    s = detailText;
                    if (s) {
                        if ([s isEqualToString:@"0"] || [s isEqualToString:@""] || [s isEqualToString:@"0.00"])
                            detailText = @"No Score";
                    } else detailText = s;
                } else if (indexPath.row == [self.arrayOfOpenClassScores count]) {
                    mainText = @"Best Percussion";
                    img.image = [UIImage imageNamed:@"review_percussion"];
                    if (favDrumsO) {
                        detailText = favDrumsO[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 1) {
                    mainText = @"Best Brass";
                    img.image = [UIImage imageNamed:@"review_brass"];
                    if (favHornlineO) {
                        detailText = favHornlineO[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 2) {
                    mainText = @"Best Color Guard";
                    img.image = [UIImage imageNamed:@"review_colorguard"];
                    if (favGuardO) {
                        detailText = favGuardO[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 3) {
                    mainText = @"Loudest Brass";
                    img.image = [UIImage imageNamed:@"review_loudest"];
                    if (loudHornlineO) {
                        detailText = loudHornlineO[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 4) {
                    mainText = @"Favorite Show";
                    img.image = [UIImage imageNamed:@"review_favorite"];
                    if (favCorpsO) {
                        detailText = favCorpsO[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                }
                
                break;
            }
            
        case 2: // all age class
            if ([self.arrayOfAllAgeClassScores count]) {
                if (indexPath.row < [self.arrayOfAllAgeClassScores count]) {
                    mainText = corps[@"corpsName"];
                    UserScore *score = [self.AScores objectAtIndex:indexPath.row];
                    detailText = score.scoreString;
                    //detailText = [self.OScores objectAtIndex:indexPath.row];
                    NSString *s;
                    //s = [self.OScores objectAtIndex:indexPath.row];
                    s = detailText;
                    if (s) {
                        if ([s isEqualToString:@"0"] || [s isEqualToString:@""] || [s isEqualToString:@"0.00"])
                            detailText = @"No Score";
                    } else detailText = s;
                } else if (indexPath.row == [self.arrayOfAllAgeClassScores count]) {
                    mainText = @"Best Percussion";
                    img.image = [UIImage imageNamed:@"review_percussion"];
                    if (favDrumsA) {
                        detailText = favDrumsA[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfAllAgeClassScores count] + 1) {
                    mainText = @"Best Brass";
                    img.image = [UIImage imageNamed:@"review_brass"];
                    if (favHornlineA) {
                        detailText = favHornlineA[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfAllAgeClassScores count] + 2) {
                    mainText = @"Best Color Guard";
                    img.image = [UIImage imageNamed:@"review_colorguard"];
                    if (favGuardA) {
                        detailText = favGuardA[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfAllAgeClassScores count] + 3) {
                    mainText = @"Loudest Brass";
                    img.image = [UIImage imageNamed:@"review_loudest"];
                    if (loudHornlineA) {
                        detailText = loudHornlineA[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                } else if (indexPath.row == [self.arrayOfAllAgeClassScores count] + 4) {
                    mainText = @"Favorite Show";
                    img.image = [UIImage imageNamed:@"review_favorite"];
                    if (favCorpsA) {
                        detailText = favCorpsA[@"corpsName"];
                    } else {
                        detailText = blank;
                    }
                }
                
                break;
            }
        default:
            mainText = @"Main Error";
            detailText =  @"Detail Error";
            break;
    }
    
    // for phase Summary only
    UILabel *lblPlacement = (UILabel *)[cell viewWithTag:5];
    UILabel *lblCorpName = (UILabel *)[cell viewWithTag:6];
    UILabel *lblDetail = (UILabel *)[cell viewWithTag:7];
    if (indexPath.section == 0) {
        if (indexPath.row + 1 <= [self.WScores count]) {
            lblPlacement.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1];
        } else {
            lblPlacement.text = @"";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row + 1 <= [self.OScores count]) {
            lblPlacement.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1];
        } else {
            lblPlacement.text = @"";
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row + 1 <= [self.AScores count]) {
            lblPlacement.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1];
        } else {
            lblPlacement.text = @"";
        }
    }
    
    lblCorpName.text = mainText;
    lblDetail.text = detailText;
    
    PFImageView *imgLogo = (PFImageView *)[cell viewWithTag:8];
    if (imgLogo) {
        PFFile *imageFile = corps[@"logo_light"];
        if (!imageFile) {
            imageFile = corps[@"logo"];
        }
        if (imageFile) {
            [imgLogo setFile:imageFile];
            [imgLogo loadInBackground];
        }
    }
    
    return cell;
}

-(UITableViewCell *)cellForFavorite:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {

    //get the correct corps name
    UserScore *score;
    PFObject *corps;
    if ([indexPath section] == 0) {
        if ([self.WScores count]) {
            if (indexPath.row < [self.WScores count]) {
                if ([self.WScores count]) score = [self.WScores objectAtIndex:[indexPath row]];
            }
        }
    } else if ([indexPath section] == 1) {
        if ([self.OScores count]) {
            if (indexPath.row < [self.OScores count]) {
                if ([self.OScores count]) score = [self.OScores objectAtIndex:[indexPath row]];
            }
        }
    } else if ([indexPath section] == 2) {
        if ([self.AScores count]) {
            if (indexPath.row < [self.AScores count]) {
                if ([self.AScores count]) score = [self.AScores objectAtIndex:[indexPath row]];
            }
        }
    }
    
    if (score) corps = score.corps;
    //now we have the corps for the row
    //what cell do we need?
    
    UITableViewCell *cell;
    
    if (self.scorePhase == phaseScore) {
        
        cell = (CBReviewScoreCell *)[self.viewStartReview.tableReview dequeueReusableCellWithIdentifier:@"reviewScoreCell"];
        if (!cell) {
            [self.viewStartReview.tableReview registerNib:[UINib nibWithNibName:@"CBReviewScoreCell" bundle:nil] forCellReuseIdentifier:@"reviewScoreCell"];
            cell = [self.viewStartReview.tableReview dequeueReusableCellWithIdentifier:@"reviewScoreCell"];
        }
        
        UITextField *text = (UITextField *)[cell viewWithTag:4];
        UILabel *label = (UILabel *)[cell viewWithTag:3];
        text.delegate = self;
        [text setKeyboardAppearance:UIKeyboardAppearanceDark];
        [tableView setUserInteractionEnabled:YES];
        [cell setUserInteractionEnabled:YES];
        [text setUserInteractionEnabled:YES];
        [text addTarget:self
                 action:@selector(textFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
        NSString *scoreString;
        switch (indexPath.section) {
            case 0:
                if ([self.WScores count]) {
                    UserScore *score = [self.WScores objectAtIndex:indexPath.row];
                    scoreString = score.scoreString;
                    //scoreString = [self.WScores objectAtIndex:indexPath.row];
                    if (score.score == 0)  {
                        text.text = @"";
                    } else text.text = scoreString;
                }
                break;
            case 1:
                if ([self.OScores count]) {
                    UserScore *score = [self.OScores objectAtIndex:indexPath.row];
                    scoreString = score.scoreString;
                    //scoreString = [self.OScores objectAtIndex:indexPath.row];
                    if (score.score == 0)  {
                        text.text = @"";
                    } else text.text = scoreString;
                }
                break;
            case 2:
                if ([self.AScores count]) {
                    UserScore *score = [self.AScores objectAtIndex:indexPath.row];
                    scoreString = score.scoreString;
                    //scoreString = [self.OScores objectAtIndex:indexPath.row];
                    if (score.score == 0)  {
                        text.text = @"";
                    } else text.text = scoreString;
                }
                break;
            default:
                text.text = @"Error";
                break;
        }
        label.text = corps[@"corpsName"];
        
        
        
        
        
    } else {
        cell = (CBReviewCell *)[self.viewStartReview.tableReview dequeueReusableCellWithIdentifier:@"selectCell"];
        if (!cell) {
            [self.viewStartReview.tableReview registerNib:[UINib nibWithNibName:@"CBPredictionSelectCell" bundle:nil] forCellReuseIdentifier:@"selectCell"];
            cell = [self.viewStartReview.tableReview dequeueReusableCellWithIdentifier:@"selectCell"];
        }
        
        UILabel *lblCorpName = (UILabel *)[cell viewWithTag:3];
        
        lblCorpName.text = corps[@"corpsName"];
        
        UserScore *us;
        // set the checkmarks for world class
        if (indexPath.section == 0) {
            
            us = [self.WScores objectAtIndex:indexPath.row];
            
            switch (self.scorePhase) {
                case phaseScore:
                    //nothing
                    break;
                case phaseLoudesthornline:
                    if (loudHornlineW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseFavorite:
                    if (favCorpsW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBesthornline:
                    if (favHornlineW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestguard:
                    if (favGuardW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestdrums:
                    if (favDrumsW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseSummary:
                    //nothing
                    break;
                default:
                    break;
            }
        }
        
        //check the checkmarks for open class
        if (indexPath.section == 1) {
            us = [self.OScores objectAtIndex:indexPath.row];
            switch (self.scorePhase) {
                case phaseScore:
                    //nothing
                    break;
                case phaseLoudesthornline:
                    if (loudHornlineO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseFavorite:
                    if (favCorpsO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBesthornline:
                    if (favHornlineO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestguard:
                    if (favGuardO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestdrums:
                    if (favDrumsO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        //check the checkmarks for all age class
        if (indexPath.section == 2) {
            us = [self.AScores objectAtIndex:indexPath.row];
            switch (self.scorePhase) {
                case phaseScore:
                    //nothing
                    break;
                case phaseLoudesthornline:
                    if (loudHornlineA == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseFavorite:
                    if (favCorpsA == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBesthornline:
                    if (favHornlineA == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestguard:
                    if (favGuardA == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestdrums:
                    if (favDrumsA == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                    
                default:
                    break;
            }
            
        }

    }

    
    PFImageView *imgLogo = (PFImageView *)[cell viewWithTag:2];
    if (imgLogo) {
        PFFile *imageFile = corps[@"logo_light"];
        if (!imageFile) {
            imageFile = corps[@"logo"];
        }
        if (imageFile) {
            [imgLogo setFile:imageFile];
            [imgLogo loadInBackground];
        }
    }

    return cell;
}

-(UITableViewCell *)cellForStartReview:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
 
    
    CBReviewCell *cell = [self.viewStartReview.tableReview dequeueReusableCellWithIdentifier:@"reviewCell"];
    if (!cell) {
        [self.viewStartReview.tableReview registerNib:[UINib nibWithNibName:@"CBReviewCell" bundle:nil] forCellReuseIdentifier:@"reviewCell"];
        cell = [self.viewStartReview.tableReview dequeueReusableCellWithIdentifier:@"reviewCell"];
    }
    
    UIImageView *imgIcon = (UIImageView *)[cell viewWithTag:1];
    UILabel *lblMenuText = (UILabel *)[cell viewWithTag:2];
    UILabel *lblSubText = (UILabel *)[cell viewWithTag:3];
    
    switch (indexPath.row) {
        case 0:
            lblMenuText.text = @"Give Scores";
            
            int numScores = 0;
            for (UserScore *score in self.WScores) {
                if (score.score > 0) numScores++;
            }
            
            for (UserScore *score in self.OScores) {
                if (score.score > 0) numScores++;
            }
            
            for (UserScore *score in self.AScores) {
                if (score.score > 0) numScores++;
            }
            
            if (numScores > 0) {
                if (numScores > 1) {
                    lblSubText.text = [NSString stringWithFormat:@"%i scores", numScores];
                } else {
                    lblSubText.text = @"1 score";
                }
                
            } else lblSubText.text = @"None";
            imgIcon.image = [UIImage imageNamed:@"review_score"];
            break;
            
        case 1:
            lblMenuText.text = @"Best Brass";
            
            lblSubText.text = @"None";
            if (favHornlineA) lblSubText.text = favHornlineA[@"corpsName"];
            if (favHornlineO) lblSubText.text = favHornlineO[@"corpsName"];
            if (favHornlineW) lblSubText.text = favHornlineW[@"corpsName"];
            
            imgIcon.image = [UIImage imageNamed:@"review_brass"];
            break;
            
        case 2:
            lblMenuText.text = @"Best Percussion";

            lblSubText.text = @"None";
            if (favDrumsA) lblSubText.text = favDrumsA[@"corpsName"];
            if (favDrumsO) lblSubText.text = favDrumsO[@"corpsName"];
            if (favDrumsW) lblSubText.text = favDrumsW[@"corpsName"];
            
            imgIcon.image = [UIImage imageNamed:@"review_percussion"];
            break;
            
        case 3:
            lblMenuText.text = @"Best Color Guard";
            
            lblSubText.text = @"None";
            if (favGuardA) lblSubText.text = favGuardA[@"corpsName"];
            if (favGuardO) lblSubText.text = favGuardO[@"corpsName"];
            if (favGuardW) lblSubText.text = favGuardW[@"corpsName"];
            
            imgIcon.image = [UIImage imageNamed:@"review_colorguard"];
            break;
            
        case 4:
            lblMenuText.text = @"Loudest Brass";
            
            lblSubText.text = @"None";
            if (loudHornlineA) lblSubText.text = loudHornlineA[@"corpsName"];
            if (loudHornlineO) lblSubText.text = loudHornlineO[@"corpsName"];
            if (loudHornlineW) lblSubText.text = loudHornlineW[@"corpsName"];
            
            imgIcon.image = [UIImage imageNamed:@"review_loudest"];
            break;
            
        case 5:
            lblMenuText.text = @"Favorite Show";
           
            lblSubText.text = @"None";
            if (favCorpsA) lblSubText.text = favCorpsA[@"corpsName"];
            if (favCorpsO) lblSubText.text = favCorpsO[@"corpsName"];
            if (favCorpsW) lblSubText.text = favCorpsW[@"corpsName"];
            
            imgIcon.image = [UIImage imageNamed:@"review_favorite"];
            break;
            
        case 6:
            lblMenuText.text = @"General Feedback";
            if ([feedbackString length]) lblSubText.text = @"Thank You";
            else lblSubText.text = @"None";
            imgIcon.image = [UIImage imageNamed:@"review_feedback"];
            break;
        default:
            break;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.viewStartReview.tableReview) {
        switch (indexPath.row) {
            case 0: //scores
                self.scorePhase = phaseScore;
                [self pickFavorite];
                break;
            case 1: //brass
                self.scorePhase = phaseBesthornline;
                [self pickFavorite];
                break;
            case 2: //percussion
                self.scorePhase = phaseBestdrums;
                [self pickFavorite];
                break;
            case 3: //color guard
                self.scorePhase = phaseBestguard;
                [self pickFavorite];
                break;
            case 4: //loudest
                self.scorePhase = phaseLoudesthornline;
                [self pickFavorite];
                break;
            case 5: //favorite
                self.scorePhase = phaseFavorite;
                [self pickFavorite];
                break;
            case 6: //feedback
                self.scorePhase = phaseFeedback;
                [self showFeedback];
                break;
                
            default:
                break;
        }
        
        
        
    } else if (tableView == self.viewFavorite.tableCorps) {
        UITableViewCell *cell;
        UITextField *text;
        switch (self.scorePhase) {
            case phaseScore:
                cell = [self.viewFavorite.tableCorps cellForRowAtIndexPath:indexPath];
                text = (UITextField *)[cell viewWithTag:4];
                [text becomeFirstResponder];
                break;
            case phaseBestdrums:
                if (indexPath.section == 0) {
                    UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                    if (favDrumsW == us.corps) {
                        favDrumsW = nil;
                    } else {
                        favDrumsW = us.corps;
                    }
                }
                
                if (indexPath.section == 1) {
                    UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                    if (favDrumsO == us.corps) {
                        favDrumsO = nil;
                    } else {
                        favDrumsO = us.corps;
                    }
                }
                
                if (indexPath.section == 2) {
                    UserScore *us = [self.AScores objectAtIndex:indexPath.row];
                    if (favDrumsA == us.corps) {
                        favDrumsA = nil;
                    } else {
                        favDrumsA = us.corps;
                    }
                }
                
                break;
            case phaseBestguard:
                if (indexPath.section == 0) {
                    UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                    if (favGuardW == us.corps) {
                        favGuardW = nil;
                    } else {
                        favGuardW = us.corps;
                    }
                }
                
                if (indexPath.section == 1) {
                    UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                    if (favGuardO == us.corps) {
                        favGuardO = nil;
                    } else {
                        favGuardO = us.corps;
                    }
                }
                
                if (indexPath.section == 2) {
                    UserScore *us = [self.AScores objectAtIndex:indexPath.row];
                    if (favGuardA == us.corps) {
                        favGuardA = nil;
                    } else {
                        favGuardA = us.corps;
                    }
                }
                break;
            case phaseBesthornline:
                if (indexPath.section == 0) {
                    UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                    if (favHornlineW == us.corps) {
                        favHornlineW = nil;
                    } else {
                        favHornlineW = us.corps;
                    }
                }
                
                if (indexPath.section == 1) {
                    UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                    if (favHornlineO == us.corps) {
                        favHornlineO = nil;
                    } else {
                        favHornlineO = us.corps;
                    }
                }
                
                if (indexPath.section == 2) {
                    UserScore *us = [self.AScores objectAtIndex:indexPath.row];
                    if (favHornlineA == us.corps) {
                        favHornlineA = nil;
                    } else {
                        favHornlineA = us.corps;
                    }
                }
                break;
            case phaseFavorite:
                if (indexPath.section == 0) {
                    UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                    if (favCorpsW == us.corps) {
                        favCorpsW = nil;
                    } else {
                        favCorpsW = us.corps;
                    }
                }
                
                if (indexPath.section == 1) {
                    UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                    if (favCorpsO == us.corps) {
                        favCorpsO = nil;
                    } else {
                        favCorpsO = us.corps;
                    }
                }
                
                if (indexPath.section == 2) {
                    UserScore *us = [self.AScores objectAtIndex:indexPath.row];
                    if (favCorpsA == us.corps) {
                        favCorpsA = nil;
                    } else {
                        favCorpsA = us.corps;
                    }
                }
                break;
            case phaseLoudesthornline:
                if (indexPath.section == 0) {
                    UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                    if (loudHornlineW == us.corps) {
                        loudHornlineW = nil;
                    } else {
                        loudHornlineW = us.corps;
                    }
                }
                
                if (indexPath.section == 1) {
                    UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                    if (loudHornlineO == us.corps) {
                        loudHornlineO = nil;
                    } else {
                        loudHornlineO = us.corps;
                    }
                }
                
                if (indexPath.section == 2) {
                    UserScore *us = [self.AScores objectAtIndex:indexPath.row];
                    if (loudHornlineA == us.corps) {
                        loudHornlineA = nil;
                    } else {
                        loudHornlineA = us.corps;
                    }
                }
                break;
                
            default:
                break;
        }
        if (self.scorePhase != phaseScore) [self.viewFavorite.tableCorps reloadData];
    }
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

- (IBAction)btnViewMap_tapped:(id)sender {
    
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"map";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    CBTourMapViewController * map = (CBTourMapViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    map.individualShow = YES;
    map.show = self.show;
    [self showViewController:map sender:self];
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

    [self didUserAttend];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"endShow"]) {
        
        CBEndShowViewController *vc = [segue destinationViewController];
        vc.show = self.show;
        vc.arrayOfWorldClassScores = self.arrayOfWorldClassScores;
        vc.arrayOfOpenClassScores = self.arrayOfOpenClassScores;
        vc.arrayOfAllAgeClassScores = self.arrayOfAllAgeClassScores;
        vc.delegate = self;
    }
}

- (IBAction)btnViewRecap_tapped:(id)sender {
    
    NSString *storyboardName = @"Main";
    NSString *viewControllerID = @"web";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    CBWebViewController *web = (CBWebViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
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

-(void)startReview {
    
    self.OScores = [[NSMutableArray alloc] init];//WithCapacity:[self.arrayOfOpenClassScores count]];
    self.WScores = [[NSMutableArray alloc] init];//WithCapacity:[self.arrayOfWorldClassScores count]];
    self.AScores = [[NSMutableArray alloc] init];
    
    if ([self.arrayOfWorldClassScores count]) {
        for (int i = 0; i < [self.arrayOfWorldClassScores count]; i++ ) {
            
            PFObject *score = [self.arrayOfWorldClassScores objectAtIndex:i];
            UserScore *us = [[UserScore alloc] init];
            us.corps = score[@"corps"];
            us.score = 0;
            [self.WScores addObject:us];
            //[self.WScores addObject:@"0"];
        }
    }
    
    if ([self.arrayOfOpenClassScores count]) {
        for (int i = 0; i < [self.arrayOfOpenClassScores count]; i++ ) {
            
            PFObject *score = [self.arrayOfOpenClassScores objectAtIndex:i];
            UserScore *us = [[UserScore alloc] init];
            us.corps = score[@"corps"];
            us.score = 0;
            [self.OScores addObject:us];
            
            //[self.OScores addObject:@"0"];
        }
    }
    
    if ([self.arrayOfAllAgeClassScores count]) {
        for (int i = 0; i < [self.arrayOfAllAgeClassScores count]; i++ ) {
            
            PFObject *score = [self.arrayOfAllAgeClassScores objectAtIndex:i];
            UserScore *us = [[UserScore alloc] init];
            us.corps = score[@"corps"];
            us.score = 0;
            [self.AScores addObject:us];
            
            //[self.OScores addObject:@"0"];
        }
    }
    
    
    favDrumsW = nil;
    favHornlineW = nil;
    favGuardW = nil;
    favCorpsW = nil;
    loudHornlineW = nil;
    
    favDrumsO = nil;
    favHornlineO = nil;
    favGuardO = nil;
    favCorpsO = nil;
    loudHornlineO = nil;
    
    favDrumsA = nil;
    favHornlineA = nil;
    favGuardA = nil;
    favCorpsA = nil;
    loudHornlineA = nil;
    
    
    currentView = @"Review";
    
    [self showReviewView];
}

-(void)showReviewView {
    
    self.viewStartReview = [[[NSBundle mainBundle] loadNibNamed:@"CBStartReview"
                                                          owner:self
                                                        options:nil]
                            objectAtIndex:0];
    
    for (UIView *view in [self.viewMAIN subviews]) {
        [view removeFromSuperview];
    }
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         self.viewMAIN.frame = CGRectMake(self.viewMAIN.frame.origin.x, self.viewMAIN.frame.origin.y, self.viewStartReview.frame.size.width, self.viewStartReview.frame.size.height);
                         self.viewMAIN.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
                     } completion:^(BOOL finished) {
                         [self.viewStartReview showInParent];
                     }];
    
    [self.viewMAIN addSubview:self.viewStartReview];
    [self.viewStartReview setDelegate:self];
    self.viewStartReview.tableReview.dataSource = self;
    self.viewStartReview.tableReview.delegate = self;
    self.viewStartReview.tableReview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)didUserAttend {
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    self.visualEffectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:self.visualEffectView];
    
    if (!currentView) {
        self.viewMAIN =
        [[[NSBundle mainBundle] loadNibNamed:@"CBReviewAttendance"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        [self.visualEffectView addSubview:self.viewMAIN];
        [self.viewMAIN showInParent:self.view.frame];
        [self.viewMAIN setDelegate:self];
    }
}

#pragma mark
#pragma mark - CBReviewAttendance Delegate
#pragma mark

-(void)userAttended:(BOOL)attended {
    
    if (!attended)  {
        [self.visualEffectView removeFromSuperview];
        [self resetShowReviewViews];
    }
    else {
        [self startReview];
    }
}

-(void)reviewCancelled {
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:8 options:0 animations:^{
        
        self.viewMAIN.transform = CGAffineTransformScale(self.viewMAIN.transform, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:8
                            options:0
                         animations:^{
                             self.viewMAIN.transform = CGAffineTransformScale(self.viewMAIN.transform, 0.1f, 0.1f);
                             self.viewMAIN.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             
                             [self.viewMAIN removeFromSuperview];
                             [self.visualEffectView removeFromSuperview];
                             [self resetShowReviewViews];
                         }];
    }];
    
}

int keyboardHt = 210;
-(void)showFeedback {

    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    self.viewFeedback =
    [[[NSBundle mainBundle] loadNibNamed:@"CBReviewFeedback"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    
    for (UIView *view in [self.viewMAIN subviews]) {
        [view removeFromSuperview];
    }
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         
                         self.viewFeedback.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 60 - keyboardHt);
                         self.viewMAIN.frame = CGRectMake(0, 30, self.viewFeedback.frame.size.width, self.viewFeedback.frame.size.height);
                         self.viewMAIN.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.viewMAIN.center.y);
                         
                     } completion:^(BOOL finished) {
                         [self.viewFeedback showInParent:feedbackString];
                     }];
    
    [self.viewMAIN addSubview:self.viewFeedback];
    [self.viewFeedback setDelegate:self];

}

-(void)pickFavorite {
    
    NSString *header;
    switch (self.scorePhase) {
        case phaseScore: header = @"Give Scores";
            break;
        case phaseBesthornline: header = @"Choose Best Brass";
            break;
        case phaseBestdrums: header = @"Choose Best Percussion";
            break;
        case phaseBestguard: header = @"Choose Best Color Guard";
            break;
        case phaseLoudesthornline: header = @"Choose Loudest Brass";
            break;
        case phaseFavorite: header = @"Choose Favorite Show";
            break;
        case phaseFeedback:
            break;
        case phaseSummary:
            break;
    }
    
    self.viewFavorite =
    [[[NSBundle mainBundle] loadNibNamed:@"CBPickFavorite"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    for (UIView *view in [self.viewMAIN subviews]) {
        [view removeFromSuperview];
    }
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         
                         self.viewFavorite.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 100);
                         self.viewMAIN.frame = CGRectMake(0, 30, self.viewFavorite.frame.size.width, self.viewFavorite.frame.size.height);
                         self.viewMAIN.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.viewMAIN.center.y);
                     } completion:^(BOOL finished) {
                         [self.viewFavorite showInParent:header];
                     }];
    
    [self.viewMAIN addSubview:self.viewFavorite];
    [self.viewFavorite setDelegate:self];
    self.viewFavorite.tableCorps.delegate = self;
    self.viewFavorite.tableCorps.dataSource = self;
    self.viewFavorite.tableCorps.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)resetShowReviewViews {
    
    currentView = nil;
    self.visualEffectView = nil;
    self.viewMAIN = nil;
    self.viewStartReview = nil;
}

-(void)favoritePicked {
    
    [self sortScoresForDisplay];
    [self showReviewView];
}


#pragma mark
#pragma mark - UITextField Delegates
#pragma mark

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

int previouslen;
bool backspaced;
-(void)textFieldDidChange:(UITextField *)theTextField {
    
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
        NSString *regex = @"^[0-9]{0,2}[\\.]{0,1}[0-9]{0,3}$";
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

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    CGPoint location = [textField.superview convertPoint:textField.center toView:self.viewFavorite.tableCorps];
    NSIndexPath *indexPath = [self.viewFavorite.tableCorps indexPathForRowAtPoint:location];
    
    if (textField.text.length == 1) textField.text = @"";
    if (textField.text.length == 2) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @".00"];
    if (textField.text.length == 3) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @"00"];
    if (textField.text.length == 4) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @"0"];
    
    if (indexPath.section == 0) {
        UserScore *score = [self.WScores objectAtIndex:indexPath.row];
        score.score = [textField.text doubleValue];
        //[self.WScores replaceObjectAtIndex:indexPath.row withObject:textField.text];
        //[self.WScores setObject:textField.text forKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]];
    } else if (indexPath.section == 1) {
        UserScore *score = [self.OScores objectAtIndex:indexPath.row];
        score.score = [textField.text doubleValue];
        //[self.OScores replaceObjectAtIndex:indexPath.row withObject:textField.text];
        //[self.OScores setObject:textField.text forKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]];
    } else if (indexPath.section == 2) {
        UserScore *score = [self.AScores objectAtIndex:indexPath.row];
        score.score = [textField.text doubleValue];
        //[self.OScores replaceObjectAtIndex:indexPath.row withObject:textField.text];
        //[self.OScores setObject:textField.text forKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]];
    }
}

-(void)sortScoresForDisplay {
    
    //sort the scores for display in summary
    NSSortDescriptor *sortScores = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortCorpsDescriptor = [NSArray arrayWithObject: sortScores];
    
    if ([self.WScores count]) [self.WScores sortUsingDescriptors:sortCorpsDescriptor];
    if ([self.OScores count]) [self.OScores sortUsingDescriptors:sortCorpsDescriptor];
    if ([self.AScores count]) [self.AScores sortUsingDescriptors:sortCorpsDescriptor];
}

-(void)feedbackGiven:(NSString *)feedback {
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    feedbackString = feedback;
    [self showReviewView];
}

-(void)reviewSent {
    
    self.scorePhase = phaseSummary;
    
    self.viewSummary =
    [[[NSBundle mainBundle] loadNibNamed:@"CBReviewShow"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    
    for (UIView *view in [self.viewMAIN subviews]) {
        [view removeFromSuperview];
    }
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         
                         self.viewSummary.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 100);
                         self.viewMAIN.frame = CGRectMake(0, 30, self.viewSummary.frame.size.width, self.viewSummary.frame.size.height);
                         self.viewMAIN.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.viewMAIN.center.y);
                     } completion:^(BOOL finished) {
                         [self.viewSummary.tableRecap reloadData];
                         [self.viewSummary showInParent];
                     }];
    
    [self.viewMAIN addSubview:self.viewSummary];
    [self.viewSummary setDelegate:self];
    self.viewSummary.tableRecap.delegate = self;
    self.viewSummary.tableRecap.dataSource = self;
    self.viewSummary.tableRecap.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)cancelSubmitReview {
    
    [self showReviewView];
}

-(void)submitReview {
    
    [self prepareAndSubmitScores];
}

-(void)prepareAndSubmitScores {
    
    [self submitFeedback];
    [self submitUserScores];
    [self submitUserFavorites];
    [self voted];
    
    [self thankYou];
    
}

-(void)submitFeedback {
    
    if ([feedbackString length]) {
        PFObject *fb = [PFObject objectWithClassName:@"showFeedback"];
        fb[@"feedback"] = feedbackString;
        fb[@"user"] = [PFUser currentUser];
        fb[@"show"] = self.show;
        [fb saveEventually];
    }
}

-(void)submitUserScores {
    
    for (UserScore *us in self.WScores) {
        
        if (us.score > 0) {
            PFObject *score = [PFObject objectWithClassName:@"scores"];
            score[@"corps"] = us.corps;
            score[@"score"] = us.scoreString;
            score[@"show"] = self.show;
            score[@"corpsName"] = us.corps[@"corpsName"];
            score[@"isOfficial"] = [NSNumber numberWithBool:NO];
            score[@"user"] = [PFUser currentUser];
            score[@"class"] = @"World";
            score[@"showDate"] = self.show[@"showDate"];
            
            [score saveEventually];
        }
    }
    
    for (UserScore *us in self.OScores) {
        
        if (us.score > 0) {
            PFObject *score = [PFObject objectWithClassName:@"scores"];
            score[@"corps"] = us.corps;
            score[@"score"] = us.scoreString;
            score[@"show"] = self.show;
            score[@"corpsName"] = us.corps[@"corpsName"];
            score[@"isOfficial"] = [NSNumber numberWithBool:NO];
            score[@"user"] = [PFUser currentUser];
            score[@"class"] = @"Open";
            score[@"showDate"] = self.show[@"showDate"];
            
            [score saveEventually];
        }
    }
    
    for (UserScore *us in self.AScores) {
        
        if (us.score > 0) {
            PFObject *score = [PFObject objectWithClassName:@"scores"];
            score[@"corps"] = us.corps;
            score[@"score"] = us.scoreString;
            score[@"show"] = self.show;
            score[@"corpsName"] = us.corps[@"corpsName"];
            score[@"isOfficial"] = [NSNumber numberWithBool:NO];
            score[@"user"] = [PFUser currentUser];
            score[@"class"] = @"Open";
            score[@"showDate"] = self.show[@"showDate"];
            
            [score saveEventually];
        }
    }
}

-(void)submitUserFavorites {
    
    
    [self submitFavorite:catdrums forClass:@"World" forCorps:favDrumsW];
    [self submitFavorite:cathornline forClass:@"World" forCorps:favHornlineW];
    [self submitFavorite:catguard forClass:@"World" forCorps:favGuardW];
    [self submitFavorite:catcorps forClass:@"World" forCorps:favCorpsW];
    [self submitFavorite:catloud forClass:@"World" forCorps:loudHornlineW];
    
    [self submitFavorite:catdrums forClass:@"Open" forCorps:favDrumsO];
    [self submitFavorite:cathornline forClass:@"Open" forCorps:favHornlineO];
    [self submitFavorite:catguard forClass:@"Open" forCorps:favGuardO];
    [self submitFavorite:catcorps forClass:@"Open" forCorps:favCorpsO];
    [self submitFavorite:catloud forClass:@"Open" forCorps:loudHornlineO];
    
    [self submitFavorite:catdrums forClass:@"All Age" forCorps:favDrumsA];
    [self submitFavorite:cathornline forClass:@"All Age" forCorps:favHornlineA];
    [self submitFavorite:catguard forClass:@"All Age" forCorps:favGuardA];
    [self submitFavorite:catcorps forClass:@"All Age" forCorps:favCorpsA];
    [self submitFavorite:catloud forClass:@"All Age" forCorps:loudHornlineA];
    
}

-(void)voted {
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userObjectId"] = [PFUser currentUser].objectId;
    [PFCloud callFunctionInBackground:@"incrementReviewsByUser" withParameters:params];
     self.btnReviewShow.enabled = NO;
}

-(void)thankYou {
    
    self.viewReviewSubmitted =
    [[[NSBundle mainBundle] loadNibNamed:@"CBReviewSubmitted"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    
    for (UIView *view in [self.viewMAIN subviews]) {
        [view removeFromSuperview];
    }
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         self.viewMAIN.frame = CGRectMake(self.viewMAIN.frame.origin.x, self.viewMAIN.frame.origin.y, self.viewReviewSubmitted.frame.size.width, self.viewReviewSubmitted.frame.size.height);
                         self.viewMAIN.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
                     } completion:^(BOOL finished) {
                         [self.viewReviewSubmitted showInParent];
                     }];
    [self.viewMAIN addSubview:self.viewReviewSubmitted];
    [self.viewReviewSubmitted setDelegate:self];
}

-(void)submitFavorite:(category)cat forClass:(NSString *)corpClass forCorps:(PFObject *)corp {
    
    if (corp) {
        NSMutableArray *classArray;
        if ([corpClass isEqualToString:@"World"]) {
            classArray = self.arrayOfWorldClassScores;
        } else if ([corpClass isEqualToString:@"Open"]) {
            classArray = self.arrayOfOpenClassScores;
        } else if ([corpClass isEqualToString:@"All Age"]) {
            classArray = self.arrayOfAllAgeClassScores;
        }
        
        PFObject *favorite = [PFObject objectWithClassName:@"favorites"];
        favorite[@"category"] = [self getCategory:cat];
        favorite[@"show"] = self.show;
        favorite[@"showName"] = self.show[@"showName"];
        favorite[@"user"] = [PFUser currentUser];
        //PFObject *score = [classArray objectAtIndex:intClass];
        //PFObject *corps = score[@"corps"];
        favorite[@"corpsName"] = corp[@"corpsName"];
        favorite[@"corps"] = corp;
        favorite[@"class"] = corpClass;
        [favorite saveInBackground];
    }
}

-(NSString *)getCategory:(category)cat {
    
    switch (cat) {
        case catcorps: return @"Favorite Corps";
        case catdrums: return @"Favorite Drums";
        case catguard: return @"Favorite Color Guard";
        case cathornline: return @"Favorite Brass";
        case catloud: return @"Loudest Brass";
    }
}

-(void)thankYouDone {
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:8 options:0 animations:^{
        
        self.viewMAIN.transform = CGAffineTransformScale(self.viewMAIN.transform, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:8
                            options:0
                         animations:^{
                             self.viewMAIN.transform = CGAffineTransformScale(self.viewMAIN.transform, 0.1f, 0.1f);
                             self.viewMAIN.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             
                             [self.viewMAIN removeFromSuperview];
                             [self.visualEffectView removeFromSuperview];
                             
                         }];
    }];
}

@end
