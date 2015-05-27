//
//  CBStartReview.h
//  Corpboard
//
//  Created by Justin Moore on 5/26/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBShowReviewProtocol <NSObject>
@required
-(void)reviewCancelled;
-(void)reviewSent;
@end

@interface CBStartReview : UIView {
    id delegate;
}

@property (nonatomic, strong) IBOutlet UITableView *tableReview;
@property (nonatomic) BOOL loaded;

-(void)setDelegate:(id)newDelegate;
-(void)showInParent;

@end
