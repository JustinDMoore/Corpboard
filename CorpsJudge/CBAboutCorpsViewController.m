//
//  CBAboutCorpsViewController.m
//  CorpBoard
//
//  Created by Justin Moore on 12/27/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBAboutCorpsViewController.h"

@interface CBAboutCorpsViewController ()

@end

@implementation CBAboutCorpsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 20.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.title = @"About";
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"BackArrow"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
}

-(void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"about"];
        
    UILabel *lblAbout = (UILabel *)[cell viewWithTag:1];
    lblAbout.text = self.about;
    [lblAbout sizeToFit];
    
    return cell;
}

@end
