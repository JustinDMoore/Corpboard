//
//  CBChooseCorp.h
//  CorpBoard
//
//  Created by Justin Moore on 12/13/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol corpSelectionProtocol <NSObject>

@required
-(void)corpSelected;
-(void)selectionCanceled;
@end

@interface CBChooseCorp : UIView {
    id delegate;
}

-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;

@end
