//
//  CBNewLoginViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 11/20/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBNewLoginViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface CBNewLoginViewController () {
    NSTimer *timerCountdown;
    CSSingle *data;
   
}
@property (nonatomic, strong) CBNewUserView *viewNewUser;
@property (nonatomic) BOOL theBool;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *lblSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblDisclaimer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *btnExistingUsers;


@property (weak, nonatomic) IBOutlet UIView *viewSignUp;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollLogin;

@end

@implementation CBNewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self initUI];
    [self initVariables];
}

-(void)initVariables {

    data = [CSSingle data];
    [data setDelegate:self];
    [[PFUser currentUser] fetchInBackground];
    self.currentUser = [PFUser currentUser];
   
    self.viewNewUser =
    [[[NSBundle mainBundle] loadNibNamed:@"CBNewUser"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
   
    
    if (self.currentUser) {

        [self loadData];
        NSLog(@"Existing user.");
        timerCountdown = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(countIt)
                                                            userInfo:nil
                                                             repeats:YES];
    } else {
        NSLog(@"New user.");
        [self newUser];
    }
    
}

int ticker = 0;
-(void)countIt {
    if (ticker < 20) {
        ticker ++;
    } else {
        [timerCountdown invalidate];
        timerCountdown = nil;
        NSLog(@"Timeout error loading Data");
    }
}

-(void)initUI {
    
    self.viewSignUp.backgroundColor = [UIColor blackColor];
    
    self.lblSignIn.alpha = 0;
    self.btnFacebook.alpha = 0;
    self.btnTwitter.alpha = 0;
    self.btnEmail.alpha = 0;
    self.lblDisclaimer.alpha = 0;
    self.btnExistingUsers.alpha = 0;
    
    self.lblSignIn.hidden = YES;
    self.btnFacebook.hidden = YES;
    self.btnTwitter.hidden = YES;
    self.btnEmail.hidden = YES;
    self.lblDisclaimer.hidden = YES;
    self.btnExistingUsers.hidden = YES;
    
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    
    
}

-(void)newUser {
    
    self.lblSignIn.hidden = NO;
    self.btnFacebook.hidden = NO;
    self.btnTwitter.hidden = NO;
    self.btnEmail.hidden = NO;
    self.lblDisclaimer.hidden = NO;
    self.btnExistingUsers.hidden = NO;
    
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.lblSignIn.alpha = 1;
                         self.btnFacebook.alpha = 1;
                         self.btnTwitter.alpha = 1;
                         self.btnEmail.alpha = 1;
                         self.lblDisclaimer.alpha = 1;
                         self.btnExistingUsers.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)createNickname {
    
}

-(void)useApp {
    [self performSegueWithIdentifier:@"menu" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 
#pragma mark - Logging in
#pragma mark

-(void)createAccountWithEmail:(NSString *)email Password:(NSString *) pw ScreenName:(NSString *)screenname {
    
    PFUser *user = [PFUser user];
    user.username = email;
    user[@"screenname"] = screenname;
    user.password = pw;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [self useApp];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"Error creating account: %@", errorString);
        }
    }];
}

- (IBAction)btnFacebook_clicked:(id)sender {
    NSArray *permissions = @[@"email", @"public_profile"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self loadData];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self loadData];
        }
    }];
}

- (IBAction)btnTwitter_clicked:(id)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self loadData];
        } else {
            NSLog(@"User logged in with Twitter!");
            NSLog(@"%@", user);
            [self loadData];
        }
    }];
}

- (IBAction)btnEmail_clicked:(id)sender {

    [self.scrollLogin addSubview:self.viewNewUser];
    self.viewNewUser.frame = CGRectMake(self.viewSignUp.frame.origin.x + self.viewSignUp.frame.size.width, self.viewSignUp.frame.origin.y, self.viewNewUser.frame.size.width, self.viewNewUser.frame.size.height);
    [self.viewNewUser setDelegate:self];
    self.viewNewUser.viewToScroll = self.view;
    self.scrollLogin.contentSize = CGSizeMake(self.viewSignUp.frame.size.width + self.viewNewUser.frame.size.width, self.viewSignUp.frame.size.height);
    [self.scrollLogin scrollRectToVisible:self.viewNewUser.frame animated:YES];
}

#pragma mark
#pragma mark - Loading Data
#pragma mark

-(void)loadData {
    self.btnEmail.hidden = YES;
    self.btnFacebook.hidden = YES;
    self.btnTwitter.hidden = YES;
    self.progressView.hidden = NO;
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(0, self.progressView.frame.origin.y - self.lblSignIn.frame.size.height, self.view.frame.size.width, self.lblSignIn.frame.size.height);
    self.lblSignIn.hidden = YES;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:17];
    lbl.text = [NSString stringWithFormat:@"LOADING"];
    
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl];
    [data getAllCorpsFromServer];
    [data getAllShowsFromServer];
    self.progressView.progress = 0;
    self.theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                    target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];

}

-(void)finishedLoadingData {
    self.theBool = true;
    [self.myTimer invalidate];
    self.myTimer = nil;
    self.progressView.progress = 100;
    [self performSelector:@selector(useApp) withObject:nil afterDelay:.5];

}

-(void)timerCallback {
    if (self.theBool) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [self.myTimer invalidate];
        }
        else {
            self.progressView.progress += 0.005;
        }
    }
    else {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.90) {
            self.progressView.progress = 0.90;
        }
    }
}

#pragma mark
#pragma mark - New User Delegates
#pragma mark

bool removeNewUserView = NO;

-(void)newUserCancelled {
    [self.scrollLogin scrollRectToVisible:self.viewSignUp.frame animated:YES];
    removeNewUserView = YES;
}

-(void)newUserCreated:(NSString *)email pw:(NSString *)password {

    //check to make sure they aren't an existing user
    //if so, log in
    PFUser *user = [PFUser user];
    user.username = email;
    user.password = password;
    user.email = email;
    
    //try to log in first
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
        if (error) {
            //no user found, sign them up
            if (error.code == 205) {
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        if ((error.code == 202) || (error.code == 203)) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username taken" message:@"The email you provided has already been taken." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    } else {
                        //get a nickname
                        NSLog(@"need a nickname");
                    }
                }];
            }
        } else {
            NSLog(@"logged iiiiin");
            [self useApp];
        }
    }];
}

-(void)loginWithEmail:(NSString *)email andPW:(NSString *)password {
 
    [PFUser logInWithUsernameInBackground:email
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        if (!error) {
                                            //successful login
                                            NSLog(@"logged in instead of new user");
                                            if (![self doesUserHaveNickname]) {
                                                
                                            } else {
                                                [self useApp];
                                            }
                                        } else {
                                            NSString *errorString = [error userInfo][@"error"];
                                            NSLog(@"Error creating account: %@", errorString);
                                        }
                                        
                                    }];
}

-(BOOL)doesUserHaveNickname {
    PFUser *user = [PFUser currentUser];
    if (user[@"screenname"]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark
#pragma mark - UIScrollView Delegates
#pragma mark

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (removeNewUserView) {
        [self.viewNewUser removeFromSuperview];
        removeNewUserView = NO;
    }
}

@end
