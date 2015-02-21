//
//  CBAdminView.m
//  CorpBoard
//
//  Created by Isaias Favela on 2/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBAdminView.h"
#import <Parse/Parse.h>
#import "KVNProgress.h"
#import "NSDate+Utilities.h"

@interface CBAdminView ()
@property (weak, nonatomic) IBOutlet UITableView *tableAdmin;
@property (nonatomic, strong) NSMutableArray *arrayOfFeedback;
@end

@implementation CBAdminView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableAdmin.estimatedRowHeight = 20.0;
    self.tableAdmin.rowHeight = UITableViewAutomaticDimension;
    self.tableAdmin.dataSource = self;
    self.tableAdmin.delegate = self;
    [self getFeedback];
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
    self.title = @"News";
    
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getFeedback {
    
    [KVNProgress show];
    
    PFQuery *query = [PFQuery queryWithClassName:@"feedback"];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [KVNProgress dismiss];
        if (!error) {
            if ([objects count]) {
                [self.arrayOfFeedback addObjectsFromArray:objects];
                [self.tableAdmin reloadData];
            }
        }
    }];
}

-(NSMutableArray *)arrayOfFeedback {
    
    if (!_arrayOfFeedback) {
        
        _arrayOfFeedback = [[NSMutableArray alloc] init];
    }
    return _arrayOfFeedback;
}

#pragma mark
#pragma mark - UITableViewDelegates
#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayOfFeedback count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self getFeedbackCell:tableView cellForRowAtIndexPath:indexPath];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65;
}

-(UITableViewCell *)getFeedbackCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedback" forIndexPath:indexPath];
    
    UILabel *lblUser = (UILabel *)[cell viewWithTag:6];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:7];
    UILabel *lblFeedback = (UILabel *)[cell viewWithTag:8];
    UIImageView *imgStar1 = (UIImageView *)[cell viewWithTag:1];
    UIImageView *imgStar2 = (UIImageView *)[cell viewWithTag:2];
    UIImageView *imgStar3 = (UIImageView *)[cell viewWithTag:3];
    UIImageView *imgStar4 = (UIImageView *)[cell viewWithTag:4];
    UIImageView *imgStar5 = (UIImageView *)[cell viewWithTag:5];
    
    PFObject *objFeedback = self.arrayOfFeedback[indexPath.row];
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
    
    lblUser.text = [NSString stringWithFormat:@"%@ - %@", userFeedback[@"fullname"], userFeedback[@"nickname"]];
    lblDate.text = dateString;
    NSString *feedback = objFeedback[@"text"];
    if ([feedback length]) lblFeedback.text = feedback;
    else lblFeedback.text = @"No Feedback Given"
        ;
    [lblFeedback sizeToFit];
    
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

@end
