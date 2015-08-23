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
-(void)incrementQty;
-(void)decrementQty;
-(void)itemRemoved;
-(void)itemCancelAnimationWillStart;
-(void)itemCancelAnimationComplete;
@end

@interface CBCartEditItem : UIView {
    id delegate;
}
@property (nonatomic, strong) IBOutlet UILabel *lblQty;
-(void)setDelegate:(id)newDelegate;
-(void)showAtRect:(CGRect)rect animateRight:(BOOL)right;
@end
