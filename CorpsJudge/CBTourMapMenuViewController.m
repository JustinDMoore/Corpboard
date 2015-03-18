//
//  CBTourMapMenuViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 3/16/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBTourMapMenuViewController.h"
#import "CBSingle.h"
#import "CBAppDelegate.h"

@interface CBTourMapMenuViewController ()

@end

CBAppDelegate *del;
CBSingle *data;

@implementation CBTourMapMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    del = [UIApplication sharedApplication].delegate;
    data = [CBSingle data];
    self.tableMenu.separatorColor = [UIColor lightGrayColor];
    [SlideNavigationController sharedInstance].portraitSlideOffset = 165;
}

-(void)refreshMenu {
    
    [self.tableMenu reloadData];
}

#pragma mark
#pragma mark - UITableView Delegate/Datasource
#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 1;
    else return [data.arrayOfAllCorps count] + 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableMenu.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableMenu dequeueReusableCellWithIdentifier:@"rightMenuCell"];

    UILabel *lblMenuTitle = (UILabel *)[cell viewWithTag:1];
    
    switch (indexPath.section) {
        case 0:
            lblMenuTitle.text = @"Satellite";
            break;
        case 1:
            if (indexPath.row == 0) lblMenuTitle.text = @"All Shows";
            else {
                PFObject *corps = data.arrayOfAllCorps[indexPath.row - 1];
                lblMenuTitle.text = corps[@"corpsName"];
            }
            break;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { //settings
        if (indexPath.row == 0) { //satellite
            if (!self.satellite) {
                self.satellite = YES;
                [self selectCell:YES AtIndexPath:indexPath];
                [self.delegate toggleSatellite:YES];
            } else {
                self.satellite = NO;
                [self selectCell:NO AtIndexPath:indexPath];
                [self.delegate toggleSatellite:NO];
            }
        }
    } else {
        [self selectCell:YES AtIndexPath:indexPath];
        if (indexPath.row == 0) { //all shows
            [self.delegate filterShowByCorps:nil];
        } else {
            PFObject *corps = data.arrayOfAllCorps[indexPath.row - 1];
            [self.delegate filterShowByCorps:corps];
        }
    }
    [self closeMenu];
}

-(void)selectCell:(BOOL)select AtIndexPath:(NSIndexPath *)indexPath; {
    
    UITableViewCell *cell = [self.tableMenu cellForRowAtIndexPath:indexPath];
    UILabel *lbl = (UILabel *)[cell viewWithTag:1];
    if (select) lbl.textColor = del.appTintColor;
    else {
        lbl.textColor = [UIColor whiteColor];
        [self.tableMenu deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)closeMenu {
    
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
    }];
}


@end
