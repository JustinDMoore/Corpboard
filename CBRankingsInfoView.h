//
//  CBRankingsInfoView.h
//  CorpBoard
//
//  Created by Isaias Favela on 11/20/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RankInfoProtocol <NSObject>
@required
-(void)viewDidClose;
@end

@interface CBRankingsInfoView : UIView {
    id delegate;
}
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
@end
