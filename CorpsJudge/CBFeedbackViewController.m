//
//  CBFeedbackViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 5/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBFeedbackViewController.h"
#import "CBSingle.h"
#import "IQKeyboardManager.h"
#import "CBWebViewController.h"

@interface CBFeedbackViewController ()

@end

CBSingle *data;
NSString *currentView;
int keyboardHeight = 210;

@implementation CBFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    self.arrayOfFeedbackItems = [[NSMutableArray alloc] init];
    [self.arrayOfFeedbackItems addObject:@"General Feedback"];
    [self.arrayOfFeedbackItems addObject:@"Something Isn't Working"];
    [self.arrayOfFeedbackItems addObject:@"Report Incorrect Information"];
    [self.arrayOfFeedbackItems addObject:@"Rate Corpboard"];
    
    self.btnPrivacyPolicy.alpha = 0;
    self.lblPrivacyPolicy.alpha = 0;
    [self.btnPrivacyPolicy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:visualEffectView];
    [self.view sendSubviewToBack:visualEffectView];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    if (!currentView) {
        self.viewContactUs =
        [[[NSBundle mainBundle] loadNibNamed:@"CBContactUs"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        [self.view addSubview:self.viewContactUs];
        [self.viewContactUs showInParent:self.view.frame];
        [self.viewContactUs setDelegate:self];
        self.viewContactUs.tableFeedback.delegate = self;
        self.viewContactUs.tableFeedback.dataSource = self;
        self.viewContactUs.tableFeedback.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

-(void)cancelled {
    currentView = nil;
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark
#pragma mark - Actions
#pragma mark
- (IBAction)btnPrivacyPolicy_tapped:(id)sender {
    
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"web";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    CBWebViewController * web = (CBWebViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    web.webURL = @"http://yea.org/privacy-general";
    web.websiteTitle = @"Youth Education in the Arts";
    web.websiteSubTitle = @"Privacy Policy";
    
    [self presentViewController:web animated:YES completion:nil];
}

#pragma mark
#pragma mark - UITableView
#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.viewContactUs.tableFeedback) {
        return [self.arrayOfFeedbackItems count];
    } else if (tableView == self.viewProblemWhere.tableProblem) {
        return [self.viewProblemWhere.arrayOfProblemAreas count];
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.viewContactUs.tableFeedback) return 45;
    else if (tableView == self.viewProblemWhere.tableProblem) return 45;
    else return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (tableView == self.viewContactUs.tableFeedback) return 45;
    else if (tableView == self.viewProblemWhere.tableProblem) return 45;
    else return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.viewContactUs.tableFeedback) {
        
        CBFeedbackCell *cell = [self.viewContactUs.tableFeedback dequeueReusableCellWithIdentifier:@"feedbackCell"];
        if (!cell) {
            [self.viewContactUs.tableFeedback registerNib:[UINib nibWithNibName:@"CBFeedbackCell" bundle:nil] forCellReuseIdentifier:@"feedbackCell"];
            cell = [self.viewContactUs.tableFeedback dequeueReusableCellWithIdentifier:@"feedbackCell"];
        }
        
        UILabel *lblMenuItem = (UILabel *)[cell viewWithTag:2];
        UIImageView *imgMenuItem = (UIImageView *)[cell viewWithTag:1];
        
        NSString *item = self.arrayOfFeedbackItems[indexPath.row];
        lblMenuItem.text = item;
        if ([item isEqualToString:@"General Feedback"]) {
            [imgMenuItem setImage:[UIImage imageNamed:@"feedbackGeneral"]];
        } else if ([item isEqualToString:@"Something Isn't Working"]) {
            [imgMenuItem setImage:[UIImage imageNamed:@"feedbackBug"]];
        } else if ([item isEqualToString:@"Report Incorrect Information"]) {
            [imgMenuItem setImage:[UIImage imageNamed:@"feedbackInfo"]];
        } else if ([item isEqualToString:@"Rate Corpboard"]) {
            [imgMenuItem setImage:[UIImage imageNamed:@"feedbackRate"]];
        }
        
        return cell;
        
    } else if (tableView == self.viewProblemWhere.tableProblem) {
        
        CBProblemWhereCell *cell = [self.viewProblemWhere.tableProblem dequeueReusableCellWithIdentifier:@"problemCell"];
        if (!cell) {
            [self.viewProblemWhere.tableProblem registerNib:[UINib nibWithNibName:@"CBProblemWhereCell" bundle:nil] forCellReuseIdentifier:@"problemCell"];
            cell = [self.viewProblemWhere.tableProblem dequeueReusableCellWithIdentifier:@"problemCell"];
        }
        
        UILabel *lblMenuItem = (UILabel *)[cell viewWithTag:2];
        UIImageView *imgMenuItem = (UIImageView *)[cell viewWithTag:1];
        
        NSString *item = self.viewProblemWhere.arrayOfProblemAreas[indexPath.row];
        lblMenuItem.text = item;
        imgMenuItem.image = self.viewProblemWhere.arrayOfProblemImages[indexPath.row];        
        return cell;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.viewContactUs.tableFeedback) {
        switch (indexPath.row) {
            case 0:
                [self showRateView];
                //[self performSegueWithIdentifier:@"feedback" sender:self];
                break;
            case 1:
                self.bug = YES;
                [self showProblemWhereView];
                break;
            case 2:
                self.bug = NO;
                [self showProblemWhereView];
                break;
            case 3:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data.objAdmin[@"iOS7AppStoreLink"]]];
                break;
            default:
                break;
        }
    } else if (tableView == self.viewProblemWhere.tableProblem) {
        NSString *where = self.viewProblemWhere.arrayOfProblemAreas[indexPath.row];
        [self showProblemWhatView:where];
    }
}

-(void)showRateView {
    
    currentView = @"Rate";
    self.viewRate =
    [[[NSBundle mainBundle] loadNibNamed:@"CBRateView"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    for (UIView *view in [self.viewContactUs subviews]) {
        [view removeFromSuperview];
    }
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         self.viewContactUs.frame = CGRectMake(self.viewContactUs.frame.origin.x, self.viewContactUs.frame.origin.y, self.viewRate.frame.size.width, self.viewRate.frame.size.height);
                         self.viewContactUs.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
                     } completion:^(BOOL finished) {
                         [self.viewRate showInParent];
                     }];
    [self.viewContactUs addSubview:self.viewRate];
//    [myCustomXIBViewObj showInParent:self.view.frame];
    
    [self.viewRate setDelegate:self];
}

-(void)showFeedbackView:(int)numberOfStars {
    
    currentView = @"Feedback";
    self.viewFeedback =
    [[[NSBundle mainBundle] loadNibNamed:@"CBFeedbackView"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    for (UIView *view in [self.viewContactUs subviews]) {
        [view removeFromSuperview];
    }
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         
                         self.viewFeedback.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 60 - keyboardHeight);
                         self.viewContactUs.frame = CGRectMake(0, 30, self.viewFeedback.frame.size.width, self.viewFeedback.frame.size.height);
                         self.viewContactUs.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.viewContactUs.center.y);

                     } completion:^(BOOL finished) {
                         [self.viewFeedback showInParent];
                     }];

    [self.viewContactUs addSubview:self.viewFeedback];
    [self.viewFeedback setDelegate:self];
    self.viewFeedback.numberOfStars = numberOfStars;
}

-(void)showThankYou {
    
    currentView = @"Thank You";
    self.viewThankYou =
    [[[NSBundle mainBundle] loadNibNamed:@"CBThankYou"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    for (UIView *view in [self.viewContactUs subviews]) {
        [view removeFromSuperview];
    }
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         self.viewContactUs.frame = CGRectMake(self.viewContactUs.frame.origin.x, self.viewContactUs.frame.origin.y, self.viewThankYou.frame.size.width, self.viewThankYou.frame.size.height);
                         self.viewContactUs.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
                     } completion:^(BOOL finished) {
                         [self.viewThankYou showInParent];
                     }];
    [self.viewContactUs addSubview:self.viewThankYou];
    [self.viewThankYou setDelegate:self];
}

-(void)showProblemWhereView {
    
    currentView = @"Problem Where";
    self.viewProblemWhere =
    [[[NSBundle mainBundle] loadNibNamed:@"CBProblemWhere"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    for (UIView *view in [self.viewContactUs subviews]) {
        [view removeFromSuperview];
    }
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         
                         self.viewProblemWhere.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 100);
                         self.viewContactUs.frame = CGRectMake(0, 30, self.viewProblemWhere.frame.size.width, self.viewProblemWhere.frame.size.height);
                         self.viewContactUs.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.viewContactUs.center.y);
                         self.lblPrivacyPolicy.alpha = 1;
                         self.btnPrivacyPolicy.alpha = 1;
                     } completion:^(BOOL finished) {
                         [self.viewProblemWhere showInParent];
                     }];
    [self.viewContactUs addSubview:self.viewProblemWhere];
    [self.viewProblemWhere setDelegate:self];
    self.viewProblemWhere.tableProblem.delegate = self;
    self.viewProblemWhere.tableProblem.dataSource = self;
    
    self.viewProblemWhere.tableProblem.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)showProblemWhatView:(NSString *)where {
    
    currentView = @"Problem What";
    self.viewProblemWhat =
    [[[NSBundle mainBundle] loadNibNamed:@"CBProblemWhat"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    for (UIView *view in [self.viewContactUs subviews]) {
        [view removeFromSuperview];
    }
    
    self.viewProblemWhat.frame = CGRectMake(0 + [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 60 - keyboardHeight);
    
    [UIView animateWithDuration:.25
                          delay:0
                        options:0
                     animations:^{
                         
                         self.viewProblemWhat.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 60 - keyboardHeight);
                         
                         self.viewContactUs.frame = CGRectMake(0, 30, self.viewProblemWhat.frame.size.width, self.viewProblemWhat.frame.size.height);
                         self.viewContactUs.center = CGPointMake(CGRectGetMidX(self.view.bounds), self.viewContactUs.center.y);
                     } completion:^(BOOL finished) {
                         [self.viewProblemWhat showMenu];
                     }];
    [self.viewContactUs addSubview:self.viewProblemWhat];
    [self.viewProblemWhat setDelegate:self];
    self.viewProblemWhat.where = where;
    self.viewProblemWhat.parent = self;
    self.viewProblemWhat.isProblem = self.bug;
    [self.viewProblemWhat showInParent];
}

#pragma mark
#pragma mark - Rate Delegates
#pragma mark
-(void)rateCancelled {
    [self.viewContactUs closeView:YES];
}

-(void)rateSubmitted:(int)numberStars {
    [self showFeedbackView:numberStars];
}

#pragma mark
#pragma mark - Feedback Protocol
#pragma mark
-(void)feedbackCancelled:(int)numberOfStars {
    [self submitToServer:numberOfStars feedback:nil];
}

-(void)feedbackSent:(int)numberOfStars feedback:(NSString *)feedback {
    [self submitToServer:numberOfStars feedback:feedback];
}

-(void)submitToServer:(int)numberOfStars feedback:(NSString *)feedback {
    
    PFObject *feed = [PFObject objectWithClassName:@"feedback"];
    
    if (feedback) {
        if (![feedback isEqualToString:@""]) {
            feed[@"text"] = feedback;
        }
    }
    
    feed[@"user"] = [PFUser currentUser];
    feed[@"stars"] = [NSNumber numberWithInt:numberOfStars];
    [feed saveEventually];
    [self showThankYou];
}

#pragma mark
#pragma mark - Thank You Protocol
#pragma mark
-(void)thankYou {
    
    [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:8 options:0 animations:^{
        
        self.viewContactUs.transform = CGAffineTransformScale(self.viewContactUs.transform, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:8
                            options:0
                         animations:^{
                             self.viewContactUs.transform = CGAffineTransformScale(self.viewContactUs.transform, 0.1f, 0.1f);
                             self.viewContactUs.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self.viewContactUs removeFromSuperview];
                             [self cancelled];
                         }];
    }];
}

#pragma mark
#pragma mark - Problem Where Protocol
#pragma mark

-(void)problemWhereCanceled {
    [self thankYou];
}

#pragma mark
#pragma mark - Problem What Protocol
#pragma mark
-(void)backFromProblemWhat {
    
    [self showProblemWhereView];
}

-(void)sendProblem:(NSString *)report withImages:(NSMutableArray *)arrayOfImages whereAt:(NSString *)whereat {
    
    PFObject *problem = [PFObject objectWithClassName:@"problems"];
    if (self.bug) {
        problem[@"type"] = @"Problem";
    } else {
        problem[@"type"] = @"Incorrect Information";
    }
    
    problem[@"user"] = [PFUser currentUser];
    problem[@"whereAt"] = whereat;
    problem[@"whatHappened"] = report;
    [problem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            for (int i = 0; i <= [arrayOfImages count]; i++)  {
                
                NSData *imageData = UIImagePNGRepresentation((UIImage *)[arrayOfImages objectAtIndex:i]);
                //make sure the image isn't too big
                NSInteger size = imageData.length;
                if (size < 10485760) {
                    
                    PFFile *imageFile = [PFFile fileWithName:@"screenshot.png" data:imageData];
                    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            switch (i) {
                                case 0:
                                    problem[@"screenshot1"] = imageFile;
                                    [problem saveEventually];
                                    break;
                                case 1:
                                    problem[@"screenshot2"] = imageFile;
                                    [problem saveEventually];
                                    break;
                                case 2:
                                    problem[@"screenshot3"] = imageFile;
                                    [problem saveEventually];
                                    break;
                            }
                        }
                    }];
                } else {
                    NSLog(@"image too big");
                }
            }
        }
    }];
    
    [self showThankYou];
}

@end
