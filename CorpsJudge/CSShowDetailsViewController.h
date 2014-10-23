//
//  CSShowDetailsViewController.h
//  CorpsJudge
//
//  Created by Justin Moore on 6/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface CSShowDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PFObject *show;
@property (weak, nonatomic) IBOutlet UIButton *btnJudge;

@end
