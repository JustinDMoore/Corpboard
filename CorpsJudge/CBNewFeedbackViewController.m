//
//  CBNewFeedbackViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 5/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBNewFeedbackViewController.h"

@interface CBNewFeedbackViewController ()

@end

@implementation CBNewFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:visualEffectView];
    [self.view sendSubviewToBack:visualEffectView];
    self.arrayOfFeedbackItems = [[NSMutableArray alloc] init];
    [self.arrayOfFeedbackItems addObject:@"General Feedback"];
    [self.arrayOfFeedbackItems addObject:@"Something Isn't Working"];
    [self.arrayOfFeedbackItems addObject:@"Report Incorrect Information"];
    [self.arrayOfFeedbackItems addObject:@"Rate Corpboard"];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.viewFeedback =
    [[[NSBundle mainBundle] loadNibNamed:@"CBFeedback"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    [self.view addSubview:self.viewFeedback];
    [self.viewFeedback showInParent:self.view.frame];
    [self.viewFeedback setDelegate:self];
    self.viewFeedback.tableFeedback.delegate = self;
    self.viewFeedback.tableFeedback.dataSource = self;
}

-(void)cancelled {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark
#pragma mark - UITableView
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.viewFeedback.tableFeedback) {
        return [self.arrayOfFeedbackItems count];
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.viewFeedback.tableFeedback) return 45;
    else return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (tableView == self.viewFeedback.tableFeedback) return 45;
    else return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBFeedbackCell *cell = [self.viewFeedback.tableFeedback dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        [self.viewFeedback.tableFeedback registerNib:[UINib nibWithNibName:@"CBFeedbackCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [self.viewFeedback.tableFeedback dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    if (tableView == self.viewFeedback.tableFeedback) {
        
        UILabel *lblMenuItem = (UILabel *)[cell viewWithTag:2];
        UIImageView *imgMenuItem = (UIImageView *)[cell viewWithTag:1];
        
        NSString *item = self.arrayOfFeedbackItems[indexPath.row];
        lblMenuItem.text = item;
        if ([item isEqualToString:@"General Feedback"]) {
            [imgMenuItem setImage:[UIImage imageNamed:@"star"]];
        } else if ([item isEqualToString:@"Something Isn't Working"]) {
            [imgMenuItem setImage:[UIImage imageNamed:@"broken"]];
        } else if ([item isEqualToString:@"Report Incorrect Information"]) {
            [imgMenuItem setImage:[UIImage imageNamed:@"info"]];
        } else if ([item isEqualToString:@"Rate CorpBoard"]) {
            [imgMenuItem setImage:[UIImage imageNamed:@"appstore2"]];
        }
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == self.userCat.tableCategories) {
//        UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
//        [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:YES fromMethod:YES];
//    } else if (tableView == self.viewExperienceList.tableExperience) {
//        if (indexPath.row == 0) {
//            [self addNewCorpExperience];
//        }
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == self.userCat.tableCategories) {
//        UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
//        [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:NO fromMethod:YES];
//    }
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    PFObject *obj = [self.arrayOfCorpExperience objectAtIndex:indexPath.row - 1];
//    [obj deleteInBackground];
//    [self.arrayOfCorpExperience removeObjectAtIndex:indexPath.row - 1];
//    [self.viewExperienceList.tableExperience reloadData];
//}

@end
