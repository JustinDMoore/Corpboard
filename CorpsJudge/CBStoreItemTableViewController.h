//
//  CBStoreItemTableViewController.h
//  Corpboard
//
//  Created by Justin Moore on 8/20/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CBStoreItemSelector.h"

@interface CBStoreItemTableViewController : UITableViewController
@property (nonatomic, strong) PFObject *item;
@end
