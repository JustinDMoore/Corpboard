//
//  CBThankYou.h
//  CorpBoard
//
//  Created by Justin Moore on 5/2/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol thankYouProtocol <NSObject>
@required
-(void)thankYou;
@end

@interface CBThankYou : UIView {
    id delegate;
}

-(void)setDelegate:(id)newDelegate;
-(void)showInParent;

@end
