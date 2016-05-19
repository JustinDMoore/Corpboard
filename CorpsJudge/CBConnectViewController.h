//
//  CBConnectViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 5/7/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Corpsboard-Swift.h"

@interface CBConnectViewController : UICollectionViewController <delegateUserLocation>
@property (nonatomic, strong) NSMutableArray *arrayOfUsers;
@end
