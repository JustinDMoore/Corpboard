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
#import "KVNProgress.h"
#import "Configuration.h"

CBSingle *data;
CBAppDelegate *del;
BOOL firstLoad = YES;

@interface CBShowsViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableShows;
@property (nonatomic, strong) NSMutableArray *datesArray; //of NSString
@property (nonatomic, strong) NSMutableDictionary *dateIndex;
@property (nonatomic, strong) PFObject *currentSelectedShow; //only updated when the user selects a show

@end

@implementation CBShowsViewController {
    
}

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
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.tableShows deselectRowAtIndexPath:[self.tableShows indexPathForSelectedRow] animated:animated];
    [self.tableShows reloadData];
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });
    
    [self initVariables];
    [self initUI];
    [self checkForShows];
}

-(void)initVariables {
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Shows";
}

-(void)initUI {
    
    self.tableShows.hidden = YES;
}

-(void)checkForShows {
    
    
    if (data.dataLoaded) {
        
        if ([data.arrayOfAllShows count]) {
            
            self.tableShows.hidden = NO;
            self.tableShows.userInteractionEnabled = YES;
            [self displayShows];
            if (firstLoad) {
                [self scrollToDate];
                firstLoad = NO;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });
        
    } else {
        NSLog(@"Not loaded");
    }
    
}

-(void)displayShows {
    
    if ([data.arrayOfAllShows count]) {
        [self reloadTable];
    }
}

-(void)scrollToDate {
    
    NSInteger x = [self getIndexOfNearestDateFromDateArray] - 1;
    if (x > 0) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:x];
        [self.tableShows scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)reloadTable {
    
    [self processForTableView:data.arrayOfAllShows];
    [self.tableShows reloadData];
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

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    // Background color
    view.tintColor = [UIColor darkGrayColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor lightGrayColor]];
    [header.textLabel setFont:[UIFont systemFontOfSize:16]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.dateIndex count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSDate *showDate = [self.datesArray objectAtIndex:section];
    if ([showDate isToday]) return @"Today";
    if ([showDate isTomorrow]) return @"Tomorrow";
    
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
    
    UITableViewCell *cell;
    
    if ([data.arrayOfAllShows count]) {
        NSString *dateString = [self.datesArray objectAtIndex:[indexPath section]];
        NSPredicate *search = [NSPredicate predicateWithFormat:@"showDate == %@", dateString];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"showDate" ascending:YES];
        
        //sort the dates within each section
        NSArray *filteredArray = [[data.arrayOfAllShows filteredArrayUsingPredicate:search]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        PFObject *show = [filteredArray objectAtIndex:[indexPath row]];
        NSString *exc = show[@"exception"];
        
        UILabel *lblException;
        UIButton *btnScores;
        if ([exc length]) {
            
            cell = [self.tableShows dequeueReusableCellWithIdentifier:@"show2"];
            lblException = (UILabel *)[cell viewWithTag:4];
            btnScores.hidden = YES;
            lblException.hidden = NO;
        } else {
            
            cell = [self.tableShows dequeueReusableCellWithIdentifier:@"show1"];
            btnScores = (UIButton *)[cell viewWithTag:3];
            lblException.hidden = YES;
            btnScores.hidden = NO;
        }
        
        UILabel *lblShowTitle = (UILabel *)[cell viewWithTag:1];
        UILabel *lblShowLocation = (UILabel *)[cell viewWithTag:2];
        
        lblShowTitle.text = show[@"showName"];
        lblShowLocation.text = show[@"showLocation"];
        BOOL isOver = [show[@"isShowOver"] boolValue];
        
        if (isOver) {
            if ([exc length]) {
                
                lblException.text = exc;
                btnScores.hidden = YES;
                lblException.hidden = NO;
            } else {
                lblException.hidden = YES;
                btnScores.hidden = NO;
                btnScores.layer.borderWidth = 1.0f;
                btnScores.layer.borderColor = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:237/255.0 alpha:1].CGColor;
                
                btnScores.layer.cornerRadius = 4.0f;
                btnScores.layer.masksToBounds = YES;
                btnScores.titleLabel.text = @" Scores ";
                btnScores.titleLabel.font = [UIFont systemFontOfSize:12];
                [btnScores addTarget:self action:@selector(openShows:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        } else {
            btnScores.hidden = YES;
            lblException.hidden = YES;
        }
        
    }
    
    
    return cell;
}


-(void)openShows:(UIButton *)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableShows];
    NSIndexPath *indPath = [self.tableShows indexPathForRowAtPoint:buttonPosition];
    
    [self openShowAtIndex:indPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self openShowAtIndex:indexPath];
}

-(void)openShowAtIndex:(NSIndexPath *)indexPath {
    
    NSString *dateString = [self.datesArray objectAtIndex:[indexPath section]];
    NSPredicate *search = [NSPredicate predicateWithFormat:@"showDate == %@", dateString];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"showDate" ascending:YES];
    
    //sort the dates within each section
    NSArray *filteredArray = [[data.arrayOfAllShows filteredArrayUsingPredicate:search]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    self.currentSelectedShow = [filteredArray objectAtIndex:indexPath.row];
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
