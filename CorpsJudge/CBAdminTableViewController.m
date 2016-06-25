//
//  CBAdminTableViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 2/22/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBAdminTableViewController.h"
#import <Parse/Parse.h>
#import "KVNProgress.h"
#import "NSDate+Utilities.h"
#import <ParseUI/ParseUI.h>
#import "Configuration.h"
#import "Corpsboard-Swift.h"

@interface CBAdminTableViewController () {
    PFQuery *queryFeedback, *queryProblems, *queryPhotos, *queryReports, *queryInner, *queryOuter;
}

@property (nonatomic, strong) NSMutableArray *arrayOfData;
@property (nonatomic, strong) CBPhoto *photoBrowser;

@end

@implementation CBAdminTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    switch ((int)self.type) {
        case feedback:
            [self getFeedback];
            break;
        case bugs:
            [self getBugs];
            break;
        case photos:
            [self getPhotos];
            break;
        case reports:
            [self getReports];
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UISingleton.sharedInstance getBackButton];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    switch ((int)self.type) {
        case feedback: self.title = @"User Feedback";
            break;
        case bugs: self.title = @"Bugs";
            break;
        case photos: self.title = @"Photos For Review";
            break;
        case reports: self.title = @"Reported Users";
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];

}

- (void)goback {
    
    [queryInner cancel];
    [queryOuter cancel];
    [queryFeedback cancel];
    [queryPhotos cancel];
    [queryProblems cancel];
    [queryReports cancel];
    
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress dismiss];
    });
}

-(void)getFeedback {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });

    
    [self.arrayOfData removeAllObjects];
    queryFeedback = [PFQuery queryWithClassName:@"feedback"];
    [queryFeedback includeKey:@"user"];
    [queryFeedback orderByDescending:@"createdAt"];
    [queryFeedback findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });

        if (!error) {
            if ([objects count]) {
                [self.arrayOfData addObjectsFromArray:objects];
                [self reload];
            }
        }
    }];
}

-(void)getBugs {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });

    [self.arrayOfData removeAllObjects];
    queryProblems = [PFQuery queryWithClassName:@"problems"];
    [queryProblems includeKey:@"user"];
    [queryProblems orderByDescending:@"createdAt"];
    [queryProblems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });

        if (!error) {
            if ([objects count]) {
                [self.arrayOfData addObjectsFromArray:objects];
                [self reload];
            }
        }
    }];
}

-(void)getPhotos {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });
    
    [self.arrayOfData removeAllObjects];
    queryPhotos = [PFQuery queryWithClassName:@"Photos"];
    [queryPhotos includeKey:@"user"];
    [queryPhotos whereKey:@"isUserSubmitted" equalTo:[NSNumber numberWithBool:YES]];
    [queryPhotos whereKey:@"approved" equalTo:[NSNumber numberWithBool:NO]];
    [queryPhotos orderByDescending:@"createdAt"];
    [queryPhotos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });

        if (!error) {
            if ([objects count]) {
                [self.arrayOfData addObjectsFromArray:objects];
                [self reload];
            }
        }
    }];
}

-(void)getReports {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });

    [self.arrayOfData removeAllObjects];
    queryReports = [PFQuery queryWithClassName:@"ReportUsers"];
    [queryReports includeKey:@"userReporting"];
    [queryReports includeKey:@"userBeingReported"];
    [queryReports orderByDescending:@"createdAt"];
    [queryReports findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });

        if (!error) {
            if ([objects count]) {
                [self.arrayOfData addObjectsFromArray:objects];
                [self reload];
            }
        }
    }];
}

-(void)reload {
    
    if ([self.arrayOfData count]) {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    } else {
        self.tableView.hidden = YES;
    }
}

-(void)approvePhoto:(id)sender {

    UIButton *btn = (UIButton *)sender;
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    PFObject *objPhoto = self.arrayOfData[indexPath.row];
    PFUser *objUser = objPhoto[@"user"];

    queryInner = [PFUser query];
    [queryInner whereKey:@"objectId" equalTo:objUser.objectId];
    queryOuter = [PFInstallation query];
    [queryOuter whereKey:@"user" matchesQuery:queryInner];
    
    PFPush *push = [[PFPush alloc] init];
    switch (btn.tag) {
        case 1:
            objPhoto[@"approved"] = [NSNumber numberWithBool:YES];
            [objPhoto saveEventually];
            [push setQuery:queryOuter];
            [push setMessage:@"A cover photo you submitted has been approved."];
            [push sendPushInBackground];
            break;
        case 2:
            [push setQuery:queryOuter];
            [push setMessage:@"A cover photo you submitted was not approved."];
            [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               [objPhoto deleteEventually];
            }];
            break;
    }

    [self.arrayOfData removeObject:objPhoto];
    [self reload];
}

-(void)showScreenShots:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    PFObject *objBug = self.arrayOfData[indexPath.row];
    PFFile *imgFile;
    switch (btn.tag) {
        case 11: imgFile = objBug[@"screenshot1"];
            break;
        case 12: imgFile = objBug[@"screenshot2"];
            break;
        case 13: imgFile = objBug[@"screenshot3"];
            break;
    }
    
    if (imgFile) {
        [self.navigationController.view addSubview:self.photoBrowser];
        self.photoBrowser.imgFile = imgFile;
        [self.photoBrowser showInParent:self.view.frame];
    }
}

NSIndexPath *currentIndex;
-(void)deleteReport:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.tableView];
    currentIndex = [self.tableView indexPathForRowAtPoint:buttonPosition];

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this report?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UIAlertView
#pragma mark

-(void)alertViewCancel:(UIAlertView *)alertView {
    
    currentIndex = nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        PFObject *objReportToDelete = self.arrayOfData[currentIndex.row];
        [objReportToDelete deleteEventually];
        [self.arrayOfData removeObject:objReportToDelete];
        [self reload];
        currentIndex = nil;
    }
}

PUser *userToOpen;
-(void)openUserProfile:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    PFObject *objReport = self.arrayOfData[indexPath.row];
    
    if (btn.tag == 1) {
        
        userToOpen = objReport[@"userReporting"];
        
    } else if (btn.tag == 2) {
        
        userToOpen = objReport[@"userBeingReported"];
        
    }
    
    [self performSegueWithIdentifier:@"profile" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arrayOfData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ((int)self.type) {
        case feedback: return [self getFeedbackCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case bugs: return [self getBugCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case photos: return [self getPhotoCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        case reports: return [self getReportCell:tableView cellForRowAtIndexPath:indexPath];
            break;
        default: return nil;
            break;
    }
}

-(UITableViewCell *)getReportCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"report" forIndexPath:indexPath];
    tableView.estimatedRowHeight = 68;

    UIButton *btnUserReporting = (UIButton *)[cell viewWithTag:1];
    UIButton *btnUserBeingReported = (UIButton *)[cell viewWithTag:2];
    UIButton *btnDelete = (UIButton *)[cell viewWithTag:11];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:7];
    UILabel *lblFeedback = (UILabel *)[cell viewWithTag:8];
    
    PFObject *objReport = self.arrayOfData[indexPath.row];
    PFUser *userReporting = objReport[@"userReporting"];
    PFUser *userBeingReported = objReport[@"userBeingReported"];
    NSString *dateString = @"";
    
    [btnDelete addTarget:self action:@selector(deleteReport:) forControlEvents:UIControlEventTouchUpInside];
    [btnUserReporting addTarget:self action:@selector(openUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    [btnUserBeingReported addTarget:self action:@selector(openUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnUserReporting setTitle:userReporting[@"nickname"] forState:UIControlStateNormal];
    [btnUserBeingReported setTitle:userBeingReported[@"nickname"] forState:UIControlStateNormal];
    
    int diff = (int)[objReport.createdAt minutesBeforeDate:[NSDate date]];
    if (diff < 5) {
        dateString = @"Just Now";
    } else if (diff <= 50) {
        dateString = [NSString stringWithFormat:@"%i min ago", diff];
    } else if ((diff > 50) && (diff < 65)) {
        dateString = @"An hour ago";
    } else {
        if ([objReport.createdAt isYesterday]) dateString = @"Yesterday";
        if ([objReport.createdAt daysBeforeDate:[NSDate date]] == 2) {
            dateString = @"2 days ago";
        } else {
            if ([objReport.createdAt isToday]) {
                int hours = (int)[objReport.createdAt hoursBeforeDate:[NSDate date]];
                dateString = [NSString stringWithFormat:@"%i hours ago", hours];
            } else {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"MMMM d"];
                
                dateString = [format stringFromDate:objReport.createdAt];
            }
        }
    }
    lblFeedback.text = objReport[@"report"];
    lblDate.text = dateString;
    
    return cell;
}

-(UITableViewCell *)getPhotoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
    tableView.rowHeight = 180;
    UILabel *lblUser = (UILabel *)[cell viewWithTag:6];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:7];
    
    UIButton *btnApprove = (UIButton *)[cell viewWithTag:1];
    UIButton *btnDeny = (UIButton *)[cell viewWithTag:2];
    
    PFImageView *imgView = (PFImageView *)[cell viewWithTag:30];
    
    [btnApprove addTarget:self action:@selector(approvePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [btnDeny addTarget:self action:@selector(approvePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    PFObject *objPhoto = self.arrayOfData[indexPath.row];
    PFUser *userPhoto = objPhoto[@"user"];
    NSString *dateString = @"";
    
    PFFile *photoFile = objPhoto[@"photo"];
    
    if (photoFile) {
        [imgView setFile:photoFile];
        [imgView loadInBackground];
    }

    int diff = (int)[objPhoto.createdAt minutesBeforeDate:[NSDate date]];
    if (diff < 5) {
        dateString = @"Just Now";
    } else if (diff <= 50) {
        dateString = [NSString stringWithFormat:@"%i min ago", diff];
    } else if ((diff > 50) && (diff < 65)) {
        dateString = @"An hour ago";
    } else {
        if ([objPhoto.createdAt isYesterday]) dateString = @"Yesterday";
        if ([objPhoto.createdAt daysBeforeDate:[NSDate date]] == 2) {
            dateString = @"2 days ago";
        } else {
            if ([objPhoto.createdAt isToday]) {
                int hours = (int)[objPhoto.createdAt hoursBeforeDate:[NSDate date]];
                dateString = [NSString stringWithFormat:@"%i hours ago", hours];
            } else {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"MMMM d"];
                
                dateString = [format stringFromDate:objPhoto.createdAt];
            }
        }
    }
    
    lblUser.text = userPhoto[@"nickname"];
    lblDate.text = dateString;
    
    return cell;
}

-(UITableViewCell *)getBugCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bug" forIndexPath:indexPath];
    tableView.estimatedRowHeight = 110;
    UILabel *lblUser = (UILabel *)[cell viewWithTag:6];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:7];
    UILabel *lblFeedback = (UILabel *)[cell viewWithTag:8];
    UILabel *lblType = (UILabel *)[cell viewWithTag:9];
    UILabel *lblWhereAt = (UILabel *)[cell viewWithTag:10];
    UIButton *btnScreenshot1 = (UIButton *)[cell viewWithTag:11];
    UIButton *btnScreenshot2 = (UIButton *)[cell viewWithTag:12];
    UIButton *btnScreenshot3 = (UIButton *)[cell viewWithTag:13];
    [btnScreenshot1 addTarget:self action:@selector(showScreenShots:) forControlEvents:UIControlEventTouchUpInside];
    [btnScreenshot2 addTarget:self action:@selector(showScreenShots:) forControlEvents:UIControlEventTouchUpInside];
    [btnScreenshot3 addTarget:self action:@selector(showScreenShots:) forControlEvents:UIControlEventTouchUpInside];
    
    PFObject *objBug = self.arrayOfData[indexPath.row];
    PFUser *userBug = objBug[@"user"];
    NSString *dateString = @"";
    
    PFFile *screenshot1 = objBug[@"screenshot1"];
    PFFile *screenshot2 = objBug[@"screenshot2"];
    PFFile *screenshot3 = objBug[@"screenshot3"];
    
    if (screenshot1) {
        btnScreenshot1.hidden = NO;
    }  else {
        btnScreenshot1.hidden = YES;
    }
    
    if (screenshot2) {
        btnScreenshot2.hidden = NO;
    }  else {
        btnScreenshot2.hidden = YES;
    }
    
    if (screenshot3) {
        btnScreenshot3.hidden = NO;
    }  else {
        btnScreenshot3.hidden = YES;
    }
    
    int diff = (int)[objBug.createdAt minutesBeforeDate:[NSDate date]];
    if (diff < 5) {
        dateString = @"Just Now";
    } else if (diff <= 50) {
        dateString = [NSString stringWithFormat:@"%i min ago", diff];
    } else if ((diff > 50) && (diff < 65)) {
        dateString = @"An hour ago";
    } else {
        if ([objBug.createdAt isYesterday]) dateString = @"Yesterday";
        if ([objBug.createdAt daysBeforeDate:[NSDate date]] == 2) {
            dateString = @"2 days ago";
        } else {
            if ([objBug.createdAt isToday]) {
                int hours = (int)[objBug.createdAt hoursBeforeDate:[NSDate date]];
                dateString = [NSString stringWithFormat:@"%i hours ago", hours];
            } else {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"MMMM d"];
                
                dateString = [format stringFromDate:objBug.createdAt];
            }
        }
    }
    
    lblUser.text = userBug[@"nickname"];
    lblDate.text = dateString;
    lblType.text = objBug[@"type"];
    lblWhereAt.text = objBug[@"whereAt"];
    lblFeedback.text = objBug[@"whatHappened"];

    return cell;
}

-(UITableViewCell *)getFeedbackCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedback" forIndexPath:indexPath];
    tableView.estimatedRowHeight = 68;
    UILabel *lblUser = (UILabel *)[cell viewWithTag:6];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:7];
    UILabel *lblFeedback = (UILabel *)[cell viewWithTag:8];
    UIImageView *imgStar1 = (UIImageView *)[cell viewWithTag:1];
    UIImageView *imgStar2 = (UIImageView *)[cell viewWithTag:2];
    UIImageView *imgStar3 = (UIImageView *)[cell viewWithTag:3];
    UIImageView *imgStar4 = (UIImageView *)[cell viewWithTag:4];
    UIImageView *imgStar5 = (UIImageView *)[cell viewWithTag:5];
    
    PFObject *objFeedback = self.arrayOfData[indexPath.row];
    PFUser *userFeedback = objFeedback[@"user"];
    NSString *dateString = @"";
    
    int diff = (int)[objFeedback.createdAt minutesBeforeDate:[NSDate date]];
    if (diff < 5) {
        dateString = @"Just Now";
    } else if (diff <= 50) {
        dateString = [NSString stringWithFormat:@"%i min ago", diff];
    } else if ((diff > 50) && (diff < 65)) {
        dateString = @"An hour ago";
    } else {
        if ([objFeedback.createdAt isYesterday]) dateString = @"Yesterday";
        if ([objFeedback.createdAt daysBeforeDate:[NSDate date]] == 2) {
            dateString = @"2 days ago";
        } else {
            if ([objFeedback.createdAt isToday]) {
                int hours = (int)[objFeedback.createdAt hoursBeforeDate:[NSDate date]];
                dateString = [NSString stringWithFormat:@"%i hours ago", hours];
            } else {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"MMMM d"];
                
                dateString = [format stringFromDate:objFeedback.createdAt];
            }
        }
    }
    
    lblUser.text = userFeedback[@"nickname"];
    lblDate.text = dateString;
    NSString *feedback = objFeedback[@"text"];
    if ([feedback length]) lblFeedback.text = feedback;
    else lblFeedback.text = @"No Feedback Given"
        ;
    
    int stars = [objFeedback[@"stars"] intValue];
    switch (stars) {
        case 5:
            [imgStar5 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar4 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar3 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar2 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar1 setImage:[UIImage imageNamed:@"star_selected"]];
            break;
        case 4:
            [imgStar5 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar4 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar3 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar2 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar1 setImage:[UIImage imageNamed:@"star_selected"]];
            break;
        case 3:
            [imgStar5 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar4 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar3 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar2 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar1 setImage:[UIImage imageNamed:@"star_selected"]];
            break;
        case 2:
            [imgStar5 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar4 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar3 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar2 setImage:[UIImage imageNamed:@"star_selected"]];
            [imgStar1 setImage:[UIImage imageNamed:@"star_selected"]];
            break;
        case 1:
            [imgStar5 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar4 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar3 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar2 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar1 setImage:[UIImage imageNamed:@"star_selected"]];
            break;
        default:
            [imgStar5 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar4 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar3 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar2 setImage:[UIImage imageNamed:@"star_unselected"]];
            [imgStar1 setImage:[UIImage imageNamed:@"star_unselected"]];
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *obj;
    
    switch ((int)self.type) {
        case feedback:
            obj = self.arrayOfData[indexPath.row];
            userToOpen = obj[@"user"];
            [self performSegueWithIdentifier:@"profile" sender:self];
            break;
        case bugs:
            obj = self.arrayOfData[indexPath.row];
            userToOpen = obj[@"user"];
            [self performSegueWithIdentifier:@"profile" sender:self];
            break;
        case photos:
            obj = self.arrayOfData[indexPath.row];
            userToOpen = obj[@"user"];
            [self performSegueWithIdentifier:@"profile" sender:self];
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"profile"]) {
        ProfileTableViewController *vc = [segue destinationViewController];
        vc.userProfile = userToOpen;
    }
}

-(NSMutableArray *)arrayOfData {
    
    if (!_arrayOfData) {
        
        _arrayOfData = [[NSMutableArray alloc] init];
    }
    return _arrayOfData;
}

-(CBPhoto *)photoBrowser {
    
    if (!_photoBrowser) {
        
        _photoBrowser =
        [[[NSBundle mainBundle] loadNibNamed:@"CBPhoto"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
    }
    [_photoBrowser setDelegate:self];
    return _photoBrowser;
}

-(void)imageClosed {
    
    self.photoBrowser = nil;
}

@end
