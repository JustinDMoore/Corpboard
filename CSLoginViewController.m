//
//  CSLoginViewController.m
//  CorpsJudge
//
//  Created by Justin Moore on 6/22/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CSLoginViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "JustinHelper.h"
#import "CSShowsViewController.h"
#import "CSSingle.h"

BOOL loggingIn;

@interface CSLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewMain;
- (IBAction)facebookLogin:(id)sender;
- (IBAction)twitterLogin:(id)sender;
- (IBAction)emailLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (nonatomic, assign) id currentResponder;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation CSLoginViewController

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
    //
    // ***** WARNING *****
    // Uncommenting the following line will create ALL shows and ALL scores
    //Configuration *conf = [[Configuration alloc] init];
    //
    //
    //
    
    
    
    
    self.navigationController.navigationBarHidden = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    [currentUser fetchInBackground];

    if (currentUser) {
        [self useApp];
    } else {
        NSLog(@"new user");
        self.activity.hidden = YES;
        self.lblEmail.alpha = 0;
        self.lblEmail.hidden = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [singleTap setCancelsTouchesInView:NO];
        [self.view addGestureRecognizer:singleTap];
        
        [self.viewMain setBackgroundColor:[UIColor whiteColor]];
        //self.txtEmail.alpha = 0;
        //self.txtPassword.alpha = 0;
        //self.txtEmail.hidden = YES;
        //self.txtPassword.hidden = YES;
    }
 
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.currentResponder = textField;
}

- (void)resignOnTap:(id)iSender {
    
    if (self.btnFacebook.hidden) {
        [self slideViewDown];
        [self.currentResponder resignFirstResponder];
        [self.txtEmail resignFirstResponder];
        [self.txtPassword resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.txtEmail)  {
        [self.txtPassword becomeFirstResponder];
        self.currentResponder = self.txtPassword;
    }
    if (textField == self.txtPassword) {
        // attempt login
        //make sure we have un and pw
        if ((![self.txtEmail.text isEqualToString:@""]) && (![self.txtPassword.text isEqualToString:@""])) {
            if ([JustinHelper StringIsValidEmail:self.txtEmail.text]) {
                self.txtEmail.hidden = YES;
                self.txtPassword.hidden = YES;
                self.activity.hidden = NO;
                [self.activity startAnimating];
                loggingIn = YES;
                [self createAccountWithEmail];
            } else {
          
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Please enter a valid email address"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [self.txtEmail becomeFirstResponder];
            }
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLogin:(id)sender {
    
    NSArray *permissions = @[@"email", @"public_profile"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self setUserAdmin];
            [self useApp];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self useApp];
        }
    }];
}

- (IBAction)twitterLogin:(id)sender {
    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self setUserAdmin];
            [self useApp];
        } else {
            NSLog(@"User logged in with Twitter!");
            NSLog(@"%@", user);
            [self useApp];
        }     
    }];
}

-(void)slideViewUp {
    if (!loggingIn) {
        self.lblEmail.hidden = NO;
        self.txtPassword.hidden = NO;
        self.txtEmail.hidden = NO;
        [self.txtEmail becomeFirstResponder];
        [UIView animateWithDuration:0.4
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             
             [self.viewMain setFrame:CGRectMake(0, self.viewMain.frame.origin.y - 145 , self.viewMain.frame.size.width, self.viewMain.frame.size.width)];
             [self.txtEmail setFrame:CGRectMake(self.txtEmail.frame.origin.x, self.txtEmail.frame.origin.y - 150, self.txtEmail.frame.size.width, self.txtEmail.frame.size.height)];
             
             [self.txtPassword setFrame:CGRectMake(self.txtEmail.frame.origin.x, self.txtPassword.frame.origin.y - 150, self.txtPassword.frame.size.width, self.txtPassword.frame.size.height)];
             
             [self.activity setFrame:CGRectMake(self.activity.frame.origin.x, self.activity.frame.origin.y - 145, self.activity.frame.size.width, self.activity.frame.size.height)];
             
             self.btnFacebook.alpha = 0;
             self.btnTwitter.alpha = 0;
             self.lblEmail.alpha = 1;
             self.txtEmail.alpha = 1;
             self.txtPassword.alpha = 1;
             
         }
                         completion:^(BOOL finished)
         {
             self.btnFacebook.hidden = YES;
             self.btnTwitter.hidden = YES;
             
         }];
    }
}

-(void)setUserAdmin {
    PFUser *test = [PFUser currentUser];
    test[@"isAdmin"] = [NSNumber numberWithBool:NO];
    [test save];
}

-(void)slideViewDown {
    
    if (!loggingIn) {
        [self.txtEmail resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        self.btnFacebook.hidden = NO;
        self.btnTwitter.hidden = NO;
        
        [UIView animateWithDuration:0.4
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             
             [self.viewMain setFrame:CGRectMake(0, self.viewMain.frame.origin.y + 145 , self.viewMain.frame.size.width, self.viewMain.frame.size.width)];
             
             [self.txtEmail setFrame:CGRectMake(self.txtEmail.frame.origin.x, self.txtEmail.frame.origin.y + 150, self.txtEmail.frame.size.width, self.txtEmail.frame.size.height)];
             
             [self.txtPassword setFrame:CGRectMake(self.txtEmail.frame.origin.x, self.txtPassword.frame.origin.y + 150, self.txtPassword.frame.size.width, self.txtPassword.frame.size.height)];
             
             [self.activity setFrame:CGRectMake(self.activity.frame.origin.x, self.activity.frame.origin.y + 145, self.activity.frame.size.width, self.activity.frame.size.height)];
             
             self.btnFacebook.alpha = 1;
             self.btnTwitter.alpha = 1;
             self.lblEmail.alpha = 0;
             self.txtEmail.alpha = 0;
             self.txtPassword.alpha = 0;
             
         }
                         completion:^(BOOL finished)
         {
             self.lblEmail.hidden = YES;
             self.txtPassword.hidden = YES;
             self.txtEmail.hidden = YES;
         }];
    }
}

- (IBAction)emailLogin:(id)sender {
    
    if (!self.btnFacebook.hidden) {
        [self slideViewUp];
    } else {
        [self slideViewDown];
    }
}

-(void)createAccountWithEmail {
    
    PFUser *user = [PFUser user];
    user.username = self.txtEmail.text;
    user.password = self.txtPassword.text;
    user.email = self.txtEmail.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [self setUserAdmin];
            [self useApp];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"Error creating account: %@", errorString);
        }
    }];
}

-(void)useApp {
    CSSingle *data = [CSSingle data];
    [data getAllCorpsFromServer];
    [data getAllShowsFromServer];
    [self performSegueWithIdentifier:@"menu" sender:self];
}

@end
