//
//  CBNewMenuViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 7/2/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNewMenuViewController.h"
#import <Parse/Parse.h>
#import "CSSingle.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+Utilities.h"
#import "CSShowDetailsViewController.h"
#import "NSMutableArray+Shuffling.h"
#import "CBNewsSingleton.h"
#import "CBNewsItem.h"
#import "CBNewsView.h"
#import "ClipView.h"
#import "MWFeedItem.h"

CSSingle *data;
CBNewsSingleton *news;

NSTimer *timerCheckForShows, *timerCheckForCorps, *timerHeadshot, *timerCheckForNews;
NSString *lastShowString;
NSString *nextShowString;

UIImageView *pageOneImage, *pageTwoImage, *pageThreeImage;

@interface CBNewMenuViewController ()


@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;

@property (nonatomic, strong) IBOutlet UIView *viewAppTitle;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollMain;
@property (nonatomic, strong) IBOutlet UIView *contentMainView;

@property (nonatomic, strong) NSMutableArray *arrayOfLastShows;
@property (nonatomic, strong) NSMutableArray *arrayOfNextShows;
@property (nonatomic, strong) NSMutableArray *datesArray; //of NSString
@property (nonatomic, strong) NSMutableDictionary *dateIndex;

// Recent Shows
@property (nonatomic, strong) IBOutlet UIScrollView *scrollViewShows;
@property (nonatomic, strong) IBOutlet UITableView *tableLastShows;
@property (nonatomic, strong) IBOutlet UITableView *tableNextShows;
@property (nonatomic, strong) IBOutlet UIView *contentViewShows;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *showsActivity;
@property (nonatomic, strong) IBOutlet UILabel *lblShowsHeader;
@property (nonatomic, strong) IBOutlet UIButton *btnSeeAll;

// Current Top 12
@property (nonatomic, strong) IBOutlet UIScrollView *scrollTopTwelve;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityTopTwelve;
@property (nonatomic, strong) IBOutlet UITableView *tableTopFour;
@property (nonatomic, strong) IBOutlet UITableView *tableTopEight;
@property (nonatomic, strong) IBOutlet UITableView *tableTopTwelve;
@property (nonatomic, strong) IBOutlet UILabel *lblTopTwelveHeader;
@property (nonatomic, strong) IBOutlet UIButton *btnSeeAllRankings;
@property (nonatomic, strong) IBOutlet UIView *contentViewTopTwelve;

@property (nonatomic, strong) IBOutlet UIView *viewFeedback;


//headshots
@property (nonatomic, strong) IBOutlet UIScrollView *scrollHeadshots;


@property (nonatomic, strong) IBOutlet UIPageControl *pageShows;
@property (nonatomic, strong) IBOutlet UIPageControl *pageTopTwelve;
@property (nonatomic, strong) UIPageControl *pageNews;

@property (nonatomic, strong) IBOutlet UIControl *viewAboutTheCorps;

@property (nonatomic, strong) IBOutlet UIImageView *imgUpsideDownCavalier;

// News
@property (weak, nonatomic) IBOutlet UIButton *btnSeeAllNews;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollNews;
@property (weak, nonatomic) IBOutlet ClipView *clipviewNews;
@property (weak, nonatomic) IBOutlet ClipView *viewNews;

// Extras
@property (weak, nonatomic) IBOutlet UIView *viewExtras;



-(IBAction)seeAllShows_clicked:(id)sender;
-(IBAction)seeAllRankings_clicked:(id)sender;
-(IBAction)feedback_clicked:(id)sender;
-(IBAction)finalsContest_clicked:(id)sender;
-(IBAction)aboutTheCorps_clicked:(id)sender;
- (IBAction)seeAllNews_clicked:(id)sender;

@end

@implementation CBNewMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initVariables];
    [self initUI];
    
    [self startTimerForShows];
    [self startTimerForCorps];
    [self startTimerForHeadshots];
    [self startTimerForNews];
    
}

-(void)initVariables {
    
    data = [CSSingle data];
    news = [CBNewsSingleton news];
    
    [self initHeadshots];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(admin:)];
    tap.numberOfTapsRequired = 5;
    [self.lblShowsHeader addGestureRecognizer:tap];
    self.lblShowsHeader.userInteractionEnabled = YES;
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                      style:UIBarButtonItemStylePlain
                                     target:nil
                                     action:nil];
}

bool trying;
-(void)admin:(UILongPressGestureRecognizer *)gesture {
    
    if (!trying) {
        
        trying = YES;
        
        if (data.adminMode) {
            
            data.adminMode = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Admin mode disabled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Admin Mode" message:@"Enter password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex > 0) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        if ([txt.text isEqualToString:@"Ju$tin!1"]) {
            data.adminMode = YES;
            NSLog(@"admin mode enabled");
        } else {
            data.adminMode = NO;
            trying = NO;
            [self admin:nil];
        }
    }
   

    trying = NO;
}

-(void)initHeadshots {
    [self.arrayOfHeadshots addObject:[UIImage imageNamed:@"Santa Clara Vanguard1"]];
    [self.arrayOfHeadshots addObject:[UIImage imageNamed:@"Santa Clara Vanguard2"]];
    [self.arrayOfHeadshots addObject:[UIImage imageNamed:@"Blue Devils1"]];
    [self.arrayOfHeadshots addObject:[UIImage imageNamed:@"The Cadets1"]];
    [self.arrayOfHeadshots addObject:[UIImage imageNamed:@"The Cadets2"]];
       [self.arrayOfHeadshots addObject:[UIImage imageNamed:@"Phantom Regiment1"]];

    [self.arrayOfHeadshots shuffle];
}

-(void)initUI {


    
    //arrows
    UITableViewCell *showArrow = [[UITableViewCell alloc] init];
    [self.btnSeeAll addSubview:showArrow];
    showArrow.frame = self.btnSeeAll.bounds;
    showArrow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    showArrow.userInteractionEnabled = NO;
    showArrow.tintColor = [UIColor redColor];
    
    UITableViewCell *rankArrow = [[UITableViewCell alloc] init];
    [self.btnSeeAllRankings addSubview:rankArrow];
    rankArrow.frame = self.btnSeeAllRankings.bounds;
    rankArrow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    rankArrow.userInteractionEnabled = NO;
    rankArrow.tintColor = [UIColor redColor];
    
    UITableViewCell *newsArrow = [[UITableViewCell alloc] init];
    [self.btnSeeAllNews addSubview:newsArrow];
    newsArrow.frame = self.btnSeeAllNews.bounds;
    newsArrow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    newsArrow.userInteractionEnabled = NO;
    newsArrow.tintColor = [UIColor redColor];
    
    
    //
    self.scrollMain.frame = CGRectMake(self.scrollMain.frame.origin.x, self.scrollMain.frame.origin.y, self.scrollMain.frame.size.width, 568);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Main Content
    self.view.backgroundColor = self.viewAppTitle.backgroundColor;
    self.contentMainView.backgroundColor = self.viewAppTitle.backgroundColor;
    self.scrollMain.contentSize = CGSizeMake(320, self.contentMainView.frame.size.height * 1.25 );
    self.scrollMain.canCancelContentTouches = YES;
    self.scrollMain.delaysContentTouches = YES;
    self.scrollMain.userInteractionEnabled = YES;
    self.scrollMain.exclusiveTouch = YES;
    
    // Current Top 12
    
    [self.activityTopTwelve startAnimating];
    
    self.pageTopTwelve.hidden = YES;
    
    self.lblTopTwelveHeader.hidden = YES;
    self.btnSeeAllRankings.hidden = YES;
    
    self.scrollTopTwelve.hidden = YES;
    self.scrollTopTwelve.canCancelContentTouches = YES;
    self.scrollTopTwelve.delaysContentTouches = YES;
    self.scrollTopTwelve.userInteractionEnabled = YES;
    self.scrollTopTwelve.exclusiveTouch = YES;
    self.scrollTopTwelve.contentSize = CGSizeMake(self.scrollTopTwelve.frame.size.width * 3, self.scrollTopTwelve.frame.size.height);
    
    
    self.contentViewTopTwelve.userInteractionEnabled = YES;
    self.contentViewTopTwelve.exclusiveTouch = YES;
    
    // Recent Shows
    
    [self.showsActivity startAnimating];
    
    self.pageShows.hidden = YES;
    
    self.lblShowsHeader.hidden = YES;
    self.btnSeeAll.hidden = YES;
    
    self.scrollViewShows.hidden = YES;
    self.scrollViewShows.canCancelContentTouches = YES;
    self.scrollViewShows.delaysContentTouches = YES;
    self.scrollViewShows.userInteractionEnabled = YES;
    self.scrollViewShows.exclusiveTouch = YES;
    [self.scrollViewShows setContentSize:self.contentViewShows.frame.size];
    
    self.contentViewShows.userInteractionEnabled = YES;
    self.contentViewShows.exclusiveTouch = YES;
    
    
    //headshots
    pageOneImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 135)];
    pageTwoImage = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, 135)];
    pageThreeImage = [[UIImageView alloc] initWithFrame:CGRectMake(640, 0, 320, 135)];


    [self loadPageWithId:(int)[self.arrayOfHeadshots count] - 1 onPage:0];
	[self loadPageWithId:0 onPage:1];
	[self loadPageWithId:1 onPage:2];
    
    [self.scrollHeadshots addSubview:pageOneImage];
	[self.scrollHeadshots addSubview:pageTwoImage];
	[self.scrollHeadshots addSubview:pageThreeImage];
    
    self.scrollHeadshots.contentSize = CGSizeMake(960, 135);
	[self.scrollHeadshots scrollRectToVisible:CGRectMake(320,0,320,135) animated:NO];
    
    self.viewAboutTheCorps.layer.cornerRadius = 8;
    self.viewAboutTheCorps.layer.borderColor = [UIColor blackColor].CGColor;
    self.viewAboutTheCorps.layer.borderWidth = 1;
    
    self.viewFeedback.layer.cornerRadius = 8;
    self.viewFeedback.layer.borderColor = [UIColor blackColor].CGColor;
    self.viewFeedback.layer.borderWidth = 1;
    
}

int numOfNewsItems = 6;
int newsScrollWidth = 0;
int newsContentWidth = 0;

-(void)initNewsFeed {
    
    self.clipviewNews.backgroundColor = [UIColor clearColor];
    
    if ([news.itemsToDisplay count]) {
        self.pageNews = [[UIPageControl alloc] init];
        self.pageNews.numberOfPages = [news.itemsToDisplay count];
        self.pageNews.currentPage = 1;
        self.viewNews.hidden = NO;
        if (numOfNewsItems > [news.itemsToDisplay count]) {
            numOfNewsItems = (int)[news.itemsToDisplay count];
        }
        for (int i = 0; i < numOfNewsItems; i++) {
            //CBNewsItem *item = [news.itemsToDisplay objectAtIndex:i];
            MWFeedItem *item = [news.itemsToDisplay objectAtIndex:i];
            CBNewsView *nv = [[CBNewsView alloc] initWithDate:item.date title:item.title link:item.link];
            nv.frame = CGRectMake((0 + (nv.frame.size.width * i) + (8 * i)), 7, nv.frame.size.width, nv.frame.size.height);
            nv.colorNumber = [news.arrayOfColors objectAtIndex:i];
            [nv createBackground];
            [self.scrollNews addSubview:nv];
            newsContentWidth += nv.frame.size.width + 8;
            newsScrollWidth = nv.frame.size.width;
        }
        self.scrollNews.contentSize = CGSizeMake(newsContentWidth, self.scrollNews.frame.size.height);
    } else {
        self.scrollNews.hidden = YES;
        UILabel *error = [[UILabel alloc] init];
        error.frame = CGRectMake(0, 0, self.clipviewNews.frame.size.width, self.clipviewNews.frame.size.height);
        error.text = @"Could Not Load News Feed";
        error.numberOfLines = 0;
        error.textColor = [UIColor lightGrayColor];
        error.font = [UIFont systemFontOfSize:14];
        error.textAlignment = NSTextAlignmentCenter;
        [self.clipviewNews addSubview: error];
        self.btnSeeAllNews.enabled = NO;
    }
}

- (void)loadPageWithId:(int)index onPage:(int)page {
	// load data for page
	switch (page) {
		case 0:
			pageOneImage.image = [self.arrayOfHeadshots objectAtIndex:index];
			break;
		case 1:
			pageTwoImage.image = [self.arrayOfHeadshots objectAtIndex:index];
			break;
		case 2:
			pageThreeImage.image = [self.arrayOfHeadshots objectAtIndex:index];
			break;
	}
}

-(void)startTimerForHeadshots {
    
    timerHeadshot = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(scrollToNextHeadshot)
                                                   userInfo:nil
                                                    repeats:YES];
}

-(void)startTimerForCorps {
   
    timerCheckForCorps = [NSTimer scheduledTimerWithTimeInterval:.5
                                                          target:self
                                                        selector:@selector(checkCorps)
                                                        userInfo:nil
                                                         repeats:YES];
}

-(void)startTimerForNews {
    
    timerCheckForNews = [NSTimer scheduledTimerWithTimeInterval:.5
                                                          target:self
                                                        selector:@selector(checkNews)
                                                        userInfo:nil
                                                         repeats:YES];
}

-(void)startTimerForShows {
    
    timerCheckForShows = [NSTimer scheduledTimerWithTimeInterval:.5
                                             target:self
                                           selector:@selector(checkShows)
                                           userInfo:nil
                                            repeats:YES];
}

int counter = 0;
-(void)scrollToNextHeadshot {
    counter ++;
    if (counter == 5) {
        counter = 0;
        
       [self.scrollHeadshots scrollRectToVisible:CGRectMake(640,0,320,416) animated:YES];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // We are moving forward. Load the current doc data on the first page.
    [self loadPageWithId:self.currIndex onPage:0];
    // Add one to the currentIndex or reset to 0 if we have reached the end.
    self.currIndex = (self.currIndex >= [self.arrayOfHeadshots count]-1) ? 0 : self.currIndex + 1;
    [self loadPageWithId:self.currIndex onPage:1];
    // Load content on the last page. This is either from the next item in the array
    // or the first if we have reached the end.
    self.nextIndex = (self.currIndex >= [self.arrayOfHeadshots count]-1) ? 0 : self.currIndex + 1;
    [self loadPageWithId:self.nextIndex onPage:2];
    
    
    // Reset offset back to middle page
    [self.scrollHeadshots scrollRectToVisible:CGRectMake(320,0,320,416) animated:NO];
    
    
}

-(void)openShow:(UIButton *)sender {
    
    UIView *parentCell = sender.superview;
    
    while (![parentCell isKindOfClass:[UITableViewCell class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentCell = parentCell.superview;
    }
    
    UIView *parentView = parentCell.superview;
    
    while (![parentView isKindOfClass:[UITableView class]]) {   // iOS 7 onwards the table cell hierachy has changed.
        parentView = parentView.superview;
    }
    
    
    UITableView *tableView = (UITableView *)parentView;
    NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)parentCell];
    
    
    if (tableView == self.tableLastShows) {
        showToOpen = [self.arrayOfLastShows objectAtIndex:indexPath.row];
    } else if (tableView == self.tableNextShows) {
        showToOpen = [self.arrayOfNextShows objectAtIndex:indexPath.row];
    }
    
    if (showToOpen) [self performSegueWithIdentifier:@"openShow" sender:self];
    
}

-(void)checkCorps {
    
    if (data.updatedCorps) {
        [timerCheckForCorps invalidate];
        [self sortScores];
    }
}

-(void)sortScores {
    
    NSSortDescriptor *sortOfficialScores = [[NSSortDescriptor alloc] initWithKey:@"lastScore" ascending:NO];
    NSArray *sortOfficialScoresDescriptor = [NSArray arrayWithObject: sortOfficialScores];
        
    if ([data.arrayOfWorldClass count]) [data.arrayOfWorldClass sortUsingDescriptors:sortOfficialScoresDescriptor];
    
    
    [self.activityTopTwelve stopAnimating];
    self.pageTopTwelve.hidden = NO;
    self.activityTopTwelve.hidden = YES;
    self.scrollTopTwelve.hidden = NO;
    self.lblTopTwelveHeader.hidden = NO;
    self.btnSeeAllRankings.hidden = NO;
    [self.tableTopFour reloadData];
    [self.tableTopEight reloadData];
    [self.tableTopTwelve reloadData];
}

-(void)checkShows {
    
    if (data.updatedShows) {

        [timerCheckForShows invalidate];
        
        if ([data.arrayOfAllShows count]) {
            
            [self prepareShowsForTable];
            
            [self.showsActivity stopAnimating];
            self.pageShows.hidden = NO;
            self.showsActivity.hidden = YES;
            self.scrollViewShows.hidden = NO;
            self.lblShowsHeader.hidden = NO;
            self.btnSeeAll.hidden = NO;
            
        }
    }
}

-(void)checkNews {
    
    if (news.isNewsLoaded) {
        
        [timerCheckForNews invalidate];
        
        [self initNewsFeed];
    }
}

NSDate *nearestDate;

-(void)prepareShowsForTable {

    [self getPreviousAndNextShows];
    
    if ([self.arrayOfNextShows count]) {
        [self.tableNextShows reloadData];
    } else {
        self.tableNextShows.hidden = YES;
    }
    
    if ([self.arrayOfLastShows count]) {
        [self.tableLastShows reloadData];
    } else {
        self.tableLastShows.hidden = YES;
    }
    
    if (![self.arrayOfLastShows count] || ![self.arrayOfNextShows count]) {
        self.scrollViewShows.contentSize = CGSizeMake(self.scrollViewShows.contentSize.width / 2, self.scrollViewShows.contentSize.height);
        self.pageShows.numberOfPages = 0;
        self.scrollViewShows.scrollEnabled = NO;
    }
}

-(void)getPreviousAndNextShows {
    
    for (PFObject *show in data.arrayOfAllShows) {
        
        // adds all shows for yesterday
        if ([show[@"showDate"] isYesterday]) {
            [self.arrayOfLastShows addObject:show];
        }
        
        // adds all shows for today
        if ([show[@"showDate"] isToday]) {
            [self.arrayOfNextShows addObject:show];
        }
        
    }
    
    // if no shows yesterday, get the latest show
    if (![self.arrayOfLastShows count]) {
        
        int numberOfDays = 1;
        bool foundLastDate = NO;
        while (!foundLastDate) {
            NSDate *days = [NSDate dateWithDaysBeforeNow:numberOfDays];
            for (PFObject *show in data.arrayOfAllShows) {
                if ([show[@"showDate"] isEqualToDateIgnoringTime:days]) {
                    foundLastDate = YES;
                    [self.arrayOfLastShows addObject:show];
                }
            }
            numberOfDays++;
        }
    }
    
    if ([self.arrayOfLastShows count]) {
        //set the date string for the last shows table
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE M/dd"];
        PFObject *show = [self.arrayOfLastShows objectAtIndex:0];
        lastShowString = [formatter stringFromDate:show[@"showDate"]];
    }
    
    
    //make sure we have shows for today, if not... go up one more day
    
    if (![self.arrayOfNextShows count]) {
        NSDate *oneDay = [NSDate dateWithDaysFromNow:1];
        for (PFObject *show in data.arrayOfAllShows) {
            if ([show[@"showDate"] isEqualToDateIgnoringTime:oneDay]) {
                [self.arrayOfNextShows addObject:show];
            }
        }
    }
    
    if ([self.arrayOfNextShows count]) {
        //set the date string for the next shows table
        //set the date string for the last shows table
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"EEEE M/dd"];
        PFObject *show2 = [self.arrayOfNextShows objectAtIndex:0];
        nextShowString = [formatter2 stringFromDate:show2[@"showDate"]];
    }
    
    self.lblShowsHeader.text = lastShowString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableLastShows) {
        if ([self.arrayOfLastShows count]) {
            if ([self.arrayOfLastShows count] > 4) return 4;
            else return [self.arrayOfLastShows count];
        } else return 0;
    } else if (tableView == self.tableNextShows) {
        if ([self.arrayOfNextShows count]) {
            if ([self.arrayOfNextShows count] > 4) return 4;
            else return [self.arrayOfNextShows count];
        } else return 0;
    }
    
    if (tableView == self.tableTopFour) return 4;
    if (tableView == self.tableTopEight) return 4;
    if (tableView == self.tableTopTwelve) return 4;
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    PFObject *show;
    
    UILabel *lblShowName;
    UILabel *lblShowLocation;
    UIButton *btnScores;
    
    if (tableView == self.tableLastShows) {
    
        cell = [self.tableLastShows dequeueReusableCellWithIdentifier:@"show"];
       
        lblShowName = (UILabel *)[cell viewWithTag:1];
        lblShowLocation = (UILabel *)[cell viewWithTag:2];
        btnScores = (UIButton *)[cell viewWithTag:3];
        
        if ([self.arrayOfLastShows count]) {
            show = [self.arrayOfLastShows objectAtIndex:indexPath.row];
            
            lblShowName.text = show[@"showName"];
            lblShowLocation.text = show[@"showLocation"];
            
            BOOL isOver = [show[@"isShowOver"] boolValue];
            if (isOver) {
                btnScores.hidden = NO;
                
                btnScores.layer.borderWidth = 1.0f;
                
                btnScores.layer.borderColor = [UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0].CGColor;
                
                btnScores.layer.cornerRadius = 4.0f;
                btnScores.layer.masksToBounds = YES;
                btnScores.titleLabel.text = @" Scores ";
            } else btnScores.hidden = YES;
        }
        
        [btnScores addTarget:self action:@selector(openShow:) forControlEvents:UIControlEventTouchUpInside];
       
    } else if (tableView == self.tableNextShows) {
        
        cell = [self.tableNextShows dequeueReusableCellWithIdentifier:@"show"];
        
        lblShowName = (UILabel *)[cell viewWithTag:1];
        lblShowLocation = (UILabel *)[cell viewWithTag:2];
        btnScores = (UIButton *)[cell viewWithTag:3];
        
        if ([self.arrayOfLastShows count]) {
            show = [self.arrayOfNextShows objectAtIndex:indexPath.row];
            
            lblShowName.text = show[@"showName"];
            lblShowLocation.text = show[@"showLocation"];
            
            BOOL isOver = [show[@"isShowOver"] boolValue];
            if (isOver) {
                btnScores.hidden = NO;
                
                btnScores.layer.borderWidth = 1.0f;
                
                btnScores.layer.borderColor = [UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0].CGColor;
                
                btnScores.layer.cornerRadius = 4.0f;
                btnScores.layer.masksToBounds = YES;
                btnScores.titleLabel.text = @" Scores ";
            } else btnScores.hidden = YES;
        }
        
        [btnScores addTarget:self action:@selector(openShow:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    PFObject *corps;
    UILabel *lblCorpsName;
    UILabel *lblPosition;
    UILabel *lblScore;
    UILabel *lblScoreDate;
    UIImageView *imgView;
    
    if ((tableView == self.tableTopFour) || (tableView == self.tableTopEight) || (tableView == self.tableTopTwelve)) {
        
        cell = [self.tableTopFour dequeueReusableCellWithIdentifier:@"rank"];
        
        lblPosition = (UILabel *)[cell viewWithTag:4];
        lblCorpsName = (UILabel *)[cell viewWithTag:1];
        lblScore = (UILabel *)[cell viewWithTag:2];
        lblScoreDate = (UILabel *)[cell viewWithTag:3];
        imgView = (UIImageView *)[cell viewWithTag:5];
        
        if ([data.arrayOfWorldClass count]) {
            
            int increment = 0;
            if (tableView == self.tableTopFour) increment = 0;
            if (tableView == self.tableTopEight) increment = 4;
            if (tableView == self.tableTopTwelve) increment = 8;
            
            corps = [data.arrayOfWorldClass objectAtIndex:indexPath.row + increment];
            
            if (corps) {
                lblPosition.text = [NSString stringWithFormat:@"%li", (long)indexPath.row + 1 + increment];
                lblCorpsName.text = corps[@"corpsName"];
                lblScore.text = corps[@"lastScore"];
                UIImage *img = [UIImage imageNamed:corps[@"corpsName"]];
                imgView.image = img;
                
                if ([corps[@"lastScoreDate"] isToday]) {
                    lblScoreDate.text = @"Today";
                } else if ([corps[@"lastScoreDate"] isYesterday]) {
                    lblScoreDate.text = @"Yesterday";
                } else {
                    NSInteger days = [corps[@"lastScoreDate"] daysBeforeDate:[NSDate date]];
                    if (days > 1)  {
                        lblScoreDate.text = [NSString stringWithFormat:@"%li days ago", (long)days];
                    } else if (days <= 0) {
                        lblScoreDate.text = @"";
                    } else {
                        lblScoreDate.text = [NSString stringWithFormat:@"%li day ago", (long)days];
                    }
                }
            }
        }
    }
    
    return cell;
}


PFObject *showToOpen;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.tableLastShows) {
        showToOpen = [self.arrayOfLastShows objectAtIndex:indexPath.row];
        if (showToOpen) [self performSegueWithIdentifier:@"openShow" sender:self];
        
    } else if (tableView == self.tableNextShows) {
        showToOpen = [self.arrayOfNextShows objectAtIndex:indexPath.row];
        if (showToOpen) [self performSegueWithIdentifier:@"openShow" sender:self];
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openShow"]) {
        CSShowDetailsViewController *vc = [segue destinationViewController];
        vc.show = showToOpen;
    }
}

#pragma mark - Scrollview Delegates
CGFloat lastContentOffset;

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

ScrollDirection scrollDirection = ScrollDirectionNone;

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.scrollNews) {
        if (self.scrollNews.contentOffset.x < previousScroll) {
            NSLog(@"finished going backward");
            if (newsPage > 1) newsPage--;
        } else if (self.scrollNews.contentOffset.x > previousScroll) {
            NSLog(@"finished going forward");
            if (newsPage < numOfNewsItems) newsPage++;
        }
        NSLog(@"page %i", newsPage);
        previousScroll = self.scrollNews.contentOffset.x;
    }
}

bool isScrolling = NO;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.scrollMain) {
        if (scrollView.contentOffset.y < -128) {
            scrollView.contentOffset = CGPointMake(0, -128);
        }
    }
    
    if (lastContentOffset > scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionRight;
    else if (lastContentOffset < scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionLeft;
    
    lastContentOffset = scrollView.contentOffset.x;
    
    if (scrollView == self.scrollViewShows) {
        
        CGFloat pageWidth = self.scrollViewShows.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = self.scrollViewShows.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pageShows.currentPage = page;
        
        if (scrollDirection == ScrollDirectionRight) {
            self.lblShowsHeader.text = lastShowString;
        } else if (scrollDirection == ScrollDirectionLeft) {
            self.lblShowsHeader.text = nextShowString;
        }
    }
    
    if (scrollView == self.scrollTopTwelve) {
        CGFloat pageWidth = self.scrollTopTwelve.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = self.scrollTopTwelve.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pageTopTwelve.currentPage = page;
    }
    
    if (scrollView == self.scrollNews) {
//        
//        if (newsPage == numOfNewsItems) {
//            if (!isScrolling) {
//                self.scrollNews.frame = CGRectMake(8, self.scrollNews.frame.origin.y, self.view.frame.size.width - 16, self.scrollNews.frame.size.height);
//                isScrolling = YES;
//            }
//        }
//        if (newsPage == numOfNewsItems - 1) {
//            if (scrollDirection == ScrollDirectionLeft) {
//                if (!isScrolling) {
//                    self.scrollNews.frame = CGRectMake(8, self.scrollNews.frame.origin.y, newsScrollWidth + 8, self.scrollNews.frame.size.height);
//                    isScrolling = YES;
//                }
//            }
//        }
        if (newsPage < numOfNewsItems - 2) {
            //self.scrollNews.frame = CGRectMake(8, self.scrollNews.frame.origin.y, newsScrollWidth + 8, self.scrollNews.frame.size.height);
        }
        //self.scrollNews.contentSize = CGSizeMake(newsContentWidth, self.scrollNews.frame.size.height);
        
        // SECOND TO LAST PAGE
//        if (newsPage == numOfNewsItems - 1) {
//            if (scrollDirection == ScrollDirectionLeft) {
//                
//                // GOING TO LAST PAGE, CHANGE SIZE OF SCROLLVIEW
//                //self.scrollNews.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollNews.frame.size.height);
//                self.scrollNews.frame = CGRectMake(8, self.scrollNews.frame.origin.y, self.view.frame.size.width, self.scrollNews.frame.size.height);
//            } else {
//                //self.scrollNews.contentSize = CGSizeMake(self.view.frame.size.width - newsScrollWidth, self.scrollNews.frame.size.height);
//                self.scrollNews.frame = CGRectMake(8, self.scrollNews.frame.origin.y, self.view.frame.size.width - newsScrollWidth, self.scrollNews.frame.size.height);
//            }
//            // LAST PAGE GOING BACKWARDS NOW
//        } else if (newsPage == numOfNewsItems) {
//            if (scrollDirection == ScrollDirectionRight) {
//                self.scrollNews.contentSize = CGSizeMake(self.view.frame.size.width - newsScrollWidth, self.scrollNews.frame.size.height);
//            }
//            
//            self.scrollNews.frame = CGRectMake(0, self.scrollNews.frame.origin.y, self.view.frame.size.width - newsScrollWidth, self.scrollNews.frame.size.height);
////            if (scrollDirection == ScrollDirectionRight) {
////                
////                self.scrollNews.frame = CGRectMake(8, self.scrollNews.frame.origin.y, self.view.frame.size.width - newsScrollWidth, self.scrollNews.frame.size.height);
////            }
//            
//        }
//        CGFloat pageWidth = self.scrollNews.frame.size.width;
//        int page = floor((self.scrollNews.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//        self.pageNews.currentPage = page;
//        NSLog(@"%f - page %lu", self.scrollNews.frame.size.width, self.pageNews.currentPage);
    }
    
    if (scrollView == self.scrollHeadshots) {
        // the user scrolled manually, so reset the counter
        counter = 0;
    }
}

CGFloat previousScroll;
int newsPage = 1;
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (scrollView == self.scrollNews) {
        isScrolling = NO;
        previousScroll = self.scrollNews.contentOffset.x;
    }
 
//    if (scrollView == self.scrollNews) {
//        if (self.pageNews.currentPage == numOfNewsItems - 2) {
//            // 2ND TO LAST PAGE
//            NSLog(@"2nd to last page");
//            self.scrollNews.frame = CGRectMake(8, self.scrollNews.frame.origin.y, self.view.frame.size.width, self.scrollNews.frame.size.height);
//        } else if (self.pageNews.currentPage == numOfNewsItems - 1) {
//            // LAST PAGE
//            NSLog(@"on last page");
//            self.scrollNews.frame = CGRectMake(0, self.scrollNews.frame.origin.y, self.view.frame.size.width - newsScrollWidth, self.scrollNews.frame.size.height);
//        } else {
//            self.scrollNews.frame = CGRectMake(8, self.scrollNews.frame.origin.y, newsScrollWidth, self.scrollNews.frame.size.height);
//        }
//    }
    
    if (scrollView == self.scrollHeadshots) {
     
        // All data for the documents are stored in an array (documentTitles).
        // We keep track of the index that we are scrolling to so that we
        // know what data to load for each page.
        if(scrollView.contentOffset.x > scrollView.frame.size.width) {
            // We are moving forward. Load the current doc data on the first page.
            [self loadPageWithId:self.currIndex onPage:0];
            // Add one to the currentIndex or reset to 0 if we have reached the end.
            self.currIndex = (self.currIndex >= [self.arrayOfHeadshots count]-1) ? 0 : self.currIndex + 1;
            [self loadPageWithId:self.currIndex onPage:1];
            // Load content on the last page. This is either from the next item in the array
            // or the first if we have reached the end.
            self.nextIndex = (self.currIndex >= [self.arrayOfHeadshots count]-1) ? 0 : self.currIndex + 1;
            [self loadPageWithId:self.nextIndex onPage:2];
        }
        if(scrollView.contentOffset.x < scrollView.frame.size.width) {
            // We are moving backward. Load the current doc data on the last page.
            [self loadPageWithId:self.currIndex onPage:2];
            // Subtract one from the currentIndex or go to the end if we have reached the beginning.
            self.currIndex = (self.currIndex == 0) ? (int)[self.arrayOfHeadshots count]-1 : self.currIndex - 1;
            [self loadPageWithId:self.currIndex onPage:1];
            // Load content on the first page. This is either from the prev item in the array
            // or the last if we have reached the beginning.
            self.prevIndex = (self.currIndex == 0) ? (int)[self.arrayOfHeadshots count]-1 : self.currIndex - 1;
            [self loadPageWithId:self.prevIndex onPage:0];
        }     
        
        // Reset offset back to middle page     
        [scrollView scrollRectToVisible:CGRectMake(320,0,320,416) animated:NO];
    }
}

-(IBAction)finalsContest_clicked:(id)sender {
    [self performSegueWithIdentifier:@"contest" sender:self];
}

-(void)feedback_clicked:(id)sender {
    
    [self performSegueWithIdentifier:@"feedback" sender:self];
}

-(IBAction)seeAllRankings_clicked:(id)sender {
    
    [self performSegueWithIdentifier:@"rankings" sender:self];
}

- (IBAction)seeAllShows_clicked:(id)sender {
    
    [self performSegueWithIdentifier:@"shows" sender:self];
}

-(IBAction)aboutTheCorps_clicked:(id)sender {

    [self performSegueWithIdentifier:@"corps" sender:self];
}

- (IBAction)seeAllNews_clicked:(id)sender {
    [self performSegueWithIdentifier:@"news" sender:self];
}

-(NSMutableDictionary *)dateIndex {
    if (!_dateIndex) {
        _dateIndex = [[NSMutableDictionary alloc] init];
    }
    return _dateIndex;
}

-(NSMutableArray *)datesArray {
    if (!_datesArray) {
        _datesArray = [[NSMutableArray alloc] init];
    }
    return _datesArray;
}

-(NSMutableArray *)arrayOfLastShows {
    if (!_arrayOfLastShows) {
        _arrayOfLastShows = [[NSMutableArray alloc] init];
    }
    return _arrayOfLastShows;
}

-(NSMutableArray *)arrayOfNextShows {
    if (!_arrayOfNextShows) {
        _arrayOfNextShows = [[NSMutableArray alloc] init];
    }
    return _arrayOfNextShows;
}

-(NSMutableArray *)arrayOfHeadshots {
    if (!_arrayOfHeadshots) {
        _arrayOfHeadshots = [[NSMutableArray alloc] init];
    }
    return _arrayOfHeadshots;
}

@end
