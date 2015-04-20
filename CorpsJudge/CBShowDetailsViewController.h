//
//  CBShowDetailsViewController.h
//  CorpsBoard
//
//  Created by Justin Moore on 6/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CBEndShowViewController.h"

@interface CBShowDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, endShowProtocol>

@property (nonatomic, strong) PFObject *show;
@property (nonatomic) BOOL fromMaps;
@end
