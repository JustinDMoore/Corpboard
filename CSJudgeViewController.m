//
//  CSJudgeViewController.m
//  CorpsJudge
//
//  Created by Justin Moore on 6/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CSJudgeViewController.h"
#import "CSSingle.h"

NSInteger favDrumsW = -1;
NSInteger favHornlineW = -1;
NSInteger favGuardW = -1;
NSInteger favCorpsW = -1;
NSInteger loudHornlineW = -1;

NSInteger favDrumsO = -1;
NSInteger favHornlineO = -1;
NSInteger favGuardO = -1;
NSInteger favCorpsO = -1;
NSInteger loudHornlineO = -1;

NSInteger currentRowIndex;

CSSingle *data;

@interface CSJudgeViewController ()

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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, assign) id currentResponder;
@property (weak, nonatomic) IBOutlet UILabel *lblInstructions;
@property (nonatomic, assign) phase scorePhase;
- (IBAction)btnCancel_clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UISwitch *officialSwitch;

- (IBAction)Submit:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;



@end

@implementation CSJudgeViewController

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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    data = [CSSingle data];
    
    self.title = @"Review Show";

    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    [self.tabBar setSelectedItem:item];

    if (data.adminMode) {
        self.officialSwitch.hidden = NO;
    } else {
        self.officialSwitch.hidden = YES;
    }
    
    NSString *mystring1 = @"To keep votes accurate, only review this show if you attended it.";
    NSString *mystring2 = @"Only the corps that you review will be submitted.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Review the Show"
                                                    message:[NSString stringWithFormat:@"\n%@\n\n%@", mystring1,mystring2]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
 
    [alert show];
    
    self.OScores = [[NSMutableArray alloc] init];//WithCapacity:[self.arrayOfOpenClassScores count]];
    self.WScores = [[NSMutableArray alloc] init];//WithCapacity:[self.arrayOfWorldClassScores count]];
    
    if ([self.arrayOfWorldClassScores count]) {
        for (int i = 0; i < [self.arrayOfWorldClassScores count]; i++ ) {
            [self.WScores addObject:@"0"];
        }
    }

    if ([self.arrayOfOpenClassScores count]) {
        for (int i = 0; i < [self.arrayOfOpenClassScores count]; i++ ) {
            [self.OScores addObject:@"0"];
        }
    }
    
    
     favDrumsW = -1;
     favHornlineW = -1;
     favGuardW = -1;
     favCorpsW = -1;
     loudHornlineW = -1;
    
     favDrumsO = -1;
     favHornlineO = -1;
     favGuardO = -1;
     favCorpsO = -1;
     loudHornlineO = -1;
    
    self.tableCorps.allowsSelection = YES;
    self.scorePhase = phaseScore;
    self.tableCorps.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.activity.hidden = YES;
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
        [self.WScores replaceObjectAtIndex:indexPath.row withObject:textField.text];
        //[self.WScores setObject:textField.text forKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]];
    } else if (indexPath.section == 1) {
        [self.OScores replaceObjectAtIndex:indexPath.row withObject:textField.text];
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

- (IBAction)nextPhase:(id)sender {
    if (self.officialSwitch.on) {
        [self prepareAndSubmitScores];
    } else {
        self.scorePhase++;
    }
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
    
    if (self.officialSwitch.isOn) {
        
        //mark the show as over
        self.show[@"isShowOver"] = [NSNumber numberWithBool:YES];
        [self.show saveInBackground];
        
        if (![self areAllScoresEntered]) {
            return;
        }
    }
    

        
        for (NSInteger j = 0; j < [self.tableCorps numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [self.tableCorps numberOfRowsInSection:j]; ++i)
            {

                UITableViewCell *cell = [self.tableCorps cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                UITextField *text = (UITextField *)[cell viewWithTag:2];
                NSIndexPath *path = [self.tableCorps indexPathForCell:cell];
                
                PFObject *score;
                PFObject *corps;
                
                if (path.section == 0) { //world
                    if ([self.arrayOfWorldClassScores count]) {
                        score = [self.arrayOfWorldClassScores objectAtIndex:path.row];
                    }
                    
                } else if (path.section == 1) { //open
                    if ([self.arrayOfOpenClassScores count]) {
                        score = [self.arrayOfOpenClassScores objectAtIndex:path.row];
                    }
                }
                
                corps = score[@"corps"];
                
                // submit the score
                
                if (self.officialSwitch.isOn)  { // OFFICIAL SCORE
                    [self submitOfficialScore:score withScore:text.text];
                } else {
                    if (![text.text isEqualToString:@""] && (![text.text isEqualToString:@"0"])) { // USER SCORE
                        [self submitUserScoreForCorps:corps withScores:text.text];
                    }
                }
            }
        }
    [self submitUserFavorites];
    
    [self voted];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Your vote has been submitted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)voted {
    if ([self.delegate respondsToSelector:@selector(voted)]) {
        [self.delegate voted];
    }
}

-(void)submitOfficialScore:(PFObject *)officialScoreObject withScore:(NSString *)score {
    
    officialScoreObject[@"isOfficial"] = [NSNumber numberWithBool:YES];
    officialScoreObject[@"score"] = score;
    officialScoreObject[@"showDate"] = self.show[@"showDate"];
    [officialScoreObject saveInBackground];
}

-(NSString *)getCategory:(category)cat {
    switch (cat) {
        case catcorps: return @"Favorite Corps";
        case catdrums: return @"Favorite Drums";
        case catguard: return @"Favorite Colorguard";
        case cathornline: return @"Favorite Hornline";
        case catloud: return @"Loudest Hornline";
    }
}

-(void)submitFavorite:(category)cat forWorldClass:(BOOL)isWorld forCorps:(NSInteger)intClass {
    
    if (intClass > -1) {
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
        PFObject *score = [classArray objectAtIndex:intClass];
        PFObject *corps = score[@"corps"];
        favorite[@"corpsName"] = corps[@"corpsName"];
        favorite[@"corps"] = corps;
        favorite[@"isWorldClass"] = [NSNumber numberWithBool:isWorld];
        [favorite saveInBackground];
    }
}

-(void)submitUserFavorites {
    
    
    [self submitFavorite:catdrums forWorldClass:YES forCorps:favDrumsW];
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

- (void)submitUserScoreForCorps:(PFObject *)corpsForScore withScores:(NSString *)corpsScore {
    
    PFObject *score = [PFObject objectWithClassName:@"scores"];
    
    [score setObject:corpsForScore forKey:@"corps"];
    [score setObject:self.show forKey:@"show"];
    score[@"score"] = corpsScore;
    score[@"corpsName"] = corpsForScore[@"corpsName"];
    score[@"isOfficial"] = [NSNumber numberWithBool:NO];
    score[@"user"] = [PFUser currentUser];
    score[@"isWorldClass"] = corpsForScore[@"isWorldClass"];
    score[@"showDate"] = self.show[@"showDate"];
    
    [score saveInBackground];

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
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.scorePhase) {
        case phaseScore:
            break;
        case phaseBestdrums:
            if (indexPath.section == 0) {
                if (favDrumsW == indexPath.row) {
                    favDrumsW = -1;
                } else {
                    favDrumsW = indexPath.row;
                }
            }
            
            if (indexPath.section == 1) {
                if (favDrumsO == indexPath.row) {
                    favDrumsO = -1;
                } else {
                    favDrumsO = indexPath.row;
                }
            }

            break;
        case phaseBestguard:
            if (indexPath.section == 0) {
                if (favGuardW == indexPath.row) {
                    favGuardW = -1;
                } else {
                    favGuardW = indexPath.row;
                }
            }
            
            if (indexPath.section == 1) {
                if (favGuardO == indexPath.row) {
                    favGuardO = -1;
                } else {
                    favGuardO = indexPath.row;
                }
            }
            break;
        case phaseBesthornline:
            if (indexPath.section == 0) {
                if (favHornlineW == indexPath.row) {
                    favHornlineW = -1;
                } else {
                    favHornlineW = indexPath.row;
                }
            }
            
            if (indexPath.section == 1) {
                if (favHornlineO == indexPath.row) {
                    favHornlineO = -1;
                } else {
                    favHornlineO = indexPath.row;
                }
            }
            break;
        case phaseFavorite:
            if (indexPath.section == 0) {
                if (favCorpsW == indexPath.row) {
                    favCorpsW = -1;
                } else {
                    favCorpsW = indexPath.row;
                }
            }
            
            if (indexPath.section == 1) {
                if (favCorpsO == indexPath.row) {
                    favCorpsO = -1;
                } else {
                    favCorpsO = indexPath.row;
                }
            }
            break;
        case phaseLoudesthornline:
            if (indexPath.section == 0) {
                if (loudHornlineW == indexPath.row) {
                    loudHornlineW = -1;
                } else {
                    loudHornlineW = indexPath.row;
                }
            }
            
            if (indexPath.section == 1) {
                if (loudHornlineO == indexPath.row) {
                    loudHornlineO = -1;
                } else {
                    loudHornlineO = indexPath.row;
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
    PFObject *score;
    PFObject *corps;
    if ([indexPath section] == 0) {
        if ([self.arrayOfWorldClassScores count]) {
            if (indexPath.row < [self.arrayOfWorldClassScores count]) {
                if ([self.arrayOfWorldClassScores count]) score = [self.arrayOfWorldClassScores objectAtIndex:[indexPath row]];
            }
        }
    } else if ([indexPath section] == 1) {
        if ([self.arrayOfOpenClassScores count]) {
            if (indexPath.row < [self.arrayOfOpenClassScores count]) {
                if ([self.arrayOfOpenClassScores count]) score = [self.arrayOfOpenClassScores objectAtIndex:[indexPath row]];
            }
        }
    }
    
        if (score) corps = score[@"corps"];
    
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
                    scoreString = [self.WScores objectAtIndex:indexPath.row];
                    if ([scoreString isEqualToString:@"0"])  {
                        text.text = @"";
                    } else text.text = scoreString;
                }
                break;
            case 1:
                scoreString = [self.OScores objectAtIndex:indexPath.row];
                if ([scoreString isEqualToString:@"0"])  {
                    text.text = @"";
                } else text.text = scoreString;
                break;
            default:
                text.text = @"Error";
                break;
        }
        label.text = corps[@"corpsName"];
        
    } else if (self.scorePhase == phaseSummary) {
        
        cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"favorite"];
        NSString *blank = @"None selected";
        NSString *mainText;
        NSString *detailText;
        
        switch ([indexPath section]) {
            case 0: // world class
                if ([self.arrayOfWorldClassScores count]) {
                    if (indexPath.row < [self.arrayOfWorldClassScores count]) { //scores
                        mainText = corps[@"corpsName"];
                        detailText = [self.WScores objectAtIndex:indexPath.row];
                        NSString *s;
                        s = [self.WScores objectAtIndex:indexPath.row];
                        if (s) {
                            if ([s isEqualToString:@"0"] || ([s isEqualToString:@""]))
                                detailText = @"Not Scored";
                        } else detailText = s;
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count]) { //                       best drums
                        mainText = @"Best Percussion";
                        if (favDrumsW > -1) {
                            PFObject *corps = [self.arrayOfWorldClassScores objectAtIndex:favDrumsW];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 1) { //                  best hornline
                        mainText = @"Best Brass";
                        if (favHornlineW > -1) {
                            PFObject *corps = [self.arrayOfWorldClassScores objectAtIndex:favHornlineW];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 2) { //                     best guard
                        mainText = @"Best Colorguard";
                        if (favGuardW > -1) {
                            PFObject *corps = [self.arrayOfWorldClassScores objectAtIndex:favGuardW];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 3) { //                    loudest hornline
                        mainText = @"Loudest Hornline";
                        if (loudHornlineW > -1) {
                            PFObject *corps = [self.arrayOfWorldClassScores objectAtIndex:loudHornlineW];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
                    } else if (indexPath.row == [self.arrayOfWorldClassScores count] + 4) { //                   favorite corps
                        mainText = @"Favorite Show";
                        if (favCorpsW > -1) {
                            PFObject *corps = [self.arrayOfWorldClassScores objectAtIndex:favCorpsW];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
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
                        detailText = [self.OScores objectAtIndex:indexPath.row];
                        NSString *s;
                        s = [self.OScores objectAtIndex:indexPath.row];
                        if (s) {
                            if ([s isEqualToString:@"0"] || ([s isEqualToString:@""]))
                                detailText = @"Not Scored";
                        } else detailText = s;
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count]) {
                        mainText = @"Best Percussion";
                        if (favDrumsO > -1) {
                            PFObject *corps = [self.arrayOfOpenClassScores objectAtIndex:favDrumsO];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 1) {
                        mainText = @"Best Hornline";
                        if (favHornlineO > -1) {
                            PFObject *corps = [self.arrayOfOpenClassScores objectAtIndex:favHornlineO];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 2) {
                        mainText = @"Best Colorguard";
                        if (favGuardO > -1) {
                            PFObject *corps = [self.arrayOfOpenClassScores objectAtIndex:favGuardO];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 3) {
                        mainText = @"Loudest Hornline";
                        if (loudHornlineO > -1) {
                            PFObject *corps = [self.arrayOfOpenClassScores objectAtIndex:loudHornlineO];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
                    } else if (indexPath.row == [self.arrayOfOpenClassScores count] + 4) {
                        mainText = @"Favorite Show";
                        if (favCorpsO > -1) {
                            PFObject *corps = [self.arrayOfOpenClassScores objectAtIndex:favCorpsO];
                            detailText = corps[@"corpsName"];
                        } else detailText = blank;
                        
                    }
                    
                    break;
                default:
                    mainText = @"Main Error";
                    detailText =  @"Detail Error";
                    break;
                }
                
        
                
                
           }
        // for phase Summary only
        cell.textLabel.text = mainText;
        cell.detailTextLabel.text = detailText;
        
    } else { //end of phase summary, handles everything other than summary and score
        
        cell = [self.tableCorps dequeueReusableCellWithIdentifier:@"vote"];
        cell.textLabel.text = corps[@"corpsName"];
        
        // set the checkmarks for world class
        if (indexPath.section == 0) {
            
            switch (self.scorePhase) {
                case phaseScore:
                    //nothing
                    break;
                case phaseLoudesthornline:
                    if (loudHornlineW == (int)indexPath.row) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseFavorite:
                    if (favCorpsW == (int)indexPath.row) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBesthornline:
                    if (favHornlineW == (int)indexPath.row) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestguard:
                    if (favGuardW == (int)indexPath.row) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestdrums:
                    if (favDrumsW == (int)indexPath.row) {
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
            switch (self.scorePhase) {
                case phaseScore:
                    //nothing
                    break;
                case phaseLoudesthornline:
                    if (loudHornlineO == (int)indexPath.row) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseFavorite:
                    if (favCorpsO == (int)indexPath.row) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBesthornline:
                    if (favHornlineO == (int)indexPath.row) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestguard:
                    if (favGuardO == (int)indexPath.row) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case phaseBestdrums:
                    if (favDrumsO == (int)indexPath.row) {
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
            self.lblInstructions.text = @"Score the corps";
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
            self.lblInstructions.text = @"Who had the best colorguard?";
            //self.btnNext.titleLabel.text = @"Next";
            break;
        case phaseLoudesthornline:
            self.lblInstructions.text = @"Who had the loudest hornline?";
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
        self.scorePhase = phaseSummary;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Review" message:@"You can only review this show once. \n After you're satisfied with your votes, tap submit." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
