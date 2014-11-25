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
@property (nonatomic, strong) NSMutableArray *arrayOfSubviews;
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

-(void)viewDidAppear:(BOOL)animated {
    
    self.currentUser = [PFUser currentUser];
    if (self.currentUser) {
        [self.currentUser fetchInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
    } else {
        // NEW USER, SHOW THE NEW USER DIALOG
        NSLog(@"New user.");
        [self addView:self.viewNewUser andScroll:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [CSSingle data];
    [data setDelegate:self];
    self.navigationController.navigationBarHidden = YES;

}

-(void)callbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
    
    NSString *name = self.currentUser[@"nickname"];
    if ([name length]) {
        NSLog(@"has nickname");
        [self loadData];
    } else {
        NSLog(@"no nickname");
        [self addView:self.viewNickname andScroll:YES];
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
    [self addView:self.viewProgress andScroll:NO];
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
        [self removeViewFromScrollView:self.viewNewUser];
        removeNewUserView = NO;
    }
    
    if (removeSignInView) {
        [self removeViewFromScrollView:self.viewSignIn];
        removeSignInView = NO;
    }
    
    if (removeEmailView) {
        [self removeViewFromScrollView:self.viewEmailLogin];
        removeEmailView = NO;
    }
}

#pragma mark
#pragma mark - Protocol Methods
#pragma mark

//CBIsNewUser.h
-(void)isNewUser:(BOOL)newUser {
    self.isNewUser = newUser;
    [self addView:self.viewSignIn andScroll:YES];
    //[self.scrollLogin addSubview:self.viewSignIn];
    
    if (!newUser) [self.viewSignIn setTitleMessage:@"SIGN IN USING"];
    else [self.viewSignIn setTitleMessage:@"SIGN UP USING"];
    
//    self.viewSignIn.frame = CGRectMake(self.viewNewUser.frame.origin.x + self.viewSignIn.frame.size.width, self.viewSignIn.frame.origin.y, self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);
//
//    self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.contentSize.width + self.viewSignIn.frame.size.width, self.scrollLogin.contentSize.height + self.viewSignIn.frame.size.height);
//    [self.scrollLogin scrollRectToVisible:self.viewSignIn.frame animated:YES];
}

//SIGN IN/SIGN UP
-(void)SignInCancelled {
    removeSignInView = YES;
    [self.scrollLogin scrollRectToVisible:self.viewNewUser.frame animated:YES];
    
}

-(void)loginSuccessful:(BOOL)needsNickName {
    if (!needsNickName) {
        [self loadData];
    } else {
        [self addView:self.viewNickname andScroll:YES];
    }
}

-(void)emailSelected {
    [self addView:self.viewEmailLogin andScroll:YES];
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

-(void)addView:(UIView *)viewToAdd andScroll:(BOOL)scroll {
    
    viewToAdd.frame = CGRectMake(viewToAdd.frame.origin.x, viewToAdd.frame.origin.y, self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);
    
    
    if ([self.arrayOfSubviews count]) {
        UIView *view = [self.arrayOfSubviews lastObject];
        viewToAdd.frame = CGRectMake(view.frame.origin.x + view.frame.size.width, 0, self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);
        self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.contentSize.width + self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);
    } else {
        viewToAdd.frame = CGRectMake(self.scrollLogin.frame.size.width, 0, self.scrollLogin.frame.size.width, self.scrollLogin.frame.size.height);
        self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.frame.size.width * 2, self.scrollLogin.frame.size.height);
    }

    [self.scrollLogin addSubview:viewToAdd];
    [self.scrollLogin scrollRectToVisible:viewToAdd.frame animated:scroll];
    
    
    [self.arrayOfSubviews addObject:viewToAdd];

}

-(void)removeViewFromScrollView:(UIView *)viewToRemove {
    [viewToRemove removeFromSuperview];
    self.scrollLogin.contentSize = CGSizeMake(self.scrollLogin.contentSize.width - self.scrollLogin.frame.size.width, self.scrollLogin.contentSize.height);
    for (UIView *view in self.arrayOfSubviews) {
        if (view == viewToRemove) {
            [self.arrayOfSubviews removeObject:view];
        }
    }
}

-(NSMutableArray *)arrayOfSubviews {
    if (!_arrayOfSubviews) {
        _arrayOfSubviews = [[NSMutableArray alloc] init];
    }
    return _arrayOfSubviews;
}

-(CBNicknameView *)viewNickname {
    if (!_viewNickname) {
        _viewNickname =
        [[[NSBundle mainBundle] loadNibNamed:@"CBNickname"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        [_viewNickname setDelegate:self];
    }
    return _viewNickname;
}

-(CBIsNewUser *)viewNewUser {
    if (!_viewNewUser) {
        _viewNewUser =
        [[[NSBundle mainBundle] loadNibNamed:@"CBIsNewUser"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        [_viewNewUser setDelegate:self];
    }
    return _viewNewUser;
}

-(CBViewSignIn *)viewSignIn {
    if (!_viewSignIn) {
        _viewSignIn =
        [[[NSBundle mainBundle] loadNibNamed:@"CBViewSignIn"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        [_viewSignIn setDelegate:self];
    }
    return _viewSignIn;
}

-(CBEmailLogin *)viewEmailLogin {
    if (!_viewEmailLogin) {
        self.viewEmailLogin =
        [[[NSBundle mainBundle] loadNibNamed:@"CBEmailLogin"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        [_viewEmailLogin setDelegate:self];
    }
    return _viewEmailLogin;
}

-(CBProgressView *)viewProgress {
    if (!_viewProgress) {
        _viewProgress =
        [[[NSBundle mainBundle] loadNibNamed:@"CBProgressView"
                                       owner:self
                                     options:nil]
         objectAtIndex:0];
        [_viewProgress setDelegate:self];
    }
    return _viewProgress;
}

@end
