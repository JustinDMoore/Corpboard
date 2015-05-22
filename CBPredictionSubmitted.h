//
//  CBPredictionSubmitted.h
//  CorpBoard
//
//  Created by Justin Moore on 5/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol predictionThankYouProtocol <NSObject>
@required
-(void)predictionThankYou;
@end

@interface CBPredictionSubmitted : UIView {
    id delegate;
}

@property (nonatomic, strong) UILabel *lblMessage;

-(void)setDelegate:(id)newDelegate;
-(void)show;

@end
