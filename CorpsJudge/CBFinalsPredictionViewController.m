//
//  CBFinalsPredictionViewController.m
//  CorpsBoard
//
//  Created by Isaias Favela on 6/30/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBFinalsPredictionViewController.h"
#import "CBSingle.h"
#import <ParseUI/ParseUI.h>
#import "Configuration.h"
#import "SlideNavigationController.h"
#import "IQKeyBoardManager.h"

@interface CBFinalsPredictionViewController () {
    Configuration *config;
}
@end


@implementation CBFinalsPredictionViewController {
    CBSingle *data;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.rightBarButtonItem = nil;

}

-(void)showRightButton:(BOOL)done {
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    if (done) {
        UIImage *nextImage = [UIImage imageNamed:@"admin_done"];
        [btnNext setBackgroundImage:nextImage forState:UIControlStateNormal];
    } else {
        UIImage *nextImage = [UIImage imageNamed:@"arrowRight"];
        [btnNext setBackgroundImage:nextImage forState:UIControlStateNormal];
    }
    
    [btnNext addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    btnNext.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:btnNext] ;
    self.navigationItem.rightBarButtonItem = nextButton;
}

-(void)next {
    
    if ([self.phase isEqualToString:@"pick"]) {

        self.tableCorps.allowsSelection = NO;
        self.phase = @"order";
        self.title = @"Order Finalists";
        [self.tableCorps setEditing:YES animated:YES];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableCorps scrollToRowAtIndexPath:path
                               atScrollPosition:UITableViewScrollPositionTop
                                       animated:YES];
        [self.tableCorps reloadData];
        
    } else if ([self.phase isEqualToString:@"order"]) {
        self.phase = @"score";
        self.title = @"Score Finalists";
        [self showRightButton:YES];
        [self.tableCorps setEditing:NO animated:YES];
        [self.tableCorps reloadData];
        
    } else if ([self.phase isEqualToString:@"score"]) {
        
    };
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    data = [CBSingle data];
    config = [[Configuration alloc] init];
    
    self.title = @"Select 12 Finalists";
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    
    for (PFObject *corp in data.arrayOfWorldClass) {
        [self.dictOfCorps setObject:@"NO" forKey:corp[@"corpsName"]];
        [self.arrayOfCorps addObject:corp];
    }
    self.phase = @"pick";
    self.tableCorps.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableCorps reloadData];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [singleTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTap];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UITextField Delegates
#pragma mark

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSString *txt = textField.text;
    textField.text = nil;
    textField.text = txt;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.currentResponder = textField;
}

int previouslen;
bool backspaced;

-(void)textFieldDidChange:(UITextField *)theTextField {
    
    if (theTextField) {
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
            NSString *regex;
            if (theTextField.tag == 4) regex = @"^[0-9]{0,2}[\\.]{0,1}[0-9]{0,3}$";
            else regex = @"^[0-9]{0,2}[\\.]{0,1}[0-9]{0,2}$";
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
}

- (void)resignOnTap:(id)iSender {
    
    if (self.currentResponder) {
        [self.currentResponder resignFirstResponder];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField) {
        CGPoint location = [textField.superview convertPoint:textField.center toView:self.tableCorps];
        
        NSIndexPath *indexPath = [self.tableCorps indexPathForRowAtPoint:location];
        
        if (textField.text.length == 1) textField.text = @"";
        if (textField.text.length == 2) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @".00"];
        if (textField.text.length == 3) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @"00"];
        if (textField.text.length == 4) textField.text = [NSString stringWithFormat:@"%@%@", textField.text, @"0"];

    }
}

#pragma mark
#pragma mark - UITableView Methods
#pragma mark

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Your Top 12";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.phase isEqualToString:@"pick"]) return [self.arrayOfCorps count];
    else if ([self.phase isEqualToString:@"order"]) return [self.arrayOfIndexes count];
    else if ([self.phase isEqualToString:@"score"]) return [self.arrayOfIndexes count];
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"corp"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PFImageView *imgLogo = (PFImageView *)[cell viewWithTag:1];
    UILabel *lblName = (UILabel *)[cell viewWithTag:2];
    UILabel *lblPlace = (UILabel *)[cell viewWithTag:3];
    UITextField *txtScore = (UITextField *)[cell viewWithTag:4];
    txtScore.delegate = self;
    [txtScore setKeyboardAppearance:UIKeyboardAppearanceDark];
    [tableView setUserInteractionEnabled:YES];
    [txtScore setUserInteractionEnabled:YES];
    [txtScore setUserInteractionEnabled:YES];
    [txtScore addTarget:self
             action:@selector(textFieldDidChange:)
   forControlEvents:UIControlEventEditingChanged];
    
    NSMutableArray *array;
    if ([self.phase isEqualToString:@"pick"]) array = self.arrayOfCorps;
    else if ([self.phase isEqualToString:@"order"]) array = self.arrayOfIndexes;
    else if ([self.phase isEqualToString:@"score"]) array = self.arrayOfIndexes;
    
    if ([array count]) {
        PFObject *corp = array[indexPath.row];
        
        if (corp) {
            
            PFFile *imageFile = corp[@"logo"];
            if (imageFile) {
                [imgLogo setFile:imageFile];
                [imgLogo loadInBackground];
            }
            
            lblName.text = corp[@"corpsName"];
            
            if ([self.phase isEqualToString:@"pick"]) {
                txtScore.hidden = YES;
                lblPlace.text = @"";
                NSString *str = [self.dictOfCorps objectForKey:corp[@"corpsName"]];
                if ([str isEqualToString:@"YES"]) {
                    [self selectCell:cell atIndexPath:indexPath onOrOff:YES fromMethod:NO];
                } else {
                    [self selectCell:cell atIndexPath:indexPath onOrOff:NO fromMethod:NO];
                }
            } else if ([self.phase isEqualToString:@"order"]) {
                txtScore.hidden = YES;
                lblPlace.hidden = NO;
                lblPlace.text = [NSString stringWithFormat:@"%lu", indexPath.row + 1];
                [self selectCell:cell atIndexPath:indexPath onOrOff:NO fromMethod:NO];
            } else if ([self.phase isEqualToString:@"score"]) {
                lblPlace.hidden = NO;
                txtScore.hidden = NO;
                [self selectCell:cell atIndexPath:indexPath onOrOff:NO fromMethod:NO];
            }
        }
    } else {
        txtScore.hidden = YES;
        lblPlace.text = @"";
        lblName.text = @"";
        imgLogo.image = nil;
    }
    
    return cell;
}

-(void)selectCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)path onOrOff:(BOOL)on fromMethod:(BOOL)method {
    
    if (on) {
        if ([self.arrayOfIndexes count] < 12) {
            if (!method) [self.tableCorps selectRowAtIndexPath:path animated:NO scrollPosition: UITableViewScrollPositionNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            PFObject *corp = self.arrayOfCorps[path.row];
            if ([self.dictOfCorps objectForKey:corp[@"corpsName"]]) {
                [self.dictOfCorps setObject:@"YES" forKey:corp[@"corpsName"]];
                if ([self.phase isEqualToString:@"pick"]) {
                    if (![self.arrayOfIndexes containsObject:corp]) {
                        [self.arrayOfIndexes addObject:corp];
                    }
                }
            }
        }
    } else {
        if (!method) [self.tableCorps deselectRowAtIndexPath:path animated:NO];
        cell.accessoryType = UITableViewCellAccessoryNone;
        PFObject *corp = self.arrayOfCorps[path.row];
        if ([self.dictOfCorps objectForKey:corp[@"corpsName"]]) {
            [self.dictOfCorps setObject:@"NO" forKey:corp[@"corpsName"]];
            if ([self.phase isEqualToString:@"pick"]) {
                if ([self.arrayOfIndexes containsObject:corp]) {
                    [self.arrayOfIndexes removeObject:corp];
                }
            }
        }
    }
    
    [self checkSelectedCorps];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:YES fromMethod:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectCell:tableViewCell atIndexPath:indexPath onOrOff:NO fromMethod:YES];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    PFObject *corpToMove = [self.arrayOfIndexes objectAtIndex:sourceIndexPath.row];
    [self.arrayOfIndexes removeObjectAtIndex:sourceIndexPath.row];
    [self.arrayOfIndexes insertObject:corpToMove atIndex:destinationIndexPath.row];
    [self.tableCorps reloadData];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark
#pragma mark - Properties
#pragma mark

-(NSMutableArray *)arrayOfCorps {
    if (!_arrayOfCorps) {
        _arrayOfCorps = [[NSMutableArray alloc] init];
    }
    return _arrayOfCorps;
}

-(NSMutableArray *)arrayOfIndexes {
    if (!_arrayOfIndexes) {
        _arrayOfIndexes = [[NSMutableArray alloc] init];
    }
    return _arrayOfIndexes;
}

-(NSMutableDictionary *)dictOfCorps {
    if (!_dictOfCorps) {
        _dictOfCorps = [[NSMutableDictionary alloc] init];
    }
    return _dictOfCorps;
}

-(void)checkSelectedCorps {
    int count = (int)[self.arrayOfIndexes count];
    if (count < 12) {
        int needs = 12 - count;
        if (needs == 1) self.title = @"Select 1 Finalist";
        else self.title = [NSString stringWithFormat:@"Select %i Finalists", needs];
        self.navigationItem.rightBarButtonItem = nil;
    } else if (count == 12) {
        self.title = @"Select Next";
        [self showRightButton:NO];
    }
}

@end
