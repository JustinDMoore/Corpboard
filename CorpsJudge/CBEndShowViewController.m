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
@property (nonatomic, assign) id currentResponder;

- (IBAction)btnCancel_tapped:(id)sender;
- (IBAction)btnShowRainedOut_tapped:(id)sender;

@end

@implementation CBEndShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableCorps.estimatedRowHeight = 95;
    self.tableCorps.rowHeight = UITableViewAutomaticDimension;
    self.tableCorps.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.lblShowName.text = self.show[@"showName"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEE, MMM d"];
    
    NSString *dateString = [format stringFromDate:self.show[@"showDate"]];
    
    self.lblShowLocationAndDate.text = [NSString stringWithFormat:@"%@ - %@", self.show[@"showLocation"], dateString];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [singleTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTap];
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
#pragma mark - UITextField Delegates
#pragma mark

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

int previouslen;
bool backspaced;

-(void)textFieldDidChange:(UITextField *)theTextField {
    
    if (theTextField.text.length < previouslen) {
        backspaced = YES;
    }
    
    if([theTextField.text hasSuffix:@"."]) {
        if (theTextField.text.length == 2) {
            
            NSRange ran = NSMakeRange(0, 1);
            NSString *txt = [theTextField.text substringWithRange:ran];
            theTextField.text = txt;
            return;
        }
    }
    
    if (theTextField.text.length == 3) {
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"."];
        NSRange range = [theTextField.text rangeOfCharacterFromSet:cset];
        if (range.location == NSNotFound) {
            NSRange range = NSMakeRange(0, 2);
            NSRange range2 = NSMakeRange(1, 1);
            NSString *one = [theTextField.text substringWithRange:range];
            NSString *two = [theTextField.text substringWithRange:range2];
            theTextField.text = [NSString stringWithFormat:@"%@.%@", one, two];
        }
    }
    
    if (theTextField.text) {
        NSString *regex = @"^[0-9]{0,2}[\\.]{0,1}[0-9]{0,2}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![pred evaluateWithObject:theTextField.text])
        { // Error, input not matching! Remove last added character.
            int len = (int)theTextField.text.length-((theTextField.text.length-1 == 3) ? 2 : 1);
            theTextField.text = [theTextField.text substringWithRange:NSMakeRange(0, len)];
            // Now checks if the new length, i.e. the length when the last digit has been deleted is 3, which means that the decimal dot is the last character. If so remove 2 instead of only 1 character!
        }
        else
        { // OKay here, do whatever
            if (!backspaced) {
                if(theTextField.text.length == 2) // Add decimal dot if two digits have been entered!
                {
                    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"."];
                    NSRange range = [theTextField.text rangeOfCharacterFromSet:cset];
                    if (range.location == NSNotFound) {
                        theTextField.text = [NSString stringWithFormat:@"%@.", theTextField.text];
                    }
                }
            }
        }
    }
    
    previouslen = (int)theTextField.text.length;
    backspaced = NO;
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    CGPoint location = [textField.superview convertPoint:textField.center toView:self.tableCorps];
    
    NSIndexPath *indexPath = [self.tableCorps indexPathForRowAtPoint:location];
    
    if (textField.text.length == 1) textField.text = @"";
    if (textField.text.length == 2) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @".00"];
    if (textField.text.length == 3) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @"00"];
    if (textField.text.length == 4) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @"0"];
    
    PFObject *score;
    
    if (indexPath.section == 0) {
        score = [self.arrayOfWorldClassScores objectAtIndex:indexPath.row];
    
    } else if (indexPath.section == 1) {
        score = [self.arrayOfOpenClassScores objectAtIndex:indexPath.row];
    }
    
    switch (textField.tag) {
        case 4: // guard
            score[@"colorguardScore"] = textField.text;
            break;
        case 5: // brass
            score[@"hornlineScore"] = textField.text;
            break;
        case 6: // percussion
            score[@"percussionScore"] = textField.text;
            break;
        case 7: // total
            score[@"score"] = textField.text;
            break;
    }
}

#pragma mark
#pragma mark - UITableView Delegates
#pragma mark

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95;
}

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
    UITextField *txtColorguard = (UITextField *)[cell viewWithTag:6];
    UITextField *txtBrass = (UITextField *)[cell viewWithTag:5];
    UITextField *txtPercussion = (UITextField *)[cell viewWithTag:7];
    UITextField *txtOverall = (UITextField *)[cell viewWithTag:4];

    [cell setUserInteractionEnabled:YES];
    
    txtColorguard.delegate = self;
    [txtColorguard setUserInteractionEnabled:YES];
    [txtColorguard addTarget:self
             action:@selector(textFieldDidChange:)
   forControlEvents:UIControlEventEditingChanged];
    
    txtBrass.delegate = self;
    [txtBrass setUserInteractionEnabled:YES];
    [txtBrass addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];

    txtPercussion.delegate = self;
    [txtPercussion setUserInteractionEnabled:YES];
    [txtPercussion addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
    txtOverall.delegate = self;
    [txtOverall setUserInteractionEnabled:YES];
    [txtOverall addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
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
