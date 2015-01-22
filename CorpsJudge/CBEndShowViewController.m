//
//  CBEndShowViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 1/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBEndShowViewController.h"

@interface CBEndShowViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblShowName;
@property (weak, nonatomic) IBOutlet UILabel *lblShowLocationAndDate;
@property (weak, nonatomic) IBOutlet UIButton *btnShowRainedOut;
@property (weak, nonatomic) IBOutlet UITableView *tableCorps;

- (IBAction)btnCancel_tapped:(id)sender;
- (IBAction)btnShowRainedOut_tapped:(id)sender;

@end

@implementation CBEndShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableCorps.estimatedRowHeight = 95;
    self.tableCorps.rowHeight = UITableViewAutomaticDimension;
    
    self.lblShowName.text = self.show[@"showName"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEE, MMM d"];
    
    NSString *dateString = [format stringFromDate:self.show[@"showDate"]];
    
    self.lblShowLocationAndDate.text = [NSString stringWithFormat:@"%@ - %@", self.show[@"showLocation"], dateString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancel_tapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnShowRainedOut_tapped:(id)sender {
}

#pragma mark
#pragma mark - UITableView Delegates
#pragma mark

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"World Class";
        case 1:
            return @"Open Class";
        default:
            return @"Error";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            if ([self.arrayOfWorldClassScores count]) return [self.arrayOfWorldClassScores count];
            else return 0;
        case 1:
            if ([self.arrayOfOpenClassScores count]) return [self.arrayOfOpenClassScores count];
            else return 0;
        default: return 0;
    }
}

BOOL finished = NO;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"score"];
    
    UILabel *lblPosition = (UILabel *)[cell viewWithTag:1];
    UILabel *lblCorpsName = (UILabel *)[cell viewWithTag:2];
    UIButton *btnRained = (UIButton *)[cell viewWithTag:3];
    UITextField *txtColorguard = (UITextField *)[cell viewWithTag:4];
    UITextField *txtBrass = (UITextField *)[cell viewWithTag:5];
    UITextField *txtPercussion = (UITextField *)[cell viewWithTag:6];
    UITextField *txtOverall = (UITextField *)[cell viewWithTag:7];

    PFObject *corps;
    PFObject *score;
    
    if ([indexPath section] == 0) {
        if ([self.arrayOfWorldClassScores count]) score = [self.arrayOfWorldClassScores objectAtIndex:[indexPath row]];
    } else {
        if ([self.arrayOfOpenClassScores count]) score = [self.arrayOfOpenClassScores objectAtIndex:[indexPath row]];
    }
    if (score) {
        corps = score[@"corps"];

        lblCorpsName.text = corps[@"corpsName"];
        if (finished) {
            lblPosition.text = [NSString stringWithFormat:@"%li", indexPath.row + 1];
        } else {
            lblPosition.text = @"-";
        }

        NSNumber *totalscore = score[@"score"];
        NSNumber *brassScore = score[@"hornlineScore"];
        NSNumber *colorguardScore = score[@"colorguardScore"];
        NSNumber *percussionScore = score[@"percussionScore"];
        
        if (totalscore) {
            txtOverall.text = [NSString stringWithFormat:@"%@", totalscore];
        } else {
            txtOverall.text = @"";
        }
        
        if (brassScore) {
            txtBrass.text = [NSString stringWithFormat:@"%@", brassScore];
        } else {
            txtBrass.text = @"";
        }
        
        if (colorguardScore) {
            txtColorguard.text = [NSString stringWithFormat:@"%@", colorguardScore];
        } else {
            txtColorguard.text = @"";
        }
        
        if (percussionScore) {
            txtPercussion.text = [NSString stringWithFormat:@"%@", percussionScore];
        } else {
            txtPercussion.text = @"";
        }
    }

    return cell;
}


-(NSMutableArray *)arrayOfWorldClassScores {
    if (!_arrayOfWorldClassScores) {
        _arrayOfWorldClassScores = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldClassScores;
}

-(NSMutableArray *)arrayOfOpenClassScores {
    if (!_arrayOfOpenClassScores) {
        _arrayOfOpenClassScores = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenClassScores;
}

@end
