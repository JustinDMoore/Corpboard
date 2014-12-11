//
//  CBUserProfileViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 12/10/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBUserProfileViewController.h"
#import "CBUserCategories.h"

@interface CBUserProfileViewController ()
@property (nonatomic, strong) CBUserCategories *userCat;
@end

@implementation CBUserProfileViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"BackArrow"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    PFUser *cUser = [PFUser currentUser];
    if ([self.userProfile.objectId isEqualToString: cUser.objectId]) {
        UIButton *configBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *configBtnImage = [UIImage imageNamed:@"Config"];
        [configBtn setBackgroundImage:configBtnImage forState:UIControlStateNormal];
        [configBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
        configBtn.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *configBarButton = [[UIBarButtonItem alloc] initWithCustomView:configBtn] ;
        self.navigationItem.rightBarButtonItem = configBarButton;
        self.viewControls.hidden = YES;
    } else {
        self.viewControls.hidden = NO;
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2;
    self.imgUser.layer.masksToBounds = YES;
    
    PFFile *imgFile = self.userProfile[@"picture"];
    
    [self.imgUser setFile:imgFile];
    [self.imgUser loadInBackground];
    
    self.lblUserNickname.text = self.userProfile[@"nickname"];
    self.lblUserLocation.text = @"Lives in Twentynine Palms, CA";
    self.lblViews.text = @"Joined 12/2014  |  1,000 Views  |  3 Show Reviews";
    
    [self.view addSubview:self.userCat];
}

-(void)goback {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUser:(PFUser *)user {
    self.userProfile = user;
    
    
}

-(void)incrementProfileViews {
    //call cloud code
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CBUserCategories *)userCat {
    if (!_userCat) {
        _userCat = [[[NSBundle mainBundle] loadNibNamed:@"CBUserCategories"
                                                      owner:self
                                                    options:nil]
                        objectAtIndex:0];
        [_userCat setDelegate:self];
    }
    return _userCat;
}


@end
