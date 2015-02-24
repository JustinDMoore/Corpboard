//
//  CBAdminTableViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 2/22/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBAdminTableViewController : UITableViewController

typedef enum {
    feedback,
    bugs,
    photos,
    reports
} adminType;

@property (nonatomic) adminType type;

@end
