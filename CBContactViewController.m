//
//  CBContactViewController.m
//  CorpsBoard
//
//  Created by Justin Moore on 6/27/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBContactViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "CBProblemTableViewController.h"
#import "CBSingle.h"

@interface CBContactViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableFeedback;

@end

CBSingle *data;

@implementation CBContactViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    [self.tableFeedback reloadData];
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [CBSingle data];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableFeedback.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark
#pragma mark - UITableView Delegates
#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [self.tableFeedback dequeueReusableCellWithIdentifier:@"general"];
            break;
        case 2:
            cell = [self.tableFeedback dequeueReusableCellWithIdentifier:@"bug"];
            break;
        case 1:
            cell = [self.tableFeedback dequeueReusableCellWithIdentifier:@"information"];
            break;
        case 3:
            cell = [self.tableFeedback dequeueReusableCellWithIdentifier:@"rate"];
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *theUrl;
    NSString *ios7;
    NSString *ios;
    NSString *appId;
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"feedback" sender:self];
            break;
        case 2:
            isProblem = YES;
            [self performSegueWithIdentifier:@"problem" sender:self];
            break;
        case 1:
            isProblem = NO;
            [self performSegueWithIdentifier:@"problem" sender:self];
            break;
        case 3:

            ios7 = data.objAdmin[@"iOS7AppStoreLink"];
            ios = data.objAdmin[@"iOSAppStoreLink"];
            appId = data.objAdmin[@"appStoreID"];
            theUrl = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? ios7: ios, appId]];
            [[UIApplication sharedApplication] openURL:theUrl];
            
            break;
        default:
            break;
    }
}

BOOL isProblem;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"problem"]) {
        
        CBProblemTableViewController *vc = (CBProblemTableViewController *)[[segue destinationViewController] topViewController];
        vc.isAProblem = isProblem;
    }
}

@end
