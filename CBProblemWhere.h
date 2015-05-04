//
//  CBProblemWhere.h
//  CorpBoard
//
//  Created by Isaias Favela on 1/4/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol problemWhereProtocol <NSObject>
-(void)problemWhereCanceled;
@end

@interface CBProblemWhere : UIView {
     id delegate;
}

@property (nonatomic, strong) IBOutlet UITableView *tableProblem;

@property (nonatomic, strong) NSArray *arrayOfProblemAreas;
@property (nonatomic, strong) NSArray *arrayOfProblemImages;
-(void)showInParent;
-(void)closeView:(BOOL)cancelled;
-(void)setDelegate:(id)newDelegate;
@end
