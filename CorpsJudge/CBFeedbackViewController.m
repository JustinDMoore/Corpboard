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
#import "IQKeyboardManager.h"

int noOfStars = 0;

@interface CBFeedbackViewController ()

@property (nonatomic, strong) IBOutlet CBTextViewPlaceHolder *txtFeedback;
@property (nonatomic, strong) IBOutlet UIView *viewFeedback;
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
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    CBRateView *myCustomXIBViewObj =
    [[[NSBundle mainBundle] loadNibNamed:@"CBRateView"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    [self.view addSubview:myCustomXIBViewObj];
    [myCustomXIBViewObj showInParent:self.view.frame];
    
    [myCustomXIBViewObj setDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewFeedback.hidden = YES;
    
    self.txtFeedback.placeholder = @"How can we improve?";
    self.txtFeedback.placeholderColor = [UIColor lightGrayColor];
    self.txtFeedback.textColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showFeedback {
    
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

-(void)rateSubmitted:(int)numberStars {
    [self showFeedback];
    noOfStars = numberStars;
}

-(void)rateCancelled {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
