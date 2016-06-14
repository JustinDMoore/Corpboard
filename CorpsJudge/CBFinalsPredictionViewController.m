//
//  CBFinalsPredictionViewController.m
//  CorpsBoard
//
//  Created by Isaias Favela on 6/30/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBFinalsPredictionViewController.h"
#import <ParseUI/ParseUI.h>
#import "Configuration.h"
#import "IQKeyBoardManager.h"
#import "Corpsboard-Swift.h"

@interface CBFinalsPredictionViewController () {
    Configuration *config;
}

- (IBAction)btnNext_tapped:(id)sender;
- (IBAction)btnClose_tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end


@implementation CBFinalsPredictionViewController {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

-(void)next {
    
    if ([self.phase isEqualToString:@"pick"]) {

        self.tableCorps.allowsSelection = NO;
        self.phase = @"order";
        [self changeText:@"Order Finalists" forLabel:self.lblInstructions];
        [self.tableCorps setEditing:YES animated:YES];
        [self.tableCorps reloadData];
        
    } else if ([self.phase isEqualToString:@"order"]) {
        self.phase = @"score";
        [self changeText:@"Score Finalists" forLabel:self.lblInstructions];
        [self showRightButton:YES];
        [self.tableCorps setEditing:NO animated:YES];
        [self.tableCorps reloadData];
        
        [self.arrayOfScores removeAllObjects];
        
        for (int i = 0; i < 12; i++) {
            NSString *str = @"0";
            [self.arrayOfScores addObject:str];
        }
        
    } else if ([self.phase isEqualToString:@"score"]) {
        
        //check to make sure all scores are entered
        if ([self areAllScoresEntered]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit Prediction"
                                                            message:@"Are you sure you want to submit this prediction? You will not be able to edit it or resubmit another one."
                                                           delegate:self
                                                  cancelButtonTitle:@"NO"
                                                  otherButtonTitles:@"YES", nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Scores"
                                                            message:@"Not all scores have been entered."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    };
}

-(BOOL)areAllScoresEntered {
    
    if ([self.arrayOfScores count] != 12) return NO;
    
    for (NSString *score in self.arrayOfScores) {
        if ([score isEqualToString:@"0"]) return NO;
    }
    
    return YES;
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress dismiss];
    });
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    config = [[Configuration alloc] init];
    
    self.title = @"Finals Prediction";
    [self changeText:@"Select 12 Finalists" forLabel:self.lblInstructions];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    
    for (PFObject *corp in Server.sharedInstance.arrayOfWorldClass) {
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
    self.btnNext.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    CBMakeFinalsPrediction *viewPredict = [[[NSBundle mainBundle] loadNibNamed:@"CBMakeFinalsPrediction"
                                                                         owner:self
                                                                       options:nil]
                                           objectAtIndex:0];
    [self.view addSubview:viewPredict];
    
    [viewPredict show];
    [viewPredict setDelegate:self];
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

        [self.arrayOfScores replaceObjectAtIndex:indexPath.row withObject:textField.text];
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
                lblPlace.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1];
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

-(void)checkSelectedCorps {
    
    if ([self.phase isEqualToString:@"pick"]) {
        int count = (int)[self.arrayOfIndexes count];
        if (count < 12) {
            self.btnNext.hidden = YES;
            int needs = 12 - count;
            if (needs == 1) [self changeText:@"Select 1 Finalist" forLabel:self.lblInstructions];
            else [self changeText:[NSString stringWithFormat:@"Select %i Finalists", needs] forLabel:self.lblInstructions];
            self.navigationItem.rightBarButtonItem = nil;
        } else if (count == 12) {
            [self changeText:@"Select Next" forLabel:self.lblInstructions];
            [self showRightButton:NO];
        }
    }
}

-(void)showRightButton:(BOOL)done {
 
    if (self.btnNext.hidden) {
        self.btnNext.hidden = NO;
        
        self.btnNext.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        [UIView animateWithDuration:.3
                              delay:0
             usingSpringWithDamping:.3
              initialSpringVelocity:10
                            options:0
                         animations:^{
                             self.btnNext.transform = CGAffineTransformIdentity;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
    if (done) {
        [self.btnNext setImage:[UIImage imageNamed:@"admin_done"]
                      forState:UIControlStateNormal];
    } else {
        [self.btnNext setImage:[UIImage imageNamed:@"arrowRight"]
                      forState:UIControlStateNormal];
    }
}

#pragma mark
#pragma mark - Actions
#pragma mark

- (IBAction)btnNext_tapped:(id)sender {
    
    [self next];
}

- (IBAction)btnClose_tapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark - UIAlertView Delegate
#pragma mark

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) { //submit prediction and close
        
        [self dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
                [KVNProgress showSuccess];
                if ([self.delegate respondsToSelector:@selector(predictionMade)]) {
                    [self.delegate predictionMade];
                }
            });
        }];
        
        PFUser *user = [PFUser currentUser];
        [user setObject:[NSNumber numberWithBool:YES] forKey:@"predictionEntered"];
        [user saveEventually];
        
        for (int i = 0; i < 12; i++) {
            PFObject *corps = self.arrayOfIndexes[i];
            NSString *score = self.arrayOfScores[i];
            
            PFObject *predictionScore = [PFObject objectWithClassName:@"Predictions"];
            [predictionScore setObject:corps forKey:@"corps"];
            [predictionScore setObject:score forKey:@"score"];
            [predictionScore setObject:[NSNumber numberWithInt:i+1] forKey:@"placement"];
            [predictionScore setObject:[PFUser currentUser] forKey:@"user"];
            [predictionScore setObject:corps[@"corpsName"] forKey:@"corpName"];
            [predictionScore saveEventually];

        }
    }
}

#pragma mark
#pragma mark - Helpers
#pragma mark

-(void)changeText:(NSString *)text forLabel:(UILabel *)label {
    
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.35;
    [label.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    // This will fade:
    label.text = text;
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

-(NSMutableArray *)arrayOfScores {
    if (!_arrayOfScores) {
        _arrayOfScores = [[NSMutableArray alloc] init];
    }
    return _arrayOfScores;
}

-(NSMutableDictionary *)dictOfCorps {
    if (!_dictOfCorps) {
        _dictOfCorps = [[NSMutableDictionary alloc] init];
    }
    return _dictOfCorps;
}

@end
