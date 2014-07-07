//
//  CBFeedbackViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 7/6/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBFeedbackViewController.h"
#import "CBTextViewPlaceholder.h"
#import <Parse/Parse.h>

@interface CBFeedbackViewController ()
@property (nonatomic, strong) IBOutlet UIView *viewRate;
@property (nonatomic, strong) IBOutlet UIImageView *star1;
@property (nonatomic, strong) IBOutlet UIImageView *star2;
@property (nonatomic, strong) IBOutlet UIImageView *star3;
@property (nonatomic, strong) IBOutlet UIImageView *star4;
@property (nonatomic, strong) IBOutlet UIImageView *star5;
@property (nonatomic, strong) IBOutlet UIView *viewStars;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) IBOutlet UILabel *lblRating;
@property (nonatomic, strong) IBOutlet UILabel *lblHeader;
@property (nonatomic, strong) IBOutlet UILabel *lblSubHeader;
@property (nonatomic, strong) IBOutlet UIView *viewHorizontal;
@property (nonatomic, strong) IBOutlet UIView *viewVertical;
@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtFeedback;
@property (nonatomic, strong) IBOutlet UIView *viewFeedback;


-(IBAction)btnCancel_clicked:(id)sender;
-(IBAction)btnSubmit_clicked:(id)sender;
-(IBAction)btnCancelFeedback_clicked:(id)sender;

@end

@implementation CBFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showViewRate {
    
    
    
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         
                         self.viewRate.frame = CGRectMake(self.viewRate.frame.origin.x - 55, self.viewRate.frame.origin.y - 55, self.viewRate.frame.size.width + 110, self.viewRate.frame.size.height + 110);
                         self.viewRate.alpha = 1;
                         
                     } completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^(void) {
                                              
                                              self.viewRate.frame = CGRectMake(self.viewRate.frame.origin.x + 5, self.viewRate.frame.origin.y + 5, self.viewRate.frame.size.width - 10, self.viewRate.frame.size.height - 10);
                                              
                                              
                                              
                                              self.lblHeader.alpha = 1;
                                              self.lblSubHeader.alpha = 1;
                                              self.viewStars.alpha = 1;
                                              self.btnCancel.alpha = 1;
                                              self.btnSubmit.alpha = 1;
                                              self.viewHorizontal.alpha = 1;
                                              self.viewVertical.alpha = 1;
                                              
                                              
                                          } completion:^(BOOL finished){
                                              
                                              
                                              
                                          }];
                         
                     }];
}

-(void)viewDidAppear:(BOOL)animated {
    [self showViewRate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewFeedback.hidden = YES;
    
    self.txtFeedback.placeholder = @"How can we improve?";
    self.txtFeedback.placeholderColor = [UIColor lightGrayColor];
    self.txtFeedback.textColor = [UIColor whiteColor];
    
    self.viewRate.frame =
    CGRectMake(self.viewRate.frame.origin.x + 50, self.viewRate.frame.origin.y + 50, self.viewRate.frame.size.width - 100, self.viewRate.frame.size.height - 100);
    self.viewRate.alpha = 0;
    self.lblHeader.alpha = 0;
    self.lblSubHeader.alpha = 0;
    self.viewStars.alpha = 0;
    self.btnCancel.alpha = 0;
    self.btnSubmit.alpha = 0;
    self.viewHorizontal.alpha = 0;
    self.viewVertical.alpha = 0;
    
    self.btnSubmit.enabled = NO;
    
    self.lblRating.text = @"";
    
    self.viewRate.layer.cornerRadius = 8;
    self.star1.image = [UIImage imageNamed:@"star_unselected"];
    self.star2.image = [UIImage imageNamed:@"star_unselected"];
    self.star3.image = [UIImage imageNamed:@"star_unselected"];
    self.star4.image = [UIImage imageNamed:@"star_unselected"];
    self.star5.image = [UIImage imageNamed:@"star_unselected"];
    
    self.star1.userInteractionEnabled = YES;
    self.star2.userInteractionEnabled = YES;
    self.star3.userInteractionEnabled = YES;
    self.star4.userInteractionEnabled = YES;
    self.star5.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [self.star1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [self.star2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [self.star3 addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [self.star4 addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStar:)];
    [self.star5 addGestureRecognizer:tap5];
    
    
    
}

-(void)tapStar:(UITapGestureRecognizer *)recog {
 
    self.btnSubmit.enabled = YES;
    
    UIImageView *imgView = (UIImageView*)recog.view;
    if (imgView == self.star1) { noOfStars = 1; self.lblRating.text = @"Poor"; }
    if (imgView == self.star2) { noOfStars = 2; self.lblRating.text = @"Fair"; }
    if (imgView == self.star3) { noOfStars = 3; self.lblRating.text = @"Good"; }
    if (imgView == self.star4) { noOfStars = 4; self.lblRating.text = @"Very Good"; }
    if (imgView == self.star5) { noOfStars = 5; self.lblRating.text = @"Excellent"; }
    
    self.star5.image = [UIImage imageNamed:@"star_unselected"];
    self.star4.image = [UIImage imageNamed:@"star_unselected"];
    self.star3.image = [UIImage imageNamed:@"star_unselected"];
    self.star2.image = [UIImage imageNamed:@"star_unselected"];
    self.star1.image = [UIImage imageNamed:@"star_unselected"];
    
    x = noOfStars;
    [self animateStar];

}

bool onStar = NO;
UIImageView *currentStar;

int noOfStars = 0;
int x = 0;


-(void)animateStar {
 
    UIImageView *theStar;
    
    if (x == 1) theStar = self.star1;
    if (x == 2) theStar = self.star2;
    if (x == 3) theStar = self.star3;
    if (x == 4) theStar = self.star4;
    if (x == 5) theStar = self.star5;
    
    //star expand
    [UIView animateWithDuration:.06
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
    theStar.frame = CGRectMake(theStar.frame.origin.x - 10, theStar.frame.origin.y - 10, theStar.frame.size.width + 20, theStar.frame.size.height + 20);
                         theStar.image = [UIImage imageNamed:@"star_selected"];
                         theStar.tag = 1;
    } completion:^(BOOL finished){
        
        x--;
        if (x > 0) [self animateStar];
        
    //star contract
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
        
   theStar.frame = CGRectMake(theStar.frame.origin.x + 15, theStar.frame.origin.y + 15, theStar.frame.size.width - 30, theStar.frame.size.height - 30);
    } completion:^(BOOL finished){
    
        
        //star resize
        [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             
                             theStar.frame = CGRectMake(theStar.frame.origin.x - 5, theStar.frame.origin.y - 5, theStar.frame.size.width + 10, theStar.frame.size.height + 10);
                         } completion:^(BOOL finished){
                             
                             
                         }];
    
    }];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnSubmit_clicked:(id)sender {
    self.viewRate.hidden = YES;
    self.viewFeedback.hidden = NO;
    self.viewFeedback.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    self.txtFeedback.frame = CGRectMake(self.txtFeedback.frame.origin.x, self.txtFeedback.frame.origin.y, self.txtFeedback.frame.size.width, self.viewFeedback.frame.size.height - 216 - 40);
    [self.txtFeedback becomeFirstResponder];
}

-(void)submitToServer {
    
    PFObject *feedback = [PFObject objectWithClassName:@"feedback"];
    
    if (![self.txtFeedback.text isEqualToString:@""]) {
        feedback[@"text"] = self.txtFeedback.text;
    }
    
    feedback[@"user"] = [PFUser currentUser];
    feedback[@"stars"] = [NSNumber numberWithInt:noOfStars];
    [feedback saveInBackground];
}

-(void)btnCancel_clicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnCancelFeedback_clicked:(id)sender {
    
    [self submitToServer];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Thanks for your feedback!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  
}

@end
