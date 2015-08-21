//
//  CBStoreItemSelector.h
//  Corpboard
//
//  Created by Justin Moore on 8/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoreItemSelectorProtocol <NSObject>
@required
-(void)indexSelected;
-(void)selectorCancelled;
@end

@interface CBStoreItemSelector : UIView {
    id delegate;
}
@property (nonatomic, weak) IBOutlet UITableView *tableSelector;
-(IBAction)btnClose:(id)sender;
-(void)setDelegate:(id)newDelegate;
-(void)showInParent:(CGRect)parent;
-(void)closeView:(BOOL)cancelled;
@end
