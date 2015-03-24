//
//  CBImageViewController.m
//  CorpBoard
//
//  Created by Isaias Favela on 2/17/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBImageViewController.h"

@interface CBImageViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *imgViewPicture;
@end

@implementation CBImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [self.imgPicture class]);
    self.imgViewPicture.image = (UIImage *)self.imgPicture;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

    UIBarButtonItem *btnAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    self.navigationItem.rightBarButtonItem = btnAction;
}

-(void)action {
    
    NSString *actionSheetTitle = nil; //Action Sheet Title
    NSString *other1 = @"Save Image";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:nil
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UIActionSheet
#pragma mark

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            UIImageWriteToSavedPhotosAlbum(self.imgPicture, nil, nil, nil);
            break;

        default:
            break;
    }
}

@end
