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
@property (nonatomic, strong) CBIsNewUser *viewNewUser;
@property (nonatomic, strong) CBViewSignIn *viewSignIn;
@property (nonatomic, strong) CBEmailLogin *viewEmailLogin;
@property (nonatomic, strong) CBNicknameView *viewNickname;
@property (nonatomic, strong) CBProgressView *viewProgress;

@property (nonatomic) BOOL isNewUser;

@property (nonatomic) BOOL theBool;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) PFUser *currentUser;

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

    self.currentUser = [PFUser currentUser];
    [self.currentUser fetchInBackground];
    self.viewNewUser =
    [[[NSBundle mainBundle] loadNibNamed:@"CBIsNewUser"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    
    self.viewSignIn =
    [[[NSBundle mainBundle] loadNibNamed:@"CBViewSignIn"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    
    self.viewEmailLogin =
    [[[NSBundle mainBundle] loadNibNamed:@"CBEmailLogin"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
   
    self.viewNickname =
    [[[NSBundle mainBundle] loadNibNamed:@"CBNickname"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    
    self.viewProgress =
    [[[NSBundle mainBundle] loadNibNamed:@"CBProgressView"
                                   owner:self
                                 options:nil]
     objectAtIndex:0];
    
    
    [self.viewNewUser setDelegate:self];
    [self.viewSignIn setDelegate:self];
    [self.viewEmailLogin setDelegate:self];
    [self.viewNickname setDelegate:self];
    [self.viewProgress setDelegate:self];
   
    
    if (self.currentUser) {
        // EXISTING USER, START THE PROGRESS BAR
        // AND START DOWNLOADING DATA
        NSString *name = self.currentUser[@"nickname"];
        if ([name length]) {
            NSLog(@"has nickname");
            [self loadData];
        } else {
            NSLog(@"no nickname");
            [self.scrollLogin addSubview:self.viewNickname];
            self.viewNickname.frame = CGRectMake(0 + self.scrollLogin.frame.size.width, -30, self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);
            self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.frame.size.width + self.viewNickname.frame.size.width, self.scrollLogin.frame.size.height);
            [self.scrollLogin scrollRectToVisible:self.viewNickname.frame animated:YES];
            self.viewNickname.viewToScroll = self.view;
        }
    } else {
        // NEW USER, SHOW THE NEW USER DIALOG
        NSLog(@"New user.");
        [self.scrollLogin addSubview:self.viewNewUser];
        self.viewNewUser.frame = CGRectMake(0, 0, self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);
        self.scrollLogin.contentSize = CGSizeMake(self.viewNewUser.frame.size.width, self.viewNewUser.frame.size.height);
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
#pragma mark - Loading Data
#pragma mark

-(void)loadData {
    [self.scrollLogin addSubview:self.viewProgress];
    self.viewProgress.frame = CGRectMake(self.viewProgress.frame.size.width, 0, self.viewProgress.frame.size.width, self.viewProgress.frame.size.height);
    self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.frame.size.width + self.viewProgress.frame.size.width, self.scrollLogin.frame.size.height + self.viewProgress.frame.size.height);
    [self.scrollLogin scrollRectToVisible:self.viewProgress.frame animated:YES];
    
    [self.viewProgress startProgress];
    [data getAllCorpsFromServer];
    [data getAllShowsFromServer];
}

-(void)finishedLoadingData {
    [self.viewProgress stopProgress];
    [self performSelector:@selector(useApp) withObject:nil afterDelay:.5];
}

#pragma mark
#pragma mark - UIScrollView Delegates
#pragma mark
bool removeNewUserView = NO;
bool removeSignInView = NO;
bool removeEmailView = NO;
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (removeNewUserView) {
        [self.viewEmailLogin removeFromSuperview];
        removeNewUserView = NO;
    }
    
    if (removeSignInView) {
        [self.viewSignIn removeFromSuperview];
        self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.contentSize.width - self.viewSignIn.frame.size.width, self.scrollLogin.contentSize.height);
        removeSignInView = NO;
    }
    
    if (removeEmailView) {
        [self.viewEmailLogin removeFromSuperview];
        self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.contentSize.width - self.viewEmailLogin.frame.size.width, self.scrollLogin.contentSize.height);
        removeEmailView = NO;
    }
}

#pragma mark
#pragma mark - Protocol Methods
#pragma mark

//CBIsNewUser.h
-(void)isNewUser:(BOOL)newUser {
    self.isNewUser = newUser;
    [self.scrollLogin addSubview:self.viewSignIn];
    
    if (!newUser) [self.viewSignIn setTitleMessage:@"SIGN IN USING"];
    else [self.viewSignIn setTitleMessage:@"SIGN UP USING"];
    
    self.viewSignIn.frame = CGRectMake(self.viewNewUser.frame.origin.x + self.viewSignIn.frame.size.width, self.viewSignIn.frame.origin.y, self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);

    self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.contentSize.width + self.viewSignIn.frame.size.width, self.scrollLogin.contentSize.height + self.viewSignIn.frame.size.height);
    [self.scrollLogin scrollRectToVisible:self.viewSignIn.frame animated:YES];
}

//SIGN IN/SIGN UP
-(void)SignInCancelled {
    [self.scrollLogin scrollRectToVisible:self.viewNewUser.frame animated:YES];
    removeSignInView = YES;
}

-(void)loginSuccessful:(BOOL)needsNickName {
    if (!needsNickName) {
        [self loadData];
    } else {
        [self.scrollLogin addSubview:self.viewNickname];
        self.viewNickname.frame = CGRectMake(self.viewSignIn.frame.origin.x + self.viewSignIn.frame.size.width, self.viewSignIn.frame.origin.y, self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);
        self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.contentSize.width + self.viewNickname.frame.size.width, self.scrollLogin.contentSize.height);
        [self.scrollLogin scrollRectToVisible:self.viewNickname.frame animated:YES];
    }
}

-(void)emailSelected {
    [self.scrollLogin addSubview:self.viewEmailLogin];
    self.viewEmailLogin.frame = CGRectMake(self.viewSignIn.frame.origin.x + self.viewSignIn.frame.size.width, self.viewSignIn.frame.origin.y, self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);
    self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.contentSize.width + self.viewEmailLogin.frame.size.width, self.scrollLogin.contentSize.height);
    [self.scrollLogin scrollRectToVisible:self.viewEmailLogin.frame animated:YES];
    self.viewEmailLogin.isNewUser = self.isNewUser;
    self.viewEmailLogin.viewToScroll = self.view;
}

-(void)emailCancelled {
    [self.scrollLogin scrollRectToVisible:self.viewSignIn.frame animated:YES];
    removeEmailView = YES;
}

-(void)successfulLoginFromEmail {
    [self loadData];
}

-(void)nicknameChosen {
    [self loadData];
}

@end
