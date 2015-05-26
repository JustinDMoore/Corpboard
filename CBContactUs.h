//
//  CBContactUs.h
//  CorpBoard
//
//  Created by Justin Moore on 5/1/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol contactUsProtocol <NSObject>
-(void)cancelled;
@end


@interface CBContactUs : UIView {
    id delegate;
}
@property (nonatomic, strong) IBOutlet UITableView *tableFeedback;
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
-(void)closeView:(BOOL)completely;
@end
