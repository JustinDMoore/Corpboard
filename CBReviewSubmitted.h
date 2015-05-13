//
//  CBReviewSubmitted.h
//  CorpBoard
//
//  Created by Justin Moore on 5/13/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol showReviewProtocol <NSObject>
@required
-(void)thankYouDone;
@end

@interface CBReviewSubmitted : UIView {
    id delegate;
}

-(void)setDelegate:(id)newDelegate;
-(void)showInParent;
@end
