//
//  CBReviewShow.h
//  CorpBoard
//
//  Created by Justin Moore on 5/12/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reviewShowProtocol <NSObject>
@required
-(void)cancelSubmitReview;
-(void)submitReview;
@end

@interface CBReviewShow : UIView {
    id delegate;
}

@property (nonatomic, strong) IBOutlet UITableView *tableRecap;


-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;

@end
