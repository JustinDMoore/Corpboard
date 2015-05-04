//
//  CBProblemWhere.m
//  CorpBoard
//
//  Created by Isaias Favela on 1/4/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import "CBProblemWhere.h"

@implementation CBProblemWhere {
    CGRect parentRect;
}


-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // CUSTOM INITIALIZATION HERE
        
    }
    return self;
}

-(void)setDelegate:(id)newDelegate{
    delegate = newDelegate;
}

-(void)showInParent {

    self.arrayOfProblemAreas = @[@"About the Corps",
                                 @"Friends or Profiles",
                                 @"Live Chat",
                                 @"News",
                                 @"Private Messages",
                                 @"Rankings",
                                 @"Scores",
                                 @"Show Information",
                                 @"Show Reviews",
                                 @"Other"];
    
    self.arrayOfProblemImages = @[[UIImage imageNamed:@"problemAbout"],
                                  [UIImage imageNamed:@"problemFriends"],
                                  [UIImage imageNamed:@"problemLiveChat"],
                                  [UIImage imageNamed:@"problemNews"],
                                  [UIImage imageNamed:@"problemMessages"],
                                  [UIImage imageNamed:@"problemRankings"],
                                  [UIImage imageNamed:@"problemScores"],
                                  [UIImage imageNamed:@"problemScores"],
                                  [UIImage imageNamed:@"problemScores"],
                                  [UIImage imageNamed:@"problemOther"]];
    self.tableProblem.alpha = 0;
    [self.tableProblem reloadData];
    [self.tableProblem scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                     atScrollPosition:UITableViewScrollPositionTop animated:NO];

    [UIView animateWithDuration:.15 animations:^{
        self.tableProblem.alpha = 1;
        [self.tableProblem scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)btnCancel_clicked:(id)sender {
    if ([delegate respondsToSelector:@selector(problemWhereCanceled)]) {
        [delegate problemWhereCanceled];
    }
}

-(NSArray *)arrayOfProblemAreas {
    if (!_arrayOfProblemAreas) {
        _arrayOfProblemAreas = [NSArray array];
    }
                                return _arrayOfProblemAreas;
}

-(NSArray *)arrayOfProblemImages {
    if (!_arrayOfProblemImages) {
        _arrayOfProblemImages = [NSArray array];
    }
    return _arrayOfProblemImages;
}
@end
