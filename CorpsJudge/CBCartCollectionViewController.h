//
//  CBCartCollectionViewController.h
//  Corpboard
//
//  Created by Isaias Favela on 8/21/15.
//  Copyright (c) 2015 Justin Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBCartItemCell.h"
#import "CBCartEditItem.h"

@interface CBCartCollectionViewController : UIViewController <CartEditItemProtocol, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckout;
@property (weak, nonatomic) IBOutlet UIView *viewCheckout;

@end
