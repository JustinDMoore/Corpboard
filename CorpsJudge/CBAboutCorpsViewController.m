//
//  CBAboutCorpsViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 12/27/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBAboutCorpsViewController.h"
#import "Corpsboard-Swift.h"

@interface CBAboutCorpsViewController ()

@end

@implementation CBAboutCorpsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.title = @"About";
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UISingleton.sharedInstance getBackButton];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.lblAbout setText:self.about];
    [self.lblAbout sizeToFit];
    self.lblAbout.editable = NO;
}

-(void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews {
    
    [self.lblAbout setContentOffset:CGPointZero animated:NO];
}

@end
