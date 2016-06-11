//
//  CBUserCategories.h
//  CorpBoard
//
//  Created by Isaias Favela on 12/11/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBUserCategoriesProtocol <NSObject>

-(void)categoriesClosed;
-(void)savedCategories;

@end

@interface CBUserCategories : UIView <UITableViewDelegate, UITableViewDataSource> {
    id delegate;
}

@property (nonatomic, strong) NSMutableDictionary *dict;
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UITableView *tableCategories;
@property (nonatomic, strong) NSArray *arrayOfCategories;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *viewDialog;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(UINavigationController *)parentNav;
-(void)setCategories:(NSArray *)arr;
@end
