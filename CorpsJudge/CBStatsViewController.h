//
//  CBStatsViewController.h
//  CorpsBoard
//
//  Created by Isaias Favela on 6/23/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBRankingsInfoView.h"

@interface CBStatsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, RankInfoProtocol>
@property (weak, nonatomic) IBOutlet UILabel *lblProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
