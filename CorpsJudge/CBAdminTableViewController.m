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
#import "CBUserProfileViewController.h"
#import <ParseUI/ParseUI.h>

@interface CBAdminTableViewController ()
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
            break;
        case reports:
            break;
    }
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getFeedback {
    
    [KVNProgress show];
    [self.arrayOfData removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"feedback"];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [KVNProgress dismiss];
        if (!error) {
            if ([objects count]) {
                [self.arrayOfData addObjectsFromArray:objects];
                [self.tableView reloadData];
            }
        }
    }];
}

-(void)getBugs {
    
    [KVNProgress show];
    [self.arrayOfData removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"problems"];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [KVNProgress dismiss];
        if (!error) {
            if ([objects count]) {
                [self.arrayOfData addObjectsFromArray:objects];
                [self.tableView reloadData];
            }
        }
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        default: return nil;
            break;
    }
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

NSInteger selectedCell;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedCell = indexPath.row;
    
    switch ((int)self.type) {
        case feedback: [self performSegueWithIdentifier:@"profile" sender:self];
            break;
        case bugs: [self performSegueWithIdentifier:@"profile" sender:self];
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"profile"]) {
        CBUserProfileViewController *vc = [segue destinationViewController];
        PFObject *obj = self.arrayOfData[selectedCell];
        PFUser *user = obj[@"user"];
        vc.userProfile = user;
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
