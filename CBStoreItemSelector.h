//
//  CBStoreItemSelector.h
//  Corpboard
//
//  Created by Justin Moore on 8/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStoreItemSelectorType.h"

@protocol StoreItemSelectorProtocol <NSObject>
@required
-(void)indexSelected;
-(void)selectorClosedWithSelectedIndex:(int)selectedIndex;
-(void)selectorDidClose;
-(void)selectorWillClose;
@end

@interface CBStoreItemSelector : UIView {
    id delegate;
}
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UITableView *tableSelector;
-(IBAction)btnClose:(id)sender;
-(void)setDelegate:(id)newDelegate;
-(void)showInParentWithSelectorType:(selectType)type;
-(void)closeView:(BOOL)cancelled;
@end
