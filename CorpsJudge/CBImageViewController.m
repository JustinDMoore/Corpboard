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
    //self.imgViewPicture.image = self.imgPicture;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
