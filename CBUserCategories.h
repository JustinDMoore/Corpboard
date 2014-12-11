//
//  CBUserCategories.h
//  CorpBoard
//
//  Created by Isaias Favela on 12/11/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAppDelegate.h"

@interface CBUserCategories : UIView <UITableViewDataSource, UITableViewDelegate> {
    id delegate;
    CBAppDelegate *del;
}

@property (nonatomic, strong) IBOutlet UITableView *tableCategories;

-(void)setDelegate:(id)newDelegate;
@end
