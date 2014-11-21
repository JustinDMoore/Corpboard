//
//  CBRateView.h
//  CorpBoard
//
//  Created by Isaias Favela on 11/20/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RateProtocol <NSObject>
@required
-(void)rateSubmitted:(int)numberStars;
-(void)rateCancelled;
@end

@interface CBRateView : UIView {
    id delegate;

}

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;

@end
