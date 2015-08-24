//
//  CBCartEditItem.h
//  Corpboard
//
//  Created by Isaias Favela on 8/22/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CartEditItemProtocol <NSObject>
@required
-(void)newQuantity:(int)newQty;
-(void)itemRemoved;
-(void)itemCancelAnimationWillStart;
-(void)itemCancelAnimationComplete;
@end

@interface CBCartEditItem : UIView {
    id delegate;
}
@property (nonatomic) int quantity;
@property (nonatomic, strong) IBOutlet UILabel *lblQty;
-(void)setDelegate:(id)newDelegate;
-(void)showAtRect:(CGRect)sRect endAtRect:(CGRect)eRect withQty:(int)qty;
-(void)closeView;
@end
