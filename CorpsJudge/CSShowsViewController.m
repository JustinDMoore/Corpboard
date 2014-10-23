//
//  CJShowSelectionViewController.m
//  CorpsJudge
//
//  Created by Isaias Favela on 6/16/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CSShowsViewController.h"
#import <Parse/Parse.h>
#import "CSShowDetailsViewController.h"
#import "CSLoginViewController.h"
#import "NSDate+Utilities.h"
#import "CSSingle.h"

CSSingle *data;
NSTimer *timer;
CSAppDelegate *del;
BOOL firstLoad = YES;
BOOL refreshing = NO;

@interface CSShowsViewController ()
@property (nonatomic, weak) IBOutlet UITableView *showsTable;
@property (nonatomic, strong) NSMutableArray *datesArray; //of NSString
@property (nonatomic, strong) NSMutableDictionary *dateIndex;
@property (nonatomic, strong) PFObject *currentSelectedShow; //only updated when the user selects a show
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *lblActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation CSShowsViewController

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

-(void)viewWillAppear:(BOOL)animated {
    
    [self.showsTable reloadData];
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

    UITableViewCell *cell = [self.showsTable dequeueReusableCellWithIdentifier:@"show"];
    
    if ([data.arrayOfAllShows count]) {
        
        NSString *dateString = [self.datesArray objectAtIndex:[indexPath section]];
        NSPredicate *search = [NSPredicate predicateWithFormat:@"showDate == %@", dateString];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"showDate" ascending:YES];
        
        //sort the dates within each section
        NSArray *filteredArray = [[data.arrayOfAllShows filteredArrayUsingPredicate:search]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        PFObject *show = [filteredArray objectAtIndex:[indexPath row]];
        
        cell.textLabel.text = show[@"showName"];
        cell.detailTextLabel.text = show[@"showLocation"];

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
        CSShowDetailsViewController *vc = [segue destinationViewController];
        
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
