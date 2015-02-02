//
//  CBJudgeViewController.m
//  CorpsBoard
//
//  Created by Justin Moore on 6/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBJudgeViewController.h"
#import "CBSingle.h"
#import "UserScore.h"

PFObject *favDrumsW;
PFObject *favHornlineW;
PFObject *favGuardW;
PFObject *favCorpsW;
PFObject *loudHornlineW;

PFObject *favDrumsO;
PFObject *favHornlineO;
PFObject *favGuardO;
PFObject *favCorpsO;
PFObject *loudHornlineO;

NSInteger currentRowIndex;

CBSingle *data;

@interface CBJudgeViewController ()

typedef enum : int {
    catdrums, cathornline, catguard, catcorps, catloud
} category;

typedef enum : int {
    phaseScore = 0,
    phaseBestdrums = 1,
    phaseBesthornline = 2,
    phaseLoudesthornline = 3,
    phaseBestguard = 4,
    phaseFavorite = 5,
    phaseSummary
} phase;

@property (nonatomic) category cat;

//WScores and OScores are only to save user scores once they click 'next' and the table cells are lost
@property (nonatomic, strong) NSMutableArray *WScores;
@property (nonatomic, strong) NSMutableArray *OScores;

@property (weak, nonatomic) IBOutlet UITableView *tableCorps;
@property (nonatomic, strong) UITextView *currentTextView;
@property (nonatomic, assign) id currentResponder;
@property (weak, nonatomic) IBOutlet UILabel *lblInstructions;
@property (nonatomic, assign) phase scorePhase;
- (IBAction)btnCancel_clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

- (IBAction)Submit:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;



@end

@implementation CBJudgeViewController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    UIImage *backBtnImage = [UIImage imageNamed:@"BackArrow"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    data = [CBSingle data];
    
    self.title = @"Review Show";

    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    [self.tabBar setSelectedItem:item];
    
    NSString *mystring1 = @"To keep votes accurate, do not review this show if you did not attend.";
    NSString *mystring2 = @"Corps that are not scored will not be included.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Review Show"
                                                    message:[NSString stringWithFormat:@"\n%@\n\n%@", mystring1,mystring2]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
 
    [alert show];
    
    self.OScores = [[NSMutableArray alloc] init];//WithCapacity:[self.arrayOfOpenClassScores count]];
    self.WScores = [[NSMutableArray alloc] init];//WithCapacity:[self.arrayOfWorldClassScores count]];
    
    if ([self.arrayOfWorldClassScores count]) {
        for (int i = 0; i < [self.arrayOfWorldClassScores count]; i++ ) {
            
            PFObject *score = [self.arrayOfWorldClassScores objectAtIndex:i];
            UserScore *us = [[UserScore alloc] init];
            us.corps = score[@"corps"];
            us.score = 0;
            [self.WScores addObject:us];
            //[self.WScores addObject:@"0"];
        }
    }

    if ([self.arrayOfOpenClassScores count]) {
        for (int i = 0; i < [self.arrayOfOpenClassScores count]; i++ ) {
            
            PFObject *score = [self.arrayOfOpenClassScores objectAtIndex:i];
            UserScore *us = [[UserScore alloc] init];
            us.corps = score[@"corps"];
            us.score = 0;
            [self.OScores addObject:us];
            
            //[self.OScores addObject:@"0"];
        }
    }
    
    
     favDrumsW = nil;
     favHornlineW = nil;
     favGuardW = nil;
     favCorpsW = nil;
     loudHornlineW = nil;
    
     favDrumsO = nil;
     favHornlineO = nil;
     favGuardO = nil;
     favCorpsO = nil;
     loudHornlineO = nil;
    
    self.tableCorps.allowsSelection = YES;
    self.scorePhase = phaseScore;
    self.tableCorps.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.activity.hidden = NO;
    //self.tableCorps.hidden = YES;
    //[self.activity startAnimating];
   
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [singleTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTap];

    [self.tableCorps reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.tableCorps.contentInset = contentInsets;
        self.tableCorps.scrollIndicatorInsets = contentInsets;
    }];
    
    UITextField *txt = (UITextField*)self.currentResponder;
    CGPoint location = [txt.superview convertPoint:txt.center toView:self.tableCorps];
    NSIndexPath *indexPath = [self.tableCorps indexPathForRowAtPoint:location];
    
    [self.tableCorps scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableCorps.contentInset = UIEdgeInsetsZero;
    self.tableCorps.scrollIndicatorInsets = UIEdgeInsetsZero;
}

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
    
    if (indexPath.section == 0) {
        UserScore *score = [self.WScores objectAtIndex:indexPath.row];
        score.score = [textField.text doubleValue];
        //[self.WScores replaceObjectAtIndex:indexPath.row withObject:textField.text];
        //[self.WScores setObject:textField.text forKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]];
    } else if (indexPath.section == 1) {
        UserScore *score = [self.OScores objectAtIndex:indexPath.row];
        score.score = [textField.text doubleValue];
        //[self.OScores replaceObjectAtIndex:indexPath.row withObject:textField.text];
        //[self.OScores setObject:textField.text forKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancel_clicked:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)areAllScoresEntered {
    //check to make sure all corps have a score
    BOOL ready = YES;
    for (int section = 0; section < [self.tableCorps numberOfSections]; section++) {
        for (int row = 0; row < [self.tableCorps numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [self.tableCorps cellForRowAtIndexPath:cellPath];
            UITextField *text = (UITextField *)[cell viewWithTag:2];
            if ([text.text isEqualToString:@""]) {
                ready = NO;
            }
        }
    }
    return ready;
}

-(void)prepareAndSubmitScores {
    
    [self submitUserScores];
    [self submitUserFavorites];
    [self voted];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Your vote has been submitted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)voted {
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userObjectId"] = [PFUser currentUser].objectId;
    [PFCloud callFunctionInBackground:@"incrementReviewsByUser" withParameters:params];
    
    if ([self.delegate respondsToSelector:@selector(voted)]) {
        [self.delegate voted];
    }
}

-(NSString *)getCategory:(category)cat {
    
    switch (cat) {
        case catcorps: return @"Favorite Corps";
        case catdrums: return @"Favorite Drums";
        case catguard: return @"Favorite Color Guard";
        case cathornline: return @"Favorite Brass";
        case catloud: return @"Loudest Brass";
    }
}

-(void)submitFavorite:(category)cat forWorldClass:(BOOL)isWorld forCorps:(PFObject *)corp {
    
    if (corp) {
        NSMutableArray *classArray;
        if (isWorld) {
            classArray = self.arrayOfWorldClassScores;
        } else {
            classArray = self.arrayOfOpenClassScores;
        }
        
        PFObject *favorite = [PFObject objectWithClassName:@"favorites"];
        favorite[@"category"] = [self getCategory:cat];
        favorite[@"show"] = self.show;
        favorite[@"showName"] = self.show[@"showName"];
        favorite[@"user"] = [PFUser currentUser];
        //PFObject *score = [classArray objectAtIndex:intClass];
        //PFObject *corps = score[@"corps"];
        favorite[@"corpsName"] = corp[@"corpsName"];
        favorite[@"corps"] = corp;
        favorite[@"isWorldClass"] = [NSNumber numberWithBool:isWorld];
        [favorite saveInBackground];
    }
}

-(void)submitUserFavorites {

    
    [self submitFavorite:catdrums
           forWorldClass:YES
                forCorps:favDrumsW];
    
    [self submitFavorite:cathornline forWorldClass:YES forCorps:favHornlineW];
    [self submitFavorite:catguard forWorldClass:YES forCorps:favGuardW];
    [self submitFavorite:catcorps forWorldClass:YES forCorps:favCorpsW];
    [self submitFavorite:catloud forWorldClass:YES forCorps:loudHornlineW];
    
    [self submitFavorite:catdrums forWorldClass:NO forCorps:favDrumsO];
    [self submitFavorite:cathornline forWorldClass:NO forCorps:favHornlineO];
    [self submitFavorite:catguard forWorldClass:NO forCorps:favGuardO];
    [self submitFavorite:catcorps forWorldClass:NO forCorps:favCorpsO];
    [self submitFavorite:catloud forWorldClass:NO forCorps:loudHornlineO];
    
}

- (void)submitUserScores {
    
    for (UserScore *us in self.WScores) {
        
        if (us.score > 0) {
            PFObject *score = [PFObject objectWithClassName:@"scores"];
            score[@"corps"] = us.corps;
            score[@"score"] = us.scoreString;
            score[@"show"] = self.show;
            score[@"corpsName"] = us.corps[@"corpsName"];
            score[@"isOfficial"] = [NSNumber numberWithBool:NO];
            score[@"user"] = [PFUser currentUser];
            score[@"isWorldClass"] = [NSNumber numberWithBool:YES];
            score[@"showDate"] = self.show[@"showDate"];
            
            [score saveInBackground];
        }
    }
    
    for (UserScore *us in self.OScores) {
        
        if (us.score > 0) {
            PFObject *score = [PFObject objectWithClassName:@"scores"];
            score[@"corps"] = us.corps;
            score[@"score"] = us.scoreString;
            score[@"show"] = self.show;
            score[@"corpsName"] = us.corps[@"corpsName"];
            score[@"isOfficial"] = [NSNumber numberWithBool:NO];
            score[@"user"] = [PFUser currentUser];
            score[@"isWorldClass"] = [NSNumber numberWithBool:NO];
            score[@"showDate"] = self.show[@"showDate"];
            
            [score saveInBackground];
        }
    }
//    
//    PFObject *score = [PFObject objectWithClassName:@"scores"];
//    
//    [score setObject:corpsForScore forKey:@"corps"];
//    [score setObject:self.show forKey:@"show"];
//    score[@"score"] = corpsScore;
//    score[@"corpsName"] = corpsForScore[@"corpsName"];
//    score[@"isOfficial"] = [NSNumber numberWithBool:NO];
//    score[@"user"] = [PFUser currentUser];
//    score[@"isWorldClass"] = corpsForScore[@"isWorldClass"];
//    score[@"showDate"] = self.show[@"showDate"];
//    
//    [score saveInBackground];

}

- (IBAction)previousPhase:(id)sender {
    self.scorePhase--;
}

#pragma mark - TableView

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return @"World Class";
        case 1: return @"Open Class";
        default: return @"Error";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            if ([self.arrayOfWorldClassScores count]) {
                
                if (self.scorePhase == phaseSummary) {
                    return [self.arrayOfWorldClassScores count] + 5;
                } else {
                    return [self.arrayOfWorldClassScores count];
                }
            } else return 0;
            
        case 1:
            if ([self.arrayOfOpenClassScores count]) {
                
                if (self.scorePhase == phaseSummary) {
                    return [self.arrayOfOpenClassScores count] + 5;
                } else {
                    return [self.arrayOfOpenClassScores count];
                }
            } else return 0;
        default: return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.scorePhase) {
        case phaseScore:
            break;
        case phaseBestdrums:
            if (indexPath.section == 0) {
                UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                if (favDrumsW == us.corps) {
                    favDrumsW = nil;
                } else {
                    favDrumsW = us.corps;
                }
            }
            
            if (indexPath.section == 1) {
                UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                if (favDrumsO == us.corps) {
                    favDrumsO = nil;
                } else {
                    favDrumsO = us.corps;
                }
            }

            break;
        case phaseBestguard:
            if (indexPath.section == 0) {
                UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                if (favGuardW == us.corps) {
                    favGuardW = nil;
                } else {
                    favGuardW = us.corps;
                }
            }
            
            if (indexPath.section == 1) {
                UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                if (favGuardO == us.corps) {
                    favGuardO = nil;
                } else {
                    favGuardO = us.corps;
                }
            }
            break;
        case phaseBesthornline:
            if (indexPath.section == 0) {
                UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                if (favHornlineW == us.corps) {
                    favHornlineW = nil;
                } else {
                    favHornlineW = us.corps;
                }
            }
            
            if (indexPath.section == 1) {
                UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                if (favHornlineO == us.corps) {
                    favHornlineO = nil;
                } else {
                    favHornlineO = us.corps;
                }
            }
            break;
        case phaseFavorite:
            if (indexPath.section == 0) {
                UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                if (favCorpsW == us.corps) {
                    favCorpsW = nil;
                } else {
                    favCorpsW = us.corps;
                }
            }
            
            if (indexPath.section == 1) {
                UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                if (favCorpsO == us.corps) {
                    favCorpsO = nil;
                } else {
                    favCorpsO = us.corps;
                }
            }
            break;
        case phaseLoudesthornline:
            if (indexPath.section == 0) {
                UserScore *us = [self.WScores objectAtIndex:indexPath.row];
                if (loudHornlineW == us.corps) {
                    loudHornlineW = nil;
                } else {
                    loudHornlineW = us.corps;
                }
            }
            
            if (indexPath.section == 1) {
                UserScore *us = [self.OScores objectAtIndex:indexPath.row];
                if (loudHornlineO == us.corps) {
                    loudHornlineO = nil;
                } else {
                    loudHornlineO = us.corps;
                }
            }
            break;
            
        default:
            break;
    }
    [self.tableCorps reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    //get the correct corps name
    UserScore *score;
    PFObject *corps;
    if ([indexPath section] == 0) {
        if ([self.WScores count]) {
            if (indexPath.row < [self.WScores count]) {
                if ([self.WScores count]) score = [self.WScores objectAtIndex:[indexPath row]];
            }
        }
    } else if ([indexPath section] == 1) {
        if ([self.OScores count]) {
            if (indexPath.row < [self.OScores count]) {
                if ([self.OScores count]) score = [self.OScores objectAtIndex:[indexPath row]];
            }
        }
    }
    
        if (score) corps = score.corps;
    
    //now we have the corps name for the row
    
    
    // what cell and content do we need
    
    if (self.scorePhase == phaseScore) {
        cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"score"];
        UITextField *text = (UITextField *)[cell viewWithTag:2];
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        text.delegate = self;
        [tableView setUserInteractionEnabled:YES];
        [cell setUserInteractionEnabled:YES];
        [text setUserInteractionEnabled:YES];
        [text addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
        NSString *scoreString;
        switch (indexPath.section) {
            case 0:
                if ([self.WScores count]) {
                    UserScore *score = [self.WScores objectAtIndex:indexPath.row];
                    scoreString = score.scoreString;
                    //scoreString = [self.WScores objectAtIndex:indexPath.row];
                    if (score.score == 0)  {
                        text.text = @"";
                    } else text.text = scoreString;
                }
                break;
            case 1:
                if ([self.OScores count]) {
                    UserScore *score = [self.OScores objectAtIndex:indexPath.row];
                    scoreString = score.scoreString;
                    //scoreString = [self.OScores objectAtIndex:indexPath.row];
                    if (score.score == 0)  {
                        text.text = @"";
                    } else text.text = scoreString;
                }
                break;
            default:
                text.text = @"Error";
                break;
        }
        label.text = corps[@"corpsName"];
        
    } else if (self.scorePhase == phaseSummary) {
        
        if (indexPath.section == 0) {
            if (indexPath.row + 1 <= [self.WScores count]) {
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"favorite"];
            } else {
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"caption"];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row + 1 <= [self.OScores count]) {
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"favorite"];
            } else {
                cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"caption"];
            }
        }
        
        NSString *blank = @"None selected";
        NSString *mainText;
        NSString *detailText;
        
        UIImageView *img = (UIImageView *)[cell viewWithTag:8];
        
        switch ([indexPath section]) {
            case 0: // world class
                if ([self.arrayOfWorldClassScores count]) {
                    if (indexPath.row < [self.arrayOfWorldClassScores count]) { //scores
                        mainText = corps[@"corpsName"];
                        UserScore *score = [self.WScores objectAtIndex:indexPath.row];
                        detailText = score.scoreString;
                        //detailText = [self.WScores objectAtIndex:indexPath.row];
                        NSString *s;
                        //s = [self.WScores objectAtIndex:indexPath.row];
                        s = detailText;
                        if (s) {
                            if ([s isEqualToString:@"0"] || ([s isEqualToString:@""]))
                                detailText = @"Not Scored";
                        } else detailText = s;
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count]) { //                       best drums
                        mainText = @"Best Percussion";
                        img.image = [UIImage imageNamed:@"drum"];
                        if (favDrumsW) {
                            detailText = favDrumsW[@"corpsName"];
                        } else {
                            detailText = blank;
                        }
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 1) { //                  best brass
                        mainText = @"Best Brass";
                        img.image = [UIImage imageNamed:@"horn"];
                        if (favHornlineW) {
                            detailText = favHornlineW[@"corpsName"];
                            
                        } else {
                            detailText = blank;
                        }
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 2) { //                     best guard
                        mainText = @"Best Color Guard";
                        img.image = [UIImage imageNamed:@"flag"];
                        if (favGuardW) {
                            detailText = favGuardW[@"corpsName"];
                        } else {
                            detailText = blank;
                        }
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 3) { //                    loudest brass
                        mainText = @"Loudest Brass";
                        img.image = [UIImage imageNamed:@"volume"];
                        if (loudHornlineW) {
                            detailText = loudHornlineW[@"corpsName"];
                        } else {
                            detailText = blank;
                        }
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 4) { //                   favorite corps
                        mainText = @"Favorite Show";
                        img.image = [UIImage imageNamed:@"heart"];
                        if (favCorpsW) {
                            detailText = favCorpsW[@"corpsName"];
                        } else {
                            detailText = blank;
                        }
                    } else {
//                        //cell.detailTextLabel.text = [self.WScores objectForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
//                        detailText = [self.WScores objectAtIndex:indexPath.row];
                    }
                    break;
                }
                
            case 1: // open class
                if ([self.arrayOfOpenClassScores count]) {
                    if (indexPath.row < [self.arrayOfOpenClassScores count]) {
                        mainText = corps[@"corpsName"];
                        UserScore *score = [self.OScores objectAtIndex:indexPath.row];
                        detailText = score.scoreString;
                        //detailText = [self.OScores objectAtIndex:indexPath.row];
                        NSString *s;
                        //s = [self.OScores objectAtIndex:indexPath.row];
                        s = detailText;
                        if (s) {
                            if ([s isEqualToString:@"0"] || ([s isEqualToString:@""]))
                                detailText = @"Not Scored";
                        } else detailText = s;
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count]) {
                        mainText = @"Best Percussion";
                        img.image = [UIImage imageNamed:@"drum"];
                        if (favDrumsO) {
                            detailText = favDrumsO[@"corpsName"];
                        } else {
                            detailText = blank;
                        }
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 1) {
                        mainText = @"Best Brass";
                        img.image = [UIImage imageNamed:@"horn"];
                        if (favHornlineO) {
                            detailText = favHornlineO[@"corpsName"];
                        } else {
                            detailText = blank;
                        }
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 2) {
                        mainText = @"Best Color Guard";
                        img.image = [UIImage imageNamed:@"flag"];
                        if (favGuardO) {
                            detailText = favGuardO[@"corpsName"];
                        } else {
                            detailText = blank;
                        }
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 3) {
                        mainText = @"Loudest Brass";
                        img.image = [UIImage imageNamed:@"volume"];
                        if (loudHornlineO) {
                            detailText = loudHornlineO[@"corpsName"];
                        } else {
                            detailText = blank;
                        }
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 4) {
                        mainText = @"Favorite Show";
                        img.image = [UIImage imageNamed:@"heart"];
                        if (favCorpsO) {
                            detailText = favCorpsO[@"corpsName"];
                        } else {
                            detailText = blank;
                        }
                    }
                    
                    break;
                default:
                    mainText = @"Main Error";
                    detailText =  @"Detail Error";
                    break;
                }
           }
        // for phase Summary only
        UILabel *lblPlacement = (UILabel *)[cell viewWithTag:5];
        UILabel *lblCorpName = (UILabel *)[cell viewWithTag:6];
        UILabel *lblDetail = (UILabel *)[cell viewWithTag:7];
        if (indexPath.section == 0) {
            if (indexPath.row + 1 <= [self.WScores count]) {
                lblPlacement.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
            } else {
                lblPlacement.text = @"";
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row + 1 <= [self.OScores count]) {
                lblPlacement.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
            } else {
                lblPlacement.text = @"";
            }
        }
        
        lblCorpName.text = mainText;
        lblDetail.text = detailText;
        
    } else { //end of phase summary, handles everything other than summary and score
        
        cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
        cell.textLabel.text = corps[@"corpsName"];
        UserScore *us;
        // set the checkmarks for world class
        if (indexPath.section == 0) {
            
            us = [self.WScores objectAtIndex:indexPath.row];
            
            switch (self.scorePhase) {
                case phaseScore:
                    //nothing
                    break;
                case phaseLoudesthornline:
                    if (loudHornlineW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseFavorite:
                    if (favCorpsW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBesthornline:
                    if (favHornlineW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestguard:
                    if (favGuardW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestdrums:
                    if (favDrumsW == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseSummary:
                    //nothing
                    break;
                default:
                    break;
            }
        }
        
        //check the checkmarks for open class
        if (indexPath.section == 1) {
            us = [self.OScores objectAtIndex:indexPath.row];
            switch (self.scorePhase) {
                case phaseScore:
                    //nothing
                    break;
                case phaseLoudesthornline:
                    if (loudHornlineO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseFavorite:
                    if (favCorpsO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBesthornline:
                    if (favHornlineO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestguard:
                    if (favGuardO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestdrums:
                    if (favDrumsO == us.corps) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                default:
                    break;
            }
            
        }
        
    }
//
//    
//    
//    PFObject *score;
//    if ([indexPath section] == 0) {
//        if (indexPath.row < [self.arrayOfWorldClassScores count]) {
//            if ([self.arrayOfWorldClassScores count]) score = [self.arrayOfWorldClassScores objectAtIndex:[indexPath row]];
//        }
//        
//    } else if ([indexPath section] == 1) {
//        if (indexPath.row < [self.arrayOfOpenClassScores count]) {
//            if ([self.arrayOfOpenClassScores count]) score = [self.arrayOfOpenClassScores objectAtIndex:[indexPath row]];
//        }
//    }
//    
//    if (score) {
//        PFObject *corps = score[@"corps"];
//        cell.textLabel.text = corps[@"corpsName"];
//        NSNumber *totalscore = score[@"score_Total"];
//        if (totalscore) {
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", totalscore];
//        } else {
//            //cell.detailTextLabel.text = @"";
//        }
//    }
    
    
    return cell;
}

-(void)setScorePhase:(phase)scorePhase {

    if (scorePhase < 0) scorePhase = 0;
    if (scorePhase > 6) scorePhase = 6;
    _scorePhase = scorePhase;

    switch (scorePhase) {
        case phaseScore:
            self.lblInstructions.text = @"What would you score the corps?";
            //self.btnNext.titleLabel.text = @"Next";
            break;
        case phaseBestdrums:
            self.lblInstructions.text = @"Who had the best percussion?";
            //self.btnNext.titleLabel.text = @"Next";
            break;
        case phaseBesthornline:
            self.lblInstructions.text = @"Who had the best brass?";
            //self.btnNext.titleLabel.text = @"Next";
            break;
        case phaseBestguard:
            self.lblInstructions.text = @"Who had the best color guard?";
            //self.btnNext.titleLabel.text = @"Next";
            break;
        case phaseLoudesthornline:
            self.lblInstructions.text = @"Who had the loudest brass?";
            //self.btnNext.titleLabel.text = @"Next";
            break;
        case phaseFavorite:
            self.lblInstructions.text = @"What was your favorite show?";
            //self.btnNext.titleLabel.text = @"Submit";
            break;
        case phaseSummary:
            self.lblInstructions.text = @"Your Review";
            break;
            
        default:
            self.lblInstructions.text = @"Error";
            break;
    }
    
    [self.tableCorps reloadData];
  
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
   [self.btnSubmit setTitle:@"Review" forState:UIControlStateNormal];
    switch (item.tag) {
        case 0: //score
            self.scorePhase = phaseScore;
            break;
        case 1: //hornline
            self.scorePhase = phaseBesthornline;
            break;
        case 2: //Percussion
            self.scorePhase = phaseBestdrums;
            break;
        case 3: //Colorguard
            self.scorePhase = phaseBestguard;
            break;
        case 4: //Loudest
            self.scorePhase = phaseLoudesthornline;
            break;
        case 5: //Favorite
            self.scorePhase = phaseFavorite;
            break;
        default: NSLog(@"Error setting score phase");
            break;
    }
}

- (IBAction)Submit:(id)sender {
    
    if ([self.btnSubmit.titleLabel.text isEqualToString:@"Submit"]) {
        self.scorePhase = phaseScore;
        [self prepareAndSubmitScores];
    } else if ([self.btnSubmit.titleLabel.text isEqualToString:@"Review"]) {
        self.tabBar.selectedItem = nil;
        [self.btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];;
        
        //sort the scores for display in summary
        NSSortDescriptor *sortScores = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
        NSArray *sortCorpsDescriptor = [NSArray arrayWithObject: sortScores];
        
        if ([self.WScores count]) [self.WScores sortUsingDescriptors:sortCorpsDescriptor];
        if ([self.OScores count]) [self.OScores sortUsingDescriptors:sortCorpsDescriptor];

        self.scorePhase = phaseSummary;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Review" message:@"You can only review this show once. \n\n After you're satisfied with your review, tap submit." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(NSMutableArray *)arrayOfOpenClassScores {
    if (!_arrayOfOpenClassScores) {
        _arrayOfOpenClassScores = [[NSMutableArray alloc] init];
    }
    return _arrayOfOpenClassScores;
}

-(NSMutableArray *)arrayOfWorldClassScores {
    if (!_arrayOfWorldClassScores) {
        _arrayOfWorldClassScores = [[NSMutableArray alloc] init];
    }
    return _arrayOfWorldClassScores;
}
//
//-(NSMutableArray *)WScores {
//    if (!_WScores) {
//        _WScores = [[NSMutableArray alloc] init];
//    }
//    return _WScores;
//}
//
//-(NSMutableArray *)OScores {
//    if (!_OScores) {
//        _OScores = [[NSMutableArray alloc] init];
//    }
//    return _OScores;
//}

@end
