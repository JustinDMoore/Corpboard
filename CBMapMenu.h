//
//  CBMapMenu.h
//  CorpBoard
//
//  Created by Justin Moore on 4/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBMapMenu : UIView {
    id delegate;
}

@property (weak, nonatomic) IBOutlet UITableView *tableCorps;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
-(void)closeView;

@end
