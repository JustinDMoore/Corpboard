//
//  CBProblemTableViewController.h
//  CorpBoard
//
//  Created by Justin Moore on 11/8/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBProblemWhere.h"

@interface CBProblemTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, problemWhereProtocol, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

}

@property (nonatomic) BOOL problem;

@end
