//
//  CBFeedback.h
//  CorpBoard
//
//  Created by Justin Moore on 5/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol feedbackProtocol <NSObject>
-(void)cancelled;
@end


@interface CBFeedback : UIView <UITableViewDelegate, UITableViewDataSource> {
    id delegate;
}
@property (nonatomic, strong) IBOutlet UITableView *tableFeedback;
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
-(void)closeView;
@end
