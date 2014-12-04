//
//  CJShowSelectionViewController.m
//  CorpsJudge
//
//  Created by Isaias Favela on 6/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBShowsViewController.h"
#import <Parse/Parse.h>
#import "CBShowDetailsViewController.h"
#import "NSDate+Utilities.h"
#import "CBSingle.h"

CBSingle *data;
NSTimer *timer;
CBAppDelegate *del;
BOOL firstLoad = YES;
BOOL refreshing = NO;

@interface CBShowsViewController ()
@property (nonatomic, weak) IBOutlet UITableView *showsTable;
@property (nonatomic, strong) NSMutableArray *datesArray; //of NSString
@property (nonatomic, strong) NSMutableDictionary *dateIndex;
@property (nonatomic, strong) PFObject *currentSelectedShow; //only updated when the user selects a show
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *lblActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation CBShowsViewController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

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
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"BackArrow"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.showsTable reloadData];
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self initVariables];
    [self initUI];
    [self startTimer];
}

-(void)initVariables {
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Shows";
}

-(void)initUI {
    
    self.showsTable.hidden = YES;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.showsTable addSubview:self.refreshControl];
}

-(void)checkForShows {
    
    if (data.updatedShows) {
        [timer invalidate];
        
        if ([data.arrayOfAllShows count]) {
            
            self.lblActivity.hidden = YES;
            [self.activity stopAnimating];
            self.showsTable.hidden = NO;
            self.showsTable.userInteractionEnabled = YES;
            [self.refreshControl endRefreshing];
            [self displayShows];
            if (firstLoad) {
                [self scrollToDate];
                firstLoad = NO;
            }
        } else {
            
            self.lblActivity.text = @"Could not connect to server";
            [self.activity stopAnimating];
            self.activity.hidden = YES;
        }
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    self.showsTable.userInteractionEnabled = NO;
    self.dateIndex = nil;
    self.datesArray = nil;
    [data getAllShowsFromServer];
    [self startTimer];
}

-(void)displayShows {
    
    if ([data.arrayOfAllShows count]) {
        [self reloadTable];
    }
}

-(void)scrollToDate {
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:[self getIndexOfNearestDateFromDateArray] - 1];
    [self.showsTable scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)startTimer {
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.5
                                             target:self
                                           selector:@selector(checkForShows)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)reloadTable {
    
    [self processForTableView:data.arrayOfAllShows];
    [self.showsTable reloadData];
}

-(NSInteger)getIndexOfNearestDateFromDateArray {

    NSDate *testDate = [NSDate date];

    
    NSTimeInterval closestInterval = DBL_MAX;
    
    NSInteger index = 0;
    
    for (NSDate *myObject in self.datesArray) {
        NSTimeInterval interval = [myObject timeIntervalSinceDate:testDate];
        if (interval > 0) {
            if (interval < closestInterval) {
                closestInterval = interval;
                return index;
            }
        }
        index++;
    }

    return 0;
}

-(void)processForTableView:(NSMutableArray *)items {
    
    for (PFObject *show in items) {
        
        if (![self.datesArray containsObject:show[@"showDate"]]) {
            //add it
            [self.datesArray addObject:show[@"showDate"]];
            [self.dateIndex setObject:[NSNumber numberWithInt:1] forKey:show[@"showDate"]];
        } else {
            [self.dateIndex setObject:[NSNumber numberWithInt:[[self.dateIndex objectForKey:show[@"showDate"]] intValue] + 1] forKey:show[@"showDate"]];
        }
    }   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Shows TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.dateIndex count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSDate *showDate = [self.datesArray objectAtIndex:section];
    if ([showDate isToday]) return @"TODAY";
    if ([showDate isTomorrow]) return @"TOMORROW";
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM d"];

    NSString *dateString = [format stringFromDate:showDate];
    return dateString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *date = [self.datesArray objectAtIndex:section];
    return [[self.dateIndex objectForKey:date] intValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.showsTable dequeueReusableCellWithIdentifier:@"show1"];
    
    UILabel *lblShowTitle = (UILabel *)[cell viewWithTag:1];
    UILabel *lblShowLocation = (UILabel *)[cell viewWithTag:2];
    UIButton *btnScores = (UIButton *)[cell viewWithTag:3];
    
    if ([data.arrayOfAllShows count]) {
        
        NSString *dateString = [self.datesArray objectAtIndex:[indexPath section]];
        NSPredicate *search = [NSPredicate predicateWithFormat:@"showDate == %@", dateString];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"showDate" ascending:YES];
        
        //sort the dates within each section
        NSArray *filteredArray = [[data.arrayOfAllShows filteredArrayUsingPredicate:search]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        PFObject *show = [filteredArray objectAtIndex:[indexPath row]];
        
        lblShowTitle.text = show[@"showName"];
        lblShowLocation.text = show[@"showLocation"];
        BOOL isOver = [show[@"isShowOver"] boolValue];
        if (isOver) {
            btnScores.hidden = NO;
            
            btnScores.layer.borderWidth = 1.0f;
            
            btnScores.layer.borderColor = btnScores.titleLabel.tintColor.CGColor;
            
            btnScores.layer.cornerRadius = 4.0f;
            btnScores.layer.masksToBounds = YES;
            btnScores.titleLabel.text = @" Scores ";
        } else btnScores.hidden = YES;
        
    } else {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *dateString = [self.datesArray objectAtIndex:[indexPath section]];
    NSPredicate *search = [NSPredicate predicateWithFormat:@"showDate == %@", dateString];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"showDate" ascending:YES];
    
    //sort the dates within each section
    NSArray *filteredArray = [[data.arrayOfAllShows filteredArrayUsingPredicate:search]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    self.currentSelectedShow = [filteredArray objectAtIndex:[indexPath row
                                                   ]];
    [self performSegueWithIdentifier:@"showDetails" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showDetails"])
    {
        // Get reference to the destination view controller
        CBShowDetailsViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        //vc.didUserVote = [data didUserVoteForShow:self.currentSelectedShow];
        vc.show = self.currentSelectedShow;
    }
}

#pragma mark - Properties

-(NSMutableArray *)datesArray {
    if (!_datesArray) {
        _datesArray = [[NSMutableArray alloc] init];
    }
    return _datesArray;
}

-(NSMutableDictionary *)dateIndex {
    if (!_dateIndex) {
        _dateIndex = [[NSMutableDictionary alloc] init];
    }
    return _dateIndex;
}

@end
