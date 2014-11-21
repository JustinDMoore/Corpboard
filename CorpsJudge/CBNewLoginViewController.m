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
@property (nonatomic) BOOL theBool;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *lblSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblDisclaimer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

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
    
    self.lblSignIn.alpha = 0;
    self.btnFacebook.alpha = 0;
    self.btnTwitter.alpha = 0;
    self.btnEmail.alpha = 0;
    self.lblDisclaimer.alpha = 0;
    
    self.lblSignIn.hidden = YES;
    self.btnFacebook.hidden = YES;
    self.btnTwitter.hidden = YES;
    self.btnEmail.hidden = YES;
    self.lblDisclaimer.hidden = YES;
    
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
}

-(void)newUser {
    
    self.lblSignIn.hidden = NO;
    self.btnFacebook.hidden = NO;
    self.btnTwitter.hidden = NO;
    self.btnEmail.hidden = NO;
    self.lblDisclaimer.hidden = NO;
    
    [UIView animateWithDuration:3 animations:^{
        self.lblSignIn.alpha = 1;
        self.btnFacebook.alpha = 1;
        self.btnTwitter.alpha = 1;
        self.btnEmail.alpha = 1;
        self.lblDisclaimer.alpha = 1;
    }];
}

-(void)useApp {
    [self performSegueWithIdentifier:@"menu" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
