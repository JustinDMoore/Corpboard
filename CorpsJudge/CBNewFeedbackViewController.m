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
        return 4;
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
        UIImageView *imgMenuItem = (UIImageView *)[cell]
        
        cell.textLabel.text = (NSString *)[self.userCat.arrayOfCategories objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        NSString *str = [self.userCat.dict objectForKey:cell.textLabel.text];
        if ([str isEqualToString:@"YES"]) {
            [self selectCell:cell atIndexPath:indexPath onOrOff:YES fromMethod:NO];
        } else {
            [self selectCell:cell atIndexPath:indexPath onOrOff:NO fromMethod:NO];
        }
    } else if (tableView == self.viewExperienceList.tableExperience) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"    Add Experience";
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 15, 15)];
            //UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, (CGRectGetMidY(cell.frame) / 2) - (15 / 2), 15, 15)];
            imageView.backgroundColor=[UIColor clearColor];
            [imageView setImage:[UIImage imageNamed:@"Add"]];
            [cell addSubview:imageView];
        } else {
            PFObject *exp = [self.arrayOfCorpExperience objectAtIndex:indexPath.row - 1];
            NSString *str = [NSString stringWithFormat:@"%@, %@ - %@", exp[@"corpsName"], exp[@"year"], exp[@"position"]];
            cell.textLabel.text = str;
            
        }
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.viewExperienceList.tableExperience) {
        if (indexPath.row == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

-(void)selectCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)path onOrOff:(BOOL)on fromMethod:(BOOL)method {
    
    if (on) {
        if (!method) [self.userCat.tableCategories selectRowAtIndexPath:path animated:NO scrollPosition: UITableViewScrollPositionNone];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if ([self.userCat.dict objectForKey:cell.textLabel.text]) {
            [self.userCat.dict setObject:@"YES" forKey:cell.textLabel.text];
        }
        
        //check to see if it's staff or former staff and deselect the opposite one
        if ([cell.textLabel.text isEqualToString:@"Staff"]) {
            NSIndexPath *ip = [NSIndexPath indexPathForItem:path.row+1 inSection:0];
            UITableViewCell *c = [self.userCat.tableCategories cellForRowAtIndexPath:ip];
            [self selectCell:c atIndexPath:ip onOrOff:NO fromMethod:NO];
        } else if ([cell.textLabel.text isEqualToString:@"Former Staff"]) {
            NSIndexPath *ip = [NSIndexPath indexPathForItem:path.row-1 inSection:0];
            UITableViewCell *c = [self.userCat.tableCategories cellForRowAtIndexPath:ip];
            [self selectCell:c atIndexPath:ip onOrOff:NO fromMethod:NO];
        }
        
        
    } else {
        if (!method) [self.userCat.tableCategories deselectRowAtIndexPath:path animated:NO];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([self.userCat.dict objectForKey:cell.textLabel.text]) {
            [self.userCat.dict setObject:@"NO" forKey:cell.textLabel.text];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.userCat.tableCategories) {
        UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:YES fromMethod:YES];
    } else if (tableView == self.viewExperienceList.tableExperience) {
        if (indexPath.row == 0) {
            [self addNewCorpExperience];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.userCat.tableCategories) {
        UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:NO fromMethod:YES];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *obj = [self.arrayOfCorpExperience objectAtIndex:indexPath.row - 1];
    [obj deleteInBackground];
    [self.arrayOfCorpExperience removeObjectAtIndex:indexPath.row - 1];
    [self.viewExperienceList.tableExperience reloadData];
}

@end
