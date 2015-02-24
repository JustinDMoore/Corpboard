//
//  CBAdminViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 2/22/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBAdminViewController.h"
#import "JSBadgeView.h"
#import "CBSingle.h"
#import "CBAdminTableViewController.h"

@interface CBAdminViewController ()
@property (nonatomic, strong) JSBadgeView *badgeFeedback;
@property (nonatomic, strong) JSBadgeView *badgeBugs;
@property (nonatomic, strong) JSBadgeView *badgePhotos;
@property (nonatomic, strong) JSBadgeView *badgeUsersReported;
@end

CBSingle *data;

@implementation CBAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [CBSingle data];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    self.title = @"Admin";
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    NSString *category;
    UIImageView *imgIcon;
    JSBadgeView *badgeView;
    
    switch (indexPath.row) {
        case 0: cell = [tableView dequeueReusableCellWithIdentifier:@"feedback" forIndexPath:indexPath];
            category = @"feedback";
            badgeView = self.badgeFeedback;
            break;
        case 1: cell = [tableView dequeueReusableCellWithIdentifier:@"bugs" forIndexPath:indexPath];
            category = @"problems";
            badgeView = self.badgeBugs;
            break;
        case 2: cell = [tableView dequeueReusableCellWithIdentifier:@"photos" forIndexPath:indexPath];
            category = @"photos";
            badgeView = self.badgePhotos;
            break;
        case 3: cell = [tableView dequeueReusableCellWithIdentifier:@"reports" forIndexPath:indexPath];
            category = @"usersReported";
            badgeView = self.badgeUsersReported;
            break;
    }
    
    imgIcon = (UIImageView *)[cell viewWithTag:2];
    if (!badgeView) badgeView = [[JSBadgeView alloc] initWithParentView:imgIcon alignment:JSBadgeViewAlignmentTopRight];

    int num = [data.objAdmin[category] intValue];
    
    if (num > 0) {
        badgeView.badgeText = [NSString stringWithFormat:@"%i", num];
    } else {
        badgeView.badgeText = @"";
    }
    
    return cell;
}

NSInteger selectedRow;
NSString *adminCategory;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedRow = indexPath.row;
    NSString *category;
    JSBadgeView *badgeView;
    
    switch (indexPath.row) {
        case 0:
            category = @"feedback";
            badgeView = self.badgeFeedback;
            break;
        case 1:
            category = @"problems";
            badgeView = self.badgeBugs;
            break;
        case 2:
            category = @"photos";
            badgeView = self.badgePhotos;
            break;
        case 3:
            category = @"usersReported";
            badgeView = self.badgeUsersReported;
            break;
    }
    
    adminCategory = category;
    badgeView.badgeText = @"";
    data.objAdmin[category] = [NSNumber numberWithInt:0];
    [data.objAdmin saveEventually];
    [self performSegueWithIdentifier:@"adminDetails" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"adminDetails"]) {
        CBAdminTableViewController *vc = [segue destinationViewController];
        if ([adminCategory isEqualToString:@"feedback"]) vc.type = feedback;
        else if ([adminCategory isEqualToString:@"problems"]) vc.type = bugs;
        else if ([adminCategory isEqualToString:@"photos"]) vc.type = photos;
        else if ([adminCategory isEqualToString:@"usersReported"]) vc.type = reports;
    }
}

@end
