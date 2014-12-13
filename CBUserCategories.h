//
//  CBUserCategories.h
//  CorpBoard
//
//  Created by Isaias Favela on 12/11/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBAppDelegate.h"

@protocol CBUserCategoriesProtocol <NSObject>

-(void)categoriesClosed;
-(void)savedCategories;

@end

@interface CBUserCategories : UIView {
    id delegate;
    CBAppDelegate *del;
}

@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) IBOutlet UITableView *tableCategories;
@property (nonatomic, strong) NSArray *arrayOfCategories;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
-(void)setCategories:(NSArray *)arr;
@end
